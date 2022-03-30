import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/bloc/order/order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/error_screen.dart';
import 'package:kds/ui/widgets/loading_screen.dart';
import 'package:kds/ui/widgets/order_card.dart';
import 'package:kds/ui/widgets/resume_orders.dart';
import 'package:kds/ui/widgets/waiting_screen.dart';
import 'package:kds/utils/constants.dart';

import "package:collection/collection.dart";

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? filter = '';
  var version = "v.1.1.9";
  late OrderRepository orderRepository;
  String? _timeString;
  bool showResumen = false;
  @override
  void initState() {
    // TODO: implement initState

    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    orderRepository = OrderRepositoryImpl();
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrderBloc(orderRepository)..add(FetchOrdersWithFilterEvent(filter!)),
      child: _createOrder(context),
    );
  }

  Widget _createOrder(BuildContext context) {
    return BlocBuilder<OrderBloc, OrdersState>(
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
  }

  //TODO: Hacer scrolleable la lista de comandas
  Widget _createOrdersView(BuildContext context, List<Order> orders) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [for (var o in orders) OrderCard(order: o)],
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
          children: [_time(), _buttonsFilter(context), _buttonsOptions()],
        ));
  }

  //TIME

  //MOSTRAR LA HORA
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('Hms', 'en_US').format(dateTime);
  }

  Widget _time() {
    return Container(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.white,
          ),
          children: [
            TextSpan(text: version),
            WidgetSpan(
              child: CustomIcons.clock(Colors.white, 28.0),
            ),
            TextSpan(text: _timeString, style: TextStyle(fontSize: 30.0)),
          ],
        ),
      ),
    );
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
            onPressed: () {},
            child: Icon(Icons.person),
            style: Styles.btnActionStyle,
          ),
          ElevatedButton(
            onPressed: () {
             /* Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomeScreen()
                ),
              );*/
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

  void _toogleStateButton(Details details) {
    setState(() {
      if (details.demEstado!.contains('E')) {
        details.demEstado = 'P';
      } else if (details.demEstado!.contains('P')) {
        details.demEstado = 'T';
      } else {
        details.demEstado = 'E';
      }
    });
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
