import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/models/status/detail_dto.dart';
import 'package:kds/models/status/order_dto.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kplayer/kplayer.dart';
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
import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';
//import 'package:show_up_animation/show_up_animation.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

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
  //late final AudioCache _audioCache;
  String? filter = '';

  var navbarHeightmin = 280.0;
  var navbarHeightminReparto = 400.0;
  var navbarHeightMedium = 150.0;
  var navbarHeight = 70.0;

  bool showResumen = false;

  String? mensaje;
  List<String> resumeList = [];
  List<Order>? ordersList = [];
  Order? selectedOrder;
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //ESCUCHA LA NUEVA COMANDA Y LA AÑADE A LA LISTA

    widget.socket!.on(WebSocketEvents.newOrder, (data) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        //TODO: Se debe interactuar con la app previamente o no saldrá el sonido. Ver como arreglar esto.
        FlutterPlatformAlert.playAlertSound();
      }
      if (kIsWeb) {
        Player.asset("sounds/bell_ring.mp3").play();
      }
      setState(() {
        ordersList!.add(Order.fromJson(data));
      });
    });

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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            barrierDismissible: true));

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
                      Navigator.of(context).pop();
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
      //print(data);

      DetailDto detailDto = DetailDto.fromJson(data);

      setState(() {
        ordersList!
            .where((element) => element.camId.toString() == detailDto.idOrder);
      });
    });

    return Scaffold(
      body: FutureBuilder(
          future: orderRepository.getOrders(filter!, widget.config),
          builder: (context, snapshot) {
            debugPrint(snapshot.connectionState.name);
            debugPrint('hasData : ${snapshot.hasData.toString()}');
            debugPrint('hasError : ${snapshot.hasError.toString()}');
            if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasError && !snapshot.hasData) {
              return LoadingScreen(message: "Cargando...");
            }
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError && !snapshot.hasData) {
              return WaitingScreen();
            }
          
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError && !snapshot.hasData) {
              return ErrorScreen(
                config: widget.config,
                socket: widget.socket!,
              );
            } else if(snapshot.connectionState == ConnectionState.done && snapshot.hasData || snapshot.connectionState == ConnectionState.waiting && snapshot.hasData) {
              ordersList = snapshot.data as List<Order>;

              //ordersList!.sort();
        /*       ordersList!.sort((a, b) {
                if (a.camEstado!.contains("M")) {
                  return -1;
                } else if (!b.camEstado!.contains("M")) {
                  return 0;
                } else {
                  return 1;
                }
              }); */

              resumeList = _refillResumeList(ordersList!);

              return Row(
                children: [
                  Expanded(flex: 3, child: responsiveOrder()),
                  showResumen
                      ? Expanded(
                          flex: 1,
                          child: ResumeOrdersWidget(
                            lineasComandas: reordering(resumeList),
                            socket: widget.socket,
                          ))
                      : Container()
                ],
              );
            } else {
              return LoadingScreen(message: "Cargando...");
            }
          }),
      bottomNavigationBar: bottomNavBar(context),
    );
  }

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

  List<String> _refillResumeList(List<Order> ordersList) {
    resumeList.clear();

    for (var comanda in ordersList) {
      if (comanda.details.isNotEmpty) {
        for (var d in comanda.details) {
          if (d.demEstado != "M") {
            if (d.demTitulo != '' &&
                (d.demEstado!.contains("E") || d.demEstado!.contains("P"))) {
              resumeList.add(d.demTitulo!);
            } else if (filter == recoger && d.demEstado!.contains("R")) {
              resumeList.add(d.demTitulo!);
            }
          }
        }
      }
    }
    return resumeList;
  }

  Widget responsiveOrder() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var responsiveCrossAxisCount = 6;
      if (constraints.minWidth > 1700) {
        responsiveCrossAxisCount = 6;
      } else if (constraints.minWidth > 1500) {
        responsiveCrossAxisCount = 5;
      } else if (constraints.minWidth > 1000) {
        responsiveCrossAxisCount = 4;
      } else if (constraints.minWidth > 900) {
        responsiveCrossAxisCount = 3;
      } else if (constraints.minWidth > 500) {
        responsiveCrossAxisCount = 2;
      } else {
        responsiveCrossAxisCount = 1;
      }

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
                config: widget.config,
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
        return widget.config.reparto != "S"
            ? Container(
                height: navbarHeightmin,
                color: Styles.bottomNavColor,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                    child: Column(
                      children: [
                        const TimerWidget(),
                        _buttonsFilterMin(context),
                        _buttonsOptions()
                      ],
                    )))
            : Container(
                height: navbarHeightminReparto,
                color: Styles.bottomNavColor,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                    child: Column(
                      children: [
                        const TimerWidget(),
                        _buttonsFilterMinReparto(context),
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
        widget.config.reparto == "S"
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    filter = recoger;
                  });
                },
                child: Text("Recoger", style: Styles.btnTextSize(Colors.white)),
                style: Styles.buttonRecoger,
              )
            : Container(),
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

  Widget _buttonsFilterMinReparto(BuildContext context) {
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
                filter = recoger;
              });
            },
            child: Text("Recoger", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonRecogerMin,
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
                          config: widget.config,
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
      //debugPrint('$producto : $cantidad');

    }
    return result;
  }
}
