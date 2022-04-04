import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kds/bloc/order/order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/repository/stream_socket.dart';
import 'package:kds/ui/styles/styles.dart';
import "package:collection/collection.dart";
import 'package:kds/ui/widgets/error_screen.dart';
import 'package:kds/ui/widgets/loading_screen.dart';
import 'package:kds/ui/widgets/order_card.dart';
import 'package:kds/ui/widgets/resume_orders.dart';
import 'package:kds/ui/widgets/timer_widget.dart';
import 'package:kds/ui/widgets/waiting_screen.dart';
import 'package:kds/utils/constants.dart';
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
  String? filter = '';
  //late StreamSocket _streamSocket;
  bool showResumen = false;
  Order? newOrder;
  String? mensaje;
  Repository repository = Repository();
  List<Order>? ordersList;
  final _socketController = StreamController<List<Order?>>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    orderRepository = OrderRepositoryImpl();
    //_streamSocket = StreamSocket();

    repository.fetchOrders(filter!).forEach(
      (element) {
        _socketController.sink.add(element);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //repository.fetchOrders(filter!).

    widget.socket!.on('newOrder', (data) {
      setState(() {
        ordersList!.add(Order.fromJson(data));
      });
    });

    return Scaffold(
      body: Row(children: [
        Expanded(
            flex: 3,
            child: StreamBuilder(
                //initialData: repository.getOrders(filter!),
                stream: repository.fetchOrders(filter!),
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
                    return _createOrdersView(context, ordersList!);
                  }
                }) /* _createOrdersView(context, state.orders) */),
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

    /* BlocProvider(
      create: (context) =>
          OrderBloc(orderRepository)..add(FetchOrdersWithFilterEvent(filter!)),
      child: _createOrder(context),
    ); */
  }

/*   Widget _createOrder(BuildContext context) {
    return BlocConsumer<OrderBloc, OrdersState>(
      listenWhen: (previous, current) {
        return previous is OrdersFetchSuccessState || current is OrdersFetchSuccessState;
      },
      listener: (context, state) {
        if (state is OrdersFetchSuccessState){
          context.read<OrderBloc>().add(FetchOrdersWithFilterEvent(filter!));
        }
      },
      builder: (context, state) {
        if (state is OrdersInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is OrdersFetchErrorState) {
          return const ErrorScreen();
          //Incluir el mensaje requerido y el retry
        } else if (state is OrdersFetchEmptyState) {
          return LoadingScreen(
            message: state.message,
          );
          //Incluir el retry
        } else if (state is OrdersFetchNoOrdersState) {
          return const WaitingScreen();
          //Incluir el mensaje requerido y el retry
        } else if (state is OrdersFetchSuccessState) {
          List<String>? resumeList = [];

          if (state.orders.isNotEmpty) {
            for (var comanda in state.orders) {
              if (comanda.details.isNotEmpty) {
                for (var d in comanda.details) {
                  //Todas las lineas de venta las metemos en una lista para hacer el resumen

                  if (!d.demEstado!.contains("T")) {
                    resumeList.add(d.demTitulo!);
                  }
                }
              }
            }
          }

          return Scaffold(
            body: Row(children: [
              Expanded(
                  flex: 3, child: _createOrdersView(context, state.orders)),
              showResumen
                  ? Expanded(
                      flex: 1,
                      child: ResumeOrdersWidget(
                        lineasComandas: reordering(resumeList),
                      ))
                  : Container()
            ]),
            bottomNavigationBar: bottomNavBar(context),
          );
        } else {
          return const Text('Not Support');
        }
      },
      buildWhen: (context, state) {
        return state is OrdersFetchSuccessState ||
            state is OrdersFetchErrorState ||
            state is OrdersFetchEmptyState ||
            state is OrdersFetchNoOrdersState;
      },
    );
  } */

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
              ShowUpAnimation(
                delayStart: Duration(seconds: 1),
                animationDuration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                direction: Direction.vertical,
                offset: 0.5,
                child: OrderCard(order: o),
              ), /*OrderCard(order: o)*/
          ],
        ),
      ),
    );
  }

  //BOTTOMNAVBAR
  Widget bottomNavBar(BuildContext context) {
    return Container(
        height: Styles.navbarHeight,
        color: Styles.bottomNavColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*TimerWidget()*/ Container(),
            _buttonsFilter(context),
            _buttonsOptions()
          ],
        ));
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
            BlocProvider.of<OrderBloc>(context)
                .add(FetchOrdersWithFilterEvent(filter!));
          },
          child: Text("En proceso", style: Styles.btnTextSize(Colors.white)),
          style: Styles.buttonEnProceso,
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                filter = terminadas;
              });

              BlocProvider.of<OrderBloc>(context)
                  .add(FetchOrdersWithFilterEvent(filter!));
            },
            child: Text("Terminadas", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonTerminadas),
        ElevatedButton(
            onPressed: () {
              setState(() {
                filter = todas;
              });

              BlocProvider.of<OrderBloc>(context)
                  .add(FetchOrdersWithFilterEvent(filter!));
            },
            child: Text(
              "Todas",
              style: Styles.btnTextSize(Colors.black),
            ),
            style: Styles.buttonTodas)
      ],
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
                    builder: (BuildContext context) => OrdersList()),
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
