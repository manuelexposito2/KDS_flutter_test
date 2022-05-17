import 'dart:async';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/response_turno.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/impl_repo/status_order_repository_impl.dart';
import 'package:kds/repository/repository/status_order_repository.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/repository/impl_repo/workers_repository_impl.dart';
import 'package:kds/repository/repository/workers_repository.dart';

import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/screens/error_screen.dart';
import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/screens/loading_screen.dart';
import 'package:kds/ui/styles/styles.dart';
import "package:collection/collection.dart";
import 'package:kds/ui/widgets/order_card.dart';
import 'package:kds/ui/screens/waiting_screen.dart';
import 'package:kds/ui/widgets/resume_orders.dart';
import 'package:kds/ui/widgets/timer_widget.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/user_shared_preferences.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';
//import 'dart:html';

class OrdersList extends StatefulWidget {
  OrdersList({Key? key, this.socket, required this.config}) : super(key: key);
  Socket? socket;
  Config config;
  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController operarioController = TextEditingController();
  late OrderRepository orderRepository;
  late WorkersRepository workersRepository;
  late StatusOrderRepository statusOrderRepository;
  String? filter = '';

  int numOrders = 0;

  bool showResumen = false;
  bool showOperarioDialog = false;
  String? mensaje;
  List<String> resumeList = [];
  List<Order>? ordersList = [];
  List<Order>? mensajes = [];
  Order? selectedOrder;
  ResponseTurno? responseTurno;

  bool activeB = false;

  final player = AudioPlayer(androidApplyAudioAttributes: true);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    orderRepository = OrderRepositoryImpl();
    workersRepository = WorkersRepositoryImpl();
    statusOrderRepository = StatusOrderRepositoryImpl();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //Trae el sonido de la campana
  doBellRing() async {
    await player.setAudioSource(
        AudioSource.uri(Uri.parse("asset:///assets/sounds/bell_ring.mp3")),
        initialPosition: Duration.zero);

    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    //Socket encargado de escuchar si está activado el sonido, de ser así lanzará el evento cada que llegue una comanda nueva o cambie el estado urgente
    widget.socket!.on(WebSocketEvents.newOrder, (data) {
      //Si se activa  en configuración el sonido sonará la campana al crear una nueva orden
      if (widget.config.sonido!.contains("S")) {
        doBellRing();
      }

      Order newOrder = Order.fromJson(data);

      if (newOrder.camEstado == "M") {
        setState(() {
          ordersList!.insert(0, newOrder);
        });
      } else {
        setState(() {
          ordersList!.add(newOrder);
        });
      }
    });

    //Evento que ocurre al ocurrir un error en los estados de las comandas
    widget.socket!.on(
        WebSocketEvents.errorNotifyOrden,
        (data) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: errorDialogOrder(),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Entendido'),
                    onPressed: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomeScreen(
                                  socket: widget.socket,
                                  config: widget.config,
                                )),
                      );
                    },
                  ),
                ],
              );
            },
            barrierDismissible: true));

    //Evento que ocurre al ocurrir un error en los estados de los detalles
    widget.socket!.on(
        WebSocketEvents.errorNotifyDetail,
        (data) => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: errorDialogDetail(),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Entendido'),
                    onPressed: () {
                      Navigator.pushReplacement<void, void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomeScreen(
                                  socket: widget.socket,
                                  config: widget.config,
                                )),
                      );
                    },
                  ),
                ],
              );
            },
            barrierDismissible: true));

    //ESCUCHA PARA BORRAR LA COMANDA CUANDO ESTÉ TERMINADA
    //TODO: Animacion para la comanda que se borra
    widget.socket!.on(WebSocketEvents.modifyOrder, ((data) {
      OrderDto newStatus = OrderDto.fromJson(data);

      setState(() {
        resumeList = _refillResumeList(ordersList!);
      });

      if (newStatus.status!.contains("P")) {
        setState(() {
          ordersList!.where(
              (element) => element.camId.toString() == newStatus.idOrder);
        });
      }

      if (newStatus.status!.contains("T") || newStatus.status!.contains("R")) {
        setState(() {
          ordersList!.removeWhere(
              (element) => element.camId.toString() == newStatus.idOrder);
        });
      }

      if (filter!.contains(terminadas) && newStatus.status!.contains("E") ||
          filter!.contains(recoger) && newStatus.status!.contains("T")) {
        setState(() {
          ordersList!.removeWhere(
              (element) => element.camId.toString() == newStatus.idOrder);
        });
      }
    }));

    widget.socket!.on(WebSocketEvents.modifyDetail, (data) {
      DetailDto detailDto = DetailDto.fromJson(data);

      setState(() {
        ordersList!
            .where((element) => element.camId.toString() == detailDto.idOrder);
      });
    });

    //Dependiendo del estado de la respuesta cargará una pantalla u otra
    return Scaffold(
      body: FutureBuilder(
          future: orderRepository.getOrders(filter!, widget.config),
          builder: (context, snapshot) {
            //Se gestionan los distintos estados cuando se carga el cuerpo
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasError &&
                !snapshot.hasData) {
              return LoadingScreen(message: "Cargando...");
            }
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError &&
                !snapshot.hasData) {
              return WaitingScreen();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError && !snapshot.hasData) {
              print(ordersList!.length);
              print(snapshot.error);
              return ErrorScreen(
                config: widget.config,
                socket: widget.socket!,
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting &&
                    snapshot.hasData) {
              mensajes!.clear();
              ordersList = snapshot.data as List<Order>;

            
              //numOrders = ordersList!.length;

              //Meto en la variable de mensajes todos los Mensajes de la lista
              mensajes!.addAll(ordersList!
                  .where((element) => element.camEstado!.contains("M")));

              //Elimino los mensajes de la lista original
              ordersList!
                  .removeWhere((element) => element.camEstado!.contains("M"));

              ordersList!.insertAll(0, mensajes!.reversed);
              //debugPrint(mensajes.length.toString());

              resumeList = _refillResumeList(ordersList!);

              return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 1350) {
                  return screen(130);
                } else if (constraints.maxWidth > 1000) {
                  return screen(250);
                } else {
                  return screen(390);
                }
              });
            } else {
              return WaitingScreen();
            }
          }),
    );
  }

  Widget screen(double margen) {
    return Stack(
      children: [
        ordersList!.isNotEmpty
            ? Container(
                margin: EdgeInsets.only(bottom: margen),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: responsiveOrder()),
                    showResumen
                        ? Expanded(
                            flex: 1,
                            child: ResumeOrdersWidget(
                              lineasComandas: reordering(resumeList),
                              socket: widget.socket,
                            ))
                        : Container(),
                  ],
                ),
              )
            : WaitingScreen(),
        Positioned(
            bottom: 0,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: bottomNavBar(context)))
      ],
    );
  }

  //Widget de error de evento errorNotifyOrden
  Widget errorDialogOrder() {
    return SingleChildScrollView(
      child: ListBody(
        children: const <Widget>[
          Text(
            'ATENCIÓN',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('No se ha podido guardar la comanda'),
        ],
      ),
    );
  }

  //Widget de error de evento errorNotifyDetail
  Widget errorDialogDetail() {
    return SingleChildScrollView(
      child: ListBody(
        children: const <Widget>[
          Text(
            'ATENCIÓN',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text('No se ha podido guardar la comanda'),
        ],
      ),
    );
  }

  //Toma las comandas y devuelve todos los detalles de las comandas siguiendo una serie de filtros
  //Se usa para el botón de resumen
  List<String> _refillResumeList(List<Order> ordersList) {
    resumeList.clear();
    for (var comanda in ordersList) {
      if (comanda.details.isNotEmpty) {
        for (var d in comanda.details) {
          if (d.demEstado != "M") {
            if (d.demTitulo!.split("X").length == 2 &&
                d.demArti != demArticuloSeparador &&
                (d.demEstado!.contains("E") ||
                    d.demEstado!.contains("P") ||
                    (filter == recoger && d.demEstado!.contains("R")))) {
              resumeList.add(d.demTitulo!);
            }
          }
        }
      }
    }
    return resumeList;
  }

  //Imprime la lista de ordenes dependiendo del tamaño de la pantalla
  Widget responsiveOrder() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      //Al usar GriwView, debido a que dependiendo del tamaño de la pantalla los items
      //cambian su tamaño, para mayor uniformidad se creó esta serie de  condicionales
      var responsiveCrossAxisCount = 6;
      if (constraints.minWidth > 1700) {
        responsiveCrossAxisCount = 5;
      } else if (constraints.minWidth > 1500) {
        responsiveCrossAxisCount = 5;
      } else if (constraints.minWidth > 1300) {
        responsiveCrossAxisCount = 4;
      } else if (constraints.minWidth > 900) {
        responsiveCrossAxisCount = 3;
      } else if (constraints.minWidth > 500) {
        responsiveCrossAxisCount = 2;
      } else {
        responsiveCrossAxisCount = 1;
      }
      (constraints.minWidth);
      return DynamicHeightGridView(
        builder: (context, index) => OrderCard(
          order: ordersList!.elementAt(index),
          socket: widget.socket,
          config: widget.config,
        ),
        itemCount: ordersList!.length,
        crossAxisCount: responsiveCrossAxisCount,
      );
    });
  }

  //Imprime la barra de navegación
  Widget bottomNavBar(BuildContext context) {
    double responsiveWidth = MediaQuery.of(context).size.width / 40;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.minWidth > 1350) {
        //Dependiendo del tamaño de la pantalla se ordenarán los elementos
        return widget.config.mostrarContadores!.contains(
                "S") //Se mostrará el widget si en configuración numierKDS.ini se encuentra activado "Mostrar_contadores"
            ? Container(
                padding: EdgeInsets.only(top: 10),
                height: Styles.navbarHeightConfMax,
                color: Styles.bottomNavColor,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const TimerWidget(),
                      _buttonsFilter(context),
                      _buttonsOptions()
                    ],
                  ),
                  _contadores()
                ]))
            : //Si no se cumple la condición mostratá el widget de abajo
            Container(
                height: Styles.navbarHeight,
                color: Styles.bottomNavColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const TimerWidget(),
                    _buttonsFilter(context),
                    _buttonsOptions()
                  ],
                ));
      } else if (constraints.minWidth > 1000) {
        return widget.config.mostrarContadores!.contains("S")
            ? Container(
                padding: EdgeInsets.only(top: 10),
                height: Styles.navbarHeightConfMed,
                color: Styles.bottomNavColor,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsiveWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TimerWidget(),
                            _buttonsFilter(context),
                            _buttonsOptions()
                          ],
                        ),
                        _contadores()
                      ],
                    )),
              )
            : Container(
                padding: EdgeInsets.only(top: 10),
                height: Styles.navbarHeightConfMed,
                color: Styles.bottomNavColor,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsiveWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const TimerWidget(),
                            _buttonsFilter(context),
                            _buttonsOptions()
                          ],
                        ),
                      ],
                    )),
              );
      } else {
        if (widget.config.reparto != "S") {
          return widget.config.mostrarContadores!.contains("S")
              ? Container(
                  padding: EdgeInsets.only(top: 10),
                  height: Styles.navbarHeightConfMin,
                  color: Styles.bottomNavColor,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsiveWidth),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const TimerWidget(),
                              _buttonsFilterMin(context),
                              _buttonsOptions()
                            ],
                          ),
                          _contadores()
                        ],
                      )))
              : Container(
                  padding: EdgeInsets.only(top: 10),
                  height: Styles.navbarHeightConfMin,
                  color: Styles.bottomNavColor,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsiveWidth),
                      child: Column(
                        children: [
                          const TimerWidget(),
                          _buttonsFilterMin(context),
                          _buttonsOptions()
                        ],
                      )));
        } else {
          return widget.config.mostrarContadores!.contains("S")
              ? Container(
                  height: Styles.navbarHeightConfMinReparto,
                  color: Styles.bottomNavColor,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsiveWidth),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const TimerWidget(),
                              _buttonsFilterMinReparto(context),
                              _buttonsOptions()
                            ],
                          ),
                          _contadores()
                        ],
                      )))
              : Container(
                  height: Styles.navbarHeightConfMinReparto,
                  color: Styles.bottomNavColor,
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: responsiveWidth),
                      child: Column(
                        children: [
                          const TimerWidget(),
                          _buttonsFilterMinReparto(context),
                          _buttonsOptions()
                        ],
                      )));
        }
      }
    });
  }

  //Widget que pinta la información de Mostrar_contadores del numierKDS.ini
  Widget _contadores() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.push_pin,
          color: Colors.white,
        ),
        Text(
          //'$numOrders'
          "${ordersList!.where((element) => element.camEstado != "M").length}",
          style: Styles.textContadores,
        ),
        Text(
          " | ",
          style: Styles.urgent(Styles.urgentDefaultSize),
        ),
        Icon(
          Icons.home,
          color: Colors.white,
        ),
        Text(
          "0",
          style: Styles.textContadores,
        )
      ],
    ));
  }

//BUTTONS
  //Botón principal de la barra de navegación para acceder a los distintos filtros de las comandas
  Widget _buttonsFilter(BuildContext context) {
    return Row(
      //3 BOTONES
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        _filterBtn(enProceso, "En proceso", Styles.buttonEnProceso),
        widget.config.reparto!.contains("S")
            ? _filterBtn(recoger, "Recoger", Styles.buttonRecoger)
            : Container(),
        _filterBtn(terminadas, "Terminadas", Styles.buttonTerminadas),
        _filterBtn(todas, "Todas", Styles.buttonTodas)
      ],
    );
  }

  //Widget que se muestra si el tamaño de la pantalla es pequeño (se usa para el responsive)
  Widget _buttonsFilterMin(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterBtn(enProceso, "En proceso", Styles.buttonEnProcesomin),
          _filterBtn(terminadas, "Terminadas", Styles.buttonTerminadasmin),
          _filterBtn(todas, "Todas", Styles.buttonTodasmin)
        ],
      ),
    );
  }

  //Widget que se muestra si el tamaño de la pantalla es pequeño (se usa para el responsive)
  Widget _buttonsFilterMinReparto(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _filterBtn(enProceso, "En proceso", Styles.buttonEnProcesomin),
          _filterBtn(recoger, "Recoger", Styles.buttonRecogerMin),
          _filterBtn(terminadas, "Terminadas", Styles.buttonTerminadasmin),
          _filterBtn(todas, "Todas", Styles.buttonTodasmin)
        ],
      ),
    );
  }

  //Crea el botón para traer todas las comandas
  Widget _filterBtn(String newFilter, String title, ButtonStyle btnStyle) {
    Color _btnColor = Colors.white;

    if (title.contains("Todas")) {
      _btnColor = Colors.black;
    }
    //BoxDecoration(border: Border.all(color: Colors.red))
    BoxDecoration selectedFilterStyle = BoxDecoration(
        border: Border(bottom: BorderSide(color: Styles.black, width: 4.0)));

    return Container(
      decoration: filter == newFilter ? selectedFilterStyle : null,
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              filter = newFilter;
            });
          },
          child: Text(
            title,
            style: Styles.btnTextSize(_btnColor),
          ),
          style: btnStyle),
    );
  }

  //Widget que crea los botones de resumen de comandas, cambio de operario, refresh y pantalla completa
  Widget _buttonsOptions() {
    return SizedBox(
      width: Styles.buttonsOptionsWidth,
      child: Row(
        ///// 4 OPCIONES
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                showResumen = !showResumen;
              });
            },
            child: CustomIcons.menu,
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
            onPressed: () => dialogoOperario(),
            child: Icon(Icons.person),
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomeScreen(
                          socket: widget.socket,
                          config: widget.config,
                        )),
              );
            },
            child: CustomIcons.refresh,
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
          onPressed: () {

            
            //FUNCIONA PERFECTAMENTE EL CAMBIO A PANTALLA COMPLETA
            //Pero no se puede utilizar de momento porque el import html da problemas con android
            //import 'dart:html';
          /*
          document.documentElement!.requestFullscreen();
          document.exitFullscreen();
          */
        },
        //TODO: averiguar cómo cambiar el ícono dependiendo del cambio de pantalla
        //CustomIcons.medScreen
        child: CustomIcons.fullscreen,
        style: Styles.btnActionStyle,
      )
        ],
      ),
    );
  }

  


  //Abre el primer dialogo para la selección de operario
  dialogoOperario() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Opciones',
          style: Styles.textTitleInfo,
          textAlign: TextAlign.center,
        ),
        content: Container(
          height: 300,
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    botonTurno("Iniciar turno operario", '1');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 730,
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'Iniciar turno operario',
                            textAlign: TextAlign.center,
                            style: Styles.textButtonOperario,
                          ),
                        ],
                      )),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green))),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    botonTurno("Finalizar turno operario", '0');
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: 730,
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                          Text(
                            'Finalizar turno operario',
                            textAlign: TextAlign.center,
                            style: Styles.textButtonOperario,
                          ),
                        ],
                      )),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red))),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                alignment: Alignment.center,
                width: 300,
                height: 70,
                child: Text(
                  'Cancelar',
                  textAlign: TextAlign.center,
                  style: Styles.textButtonCancelar,
                ),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red))),
        ],
      ),
    );
  }

  //Segundo dialogo de selección de operario donde se debe introducir el código del mismo
  botonTurno(String mensaje, String isInicioTurno) {
    return showDialog(
        context: context,
        builder: (m) => AlertDialog(
              title: Text(
                mensaje,
                style: Styles.textTitleInfo,
                textAlign: TextAlign.center,
              ),
              content: Container(
                  width: 760,
                  height: 270,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Introduzca su código de operario:',
                                style: Styles.textRegularInfo,
                              ),
                            ),
                            Container(
                              width: 750,
                              height: 70,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent)),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Debe introducir un codigo de operario";
                                  }
                                  return null;
                                },
                                controller: operarioController,
                                obscureText: true,
                                style: const TextStyle(fontSize: 35),
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white))),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  opcionesTurno(isInicioTurno);
                                  setState(() {
                                    operarioController.clear();
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 750,
                                height: 70,
                                child: Text(
                                  'Continuar',
                                  textAlign: TextAlign.center,
                                  style: Styles.textButtonCancelar,
                                ),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green))),
                        ),
                      ],
                    ),
                  )),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        operarioController.clear();
                      });
                      Navigator.of(m).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 300,
                      height: 70,
                      child: Text(
                        'Cancelar',
                        textAlign: TextAlign.center,
                        style: Styles.textButtonCancelar,
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red))),
              ],
            )).then((value) {
      operarioController
          .clear(); //Si el usuario no termina la acción e intenta salir sus datos desaparecen para mayor seguridad
    });
  }

  //Dependiendo de si el código de operario es correcto mostrará un status "OK" o "ERROR" e imprimirá una respuesta
  opcionesTurno(String isInicioTurno) {
    Navigator.pop(context);
    if (_formKey.currentState!.validate()) {
      workersRepository
          .inicioTurno(widget.config, operarioController.text, isInicioTurno)
          .then(((value) {
        responseTurno = value;

        return showDialog(
            context: context,
            builder: (m) {
              if (value.mod == "inicioTurno" && value.status == "OK") {
                return AlertDialog(
                  title: Text(
                    'Opciones',
                    style: Styles.textTitleInfo,
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    width: 760,
                    height: 270,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 40,
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                value.message,
                                style: Styles.textTitle(20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "¡Hola ${value.operario}! Tu turno comienza a las ${value.hora}",
                                style: Styles.textTitle(20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(m).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: 70,
                          child: Text(
                            'Cerrar',
                            textAlign: TextAlign.center,
                            style: Styles.textButtonCancelar,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red))),
                  ],
                );
              } else if (value.mod == "finTurno" && value.status == "OK") {
                return AlertDialog(
                  title: Text(
                    'Opciones',
                    style: Styles.textTitleInfo,
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    width: 760,
                    height: 270,
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 0),
                                child: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 40,
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                value.message,
                                style: Styles.textTitle(20),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "¡Adiós ${value.operario}! Tu turno finaliza a las ${value.hora}",
                                style: Styles.textTitle(20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(m).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: 70,
                          child: Text(
                            'Cerrar',
                            textAlign: TextAlign.center,
                            style: Styles.textButtonCancelar,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red))),
                  ],
                );
              } else {
                return AlertDialog(
                  title: Text(
                    'Opciones',
                    style: Styles.textTitleInfo,
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    width: 760,
                    height: 270,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 50,
                                )),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                value.message,
                                style: Styles.textTitle(20),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  dialogoOperario();
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 750,
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.replay_outlined,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          size: 30,
                                        ),
                                        Text(
                                          'Volver a intentar',
                                          textAlign: TextAlign.center,
                                          style: Styles.textButtonCancelar,
                                        ),
                                      ],
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.amber))),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(m).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 300,
                          height: 70,
                          child: Text(
                            'Cerrar',
                            textAlign: TextAlign.center,
                            style: Styles.textButtonCancelar,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red))),
                  ],
                );
              }
            });
      }));
    }
  }

//GESTION DEL RESUMEN DE COMANDAS
//Agrupamos los "titulos" por nombre y sumamos las cantidades
  List<String> reordering(List<String> titulos) {
    List<List<String>> titulosSplit = [];

    var producto;
    var cantidad = 0;
    List<String> result = [];
    for (var item in titulos) {
      titulosSplit.add(item.split(' X '));
    }

    var prueba = titulosSplit.groupListsBy((linea) => linea[1]).entries;

    for (var item in prueba) {
      cantidad = 0;
      producto = item.key;
      for (var i in item.value) {
        cantidad += int.parse(i.first);
      }

      result.add("$cantidad X $producto");
      ////debugPrint('$producto : $cantidad');

    }
    //ordena alfabéticamente
    result.sort(((a, b) => a.split("X")[1].compareTo(b.split("X")[1])));
    return result;
  }
}
