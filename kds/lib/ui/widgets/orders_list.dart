import 'package:audioplayers/audioplayers.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';

import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/screens/error_screen.dart';
import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/screens/loading_screen.dart';
import 'package:kds/ui/styles/styles.dart';
import "package:collection/collection.dart";
import 'package:kds/ui/widgets/order_card.dart';
import 'package:kds/ui/screens/waiting_screen.dart';
import 'package:kds/ui/widgets/timer_widget.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:show_up_animation/show_up_animation.dart';

class OrdersList extends StatefulWidget {
  OrdersList({Key? key, this.socket}) : super(key: key);
  Socket? socket;

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController operarioController = TextEditingController();
  late OrderRepository orderRepository;
  late final AudioCache _audioCache;
  String? filter = '';

  var navbarHeightmin = 280.0;
  var navbarHeightMedium = 150.0;
  var navbarHeight = 70.0;

  bool showResumen = false;

  String? mensaje;

  List<Order>? ordersList;
  Order? selectedOrder;

  //final _socketController = StreamController<List<Order?>>();

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
    _audioCache = AudioCache(
      prefix: 'sounds/',
      fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
    );
  }

  @override
  Widget build(BuildContext context) {
    //ESCUCHA LA NUEVA COMANDA Y LA AÑADE A LA LISTA

    widget.socket!.on(WebSocketEvents.newOrder, (data) {
      //_audioCache.play('bell_ring.mp3');
      setState(() {
        ordersList!.add(Order.fromJson(data));
      });
    });

    //ESCUCHA PARA BORRAR LA COMANDA CUANDO ESTÉ TERMINADA
    //TODO: Animacion para la comanda que se borra
    widget.socket!.on(WebSocketEvents.modifyOrder, ((data) {
      OrderDto newStatus = OrderDto.fromJson(data);

      if (newStatus.status == "P") {
        setState(() {
          ordersList!.where(
              (element) => element.camId.toString() == newStatus.idOrder);
        });
      }

      if (newStatus.status == "T") {
        setState(() {
          ordersList!.removeWhere(
              (element) => element.camId.toString() == newStatus.idOrder);
        });
      }
    }));

    widget.socket!.on(WebSocketEvents.modifyDetail, (data) {
      //print(data);

      DetailDto detailDto = DetailDto.fromJson(data);

      setState(() {
        ordersList!
            .where((element) => element.camId.toString() == detailDto.idOrder);
      });
    });

    return Scaffold(
      body: Row(children: [
        Expanded(
            flex: 3,
            child: FutureBuilder(
                future: orderRepository.getOrders(filter!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      !snapshot.hasData) {
                    return LoadingScreen(message: "Cargando...");
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      !snapshot.hasData) {
                    return WaitingScreen();
                  }

                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasError) {
                    return ErrorScreen();
                  } else {
                    ordersList = snapshot.data as List<Order>;
                    return responsiveOrder();
                  }
                })),
        showResumen
            ? Expanded(
                flex: 1,
                child: Text(
                    "Resume") /*  ResumeOrdersWidget(
                        lineasComandas: reordering(resumeList),
                      ) */
                )
            : Container()
      ]),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

  Widget responsiveOrder() {
    //double responsiveWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.minWidth > 1700) {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 6,
        );
      } else if (constraints.minWidth > 1500) {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 5,
        );
      } else if (constraints.minWidth > 1000) {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 4,
        );
      } else if (constraints.minWidth > 900) {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 3,
        );
      } else if (constraints.minWidth > 500) {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 2,
        );
      } else {
        return DynamicHeightGridView(
          builder: (context, index) => OrderCard(
            order: ordersList!.elementAt(index),
            socket: widget.socket,
          ),
          itemCount: ordersList!.length,
          crossAxisCount: 1,
        );
      }
    });
  }

  //TODO: Hacer scrolleable la lista de comandas
  Widget _createOrdersView(BuildContext context, List<Order> orders) {
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            for (var o in orders)
              OrderCard(
                key: UniqueKey(),
                order: o,
                socket: widget.socket,
              ),
          ],
        ),
      ),
    );
  }

  //BOTTOMNAVBAR
  Widget bottomNavBar(BuildContext context) {
    double responsiveWidth = MediaQuery.of(context).size.width;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.minWidth > 1250) {
        return Container(
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
      } else if (constraints.minWidth > 900) {
        return Container(
          height: navbarHeightMedium,
          color: Styles.bottomNavColor,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TimerWidget(),
                      _buttonsFilter(context),
                      _buttonsOptions()
                    ],
                  )
                ],
              )),
        );
      } else {
        return Container(
            height: navbarHeightmin,
            color: Styles.bottomNavColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                child: Column(
                  children: [
                    const TimerWidget(),
                    _buttonsFilterMin(context),
                    _buttonsOptions()
                  ],
                )));
      }
    });
  }

//BUTTONS

  Widget _buttonsFilter(BuildContext context) {
    return Row(
      //3 BOTONES
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              filter = enProceso;
            });
          },
          child: Text("En proceso", style: Styles.btnTextSize(Colors.white)),
          style: Styles.buttonEnProceso,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                filter = terminadas;
              });
            },
            child: Text("Terminadas", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonTerminadas),
        ElevatedButton(
            onPressed: () {
              setState(() {
                filter = todas;
              });
            },
            child: Text(
              "Todas",
              style: Styles.btnTextSize(Colors.black),
            ),
            style: Styles.buttonTodas)
      ],
    );
  }

  Widget _buttonsFilterMin(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                filter = enProceso;
              });
            },
            child: Text("En proceso", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonEnProcesomin,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  filter = terminadas;
                });
              },
              child:
                  Text("Terminadas", style: Styles.btnTextSize(Colors.white)),
              style: Styles.buttonTerminadasmin),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  filter = todas;
                });
              },
              child: Text(
                "Todas",
                style: Styles.btnTextSize(Colors.black),
              ),
              style: Styles.buttonTodasmin)
        ],
      ),
    );
  }

  Widget _buttonsOptions() {
    return SizedBox(
      width: 280.0,
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
            child: Icon(Icons.menu),
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
            onPressed: () => showDialog(
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
                      TextButton(
                          onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (m) => AlertDialog(
                                    title: Text(
                                      'Iniciar turno',
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20),
                                                    child: Text(
                                                      'Introduzca su código de operario:',
                                                      style: Styles
                                                          .textRegularInfo,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 750,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent)),
                                                    child: TextFormField(
                                                      controller:
                                                          operarioController,
                                                      style: const TextStyle(
                                                          fontSize: 35),
                                                      decoration: const InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 30),
                                                child: TextButton(
                                                    onPressed: () {},
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 750,
                                                      height: 70,
                                                      color: Colors.green,
                                                      child: Text(
                                                        'Continuar',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Styles
                                                            .textButtonCancelar,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(m).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 300,
                                            height: 70,
                                            color: Colors.red,
                                            child: Text(
                                              'Cancelar',
                                              textAlign: TextAlign.center,
                                              style: Styles.textButtonCancelar,
                                            ),
                                          )),
                                    ],
                                  )),
                          child: Container(
                              alignment: Alignment.center,
                              width: 760,
                              height: 120,
                              color: const Color.fromARGB(255, 108, 189, 110),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
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
                              ))),
                      TextButton(
                          onPressed: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (m) => AlertDialog(
                                    title: Text(
                                      'Finalizar turno',
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20),
                                                    child: Text(
                                                      'Introduzca su coódigo de operario:',
                                                      style: Styles
                                                          .textRegularInfo,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 750,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .blueAccent)),
                                                    child: TextFormField(
                                                      controller:
                                                          operarioController,
                                                      style: const TextStyle(
                                                          fontSize: 35),
                                                      decoration: const InputDecoration(
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 30),
                                                child: TextButton(
                                                    onPressed: () {},
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 750,
                                                      height: 70,
                                                      color: Colors.green,
                                                      child: Text(
                                                        'Continuar',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Styles
                                                            .textButtonCancelar,
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        )),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(m).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 300,
                                            height: 70,
                                            color: Colors.red,
                                            child: Text(
                                              'Cancelar',
                                              textAlign: TextAlign.center,
                                              style: Styles.textButtonCancelar,
                                            ),
                                          )),
                                    ],
                                  )),
                          child: Container(
                              alignment: Alignment.center,
                              width: 760,
                              height: 120,
                              color: Color.fromARGB(255, 241, 93, 82),
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
                              ))),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 300,
                        height: 70,
                        color: Colors.red,
                        child: Text(
                          'Cancelar',
                          textAlign: TextAlign.center,
                          style: Styles.textButtonCancelar,
                        ),
                      )),
                ],
              ),
            ),
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
                        )),
              );
            },
            child: Icon(Icons.refresh),
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
            onPressed: () {},
            child: Icon(Icons.fullscreen),
            style: Styles.btnActionStyle,
          )
        ],
      ),
    );
  }

  //GESTION DEL RESUMEN DE COMANDAS
  //Agrupamos los "titulos" por nombre y sumamos las cantidades
  List<String> reordering(List<String> titulos) {
    List<List<String>> titulosSplit = [];

    var producto;
    var cantidad = 0;
    List<String> result = [];
    for (var item in titulos) {
      titulosSplit.add(item.split(' '));
    }

    var prueba = titulosSplit.groupListsBy((linea) => linea[2]).entries;

    for (var item in prueba) {
      cantidad = 0;
      producto = item.key;
      for (var i in item.value) {
        cantidad += int.parse(i[0]);
      }

      result.add("$cantidad X $producto");
      //debugPrint('$producto : $cantidad');

    }
    //debugPrint(prueba.toString());
    return result;
  }
}
