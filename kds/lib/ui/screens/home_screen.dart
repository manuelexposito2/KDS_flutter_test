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
import 'package:kds/ui/widgets/resume_orders.dart';
import 'package:kds/ui/widgets/waiting_screen.dart';
import 'package:kds/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  /*
  details.demEstado.contains('E');
    details.demEstado.contains('R');
    details.demEstado.contains('P');
    details.demEstado.contains('T');
  */

  void _toogleStateButton(Details details){
    setState(() {
      if(details.demEstado.contains('E')){
        details.demEstado = 'P';
      }else if(details.demEstado.contains('P')){
        details.demEstado = 'T';
      }else {
        details.demEstado = 'E';
      }
    });
  }

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
    // TODO: implement dispose
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
          return Scaffold(
            body: Row(children: [
              Expanded(
                  flex: 2, child: _createOrdersView(context, state.orders)),
              showResumen
                  ? Expanded(flex: 1, child: ResumeOrdersWidget())
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

  Widget _createOrdersView(BuildContext context, List<Order> orders) {

    
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [for (var o in orders) _createOrderItem(context, o)],
      ),
    );
  }

  Widget _createOrderItem(BuildContext context, Order order) {
    //Imprime los minutos buscando la diferencia entre la fecha actual y la fecha de inicio
    String total() {
      var date = DateTime.fromMillisecondsSinceEpoch(order.camFecini * 1000);
      var date2 = DateTime.now();
      final horatotal = date2.difference(date);
      return horatotal.inMinutes.toString();
    }

    return Container(
      decoration: BoxDecoration(
          color: Styles.succesColor,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(10),
      width: 300,
      child: Wrap(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      total() + ' min.',
                      style: Styles.regularText,
                    ),
                    Text(
                      '1/5',
                      style: Styles.regularText,
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    Text(
                      order.camOperario,
                      style: Styles.regularText,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.push_pin,
                          color: Colors.white,
                        ),
                        Text(
                          order.camMesa.toString(),
                          style: Styles.regularText,
                        )
                      ],
                    ),
                    Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        width: 40,
                        height: 40,
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.info,
                              color: Color.fromARGB(255, 87, 87, 87),
                            )))
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            color: Colors.grey.shade400,
            height: 55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 195,
                  height: 50,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Color.fromARGB(255, 87, 87, 87),
                        textStyle: TextStyle(fontSize: 18)),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color(0xFF337AB7),
                      size: 30,
                    ),
                    label: const Text(
                      'Preparar',
                    ),
                  ),
                ),
                SizedBox(
                  width: 95,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        primary: Color.fromARGB(255, 87, 87, 87)),
                    child: Icon(Icons.print),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          //urgente(),
          Container(
            margin: EdgeInsets.all(1),
            color: Colors.white,
            child: pruebaItem(context, order.details),
          )
        ],
      ),
    );
  }

  //Hacer una condicional para que solo pase si se marca como urgente
  Widget urgente() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Styles.alertColor,
      alignment: Alignment.center,
      height: 50,
      //Hacer condición de que solo sale este espacio si se da tap en el botón de urgente
      child: Text(
        '¡¡¡URGENTE!!!',
        style: Styles.urgent,
      ),
    );
  }

  /*
  Widget _listViewPedido(BuildContext context, List<Details> details) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: details.length,
        itemBuilder: (context, index) {
          return _itemPedido(context, details.elementAt(index));
        });
  }

 */

  Widget _itemPedido(BuildContext context, Details details) {
    details.demEstado.contains('E');
    details.demEstado.contains('R');
    details.demEstado.contains('P');
    details.demEstado.contains('T');
    Color nuevo = Colors.white;

    if (details.demEstado.contains('E')) {
            nuevo = Colors.white;
          } else if (details.demEstado.contains('P')) {
            nuevo = Color(0xFFF5CB8F);
          } else if (details.demEstado.contains('R')) {
            nuevo = Colors.purple;
          } else if (details.demEstado.contains('T')) {
            nuevo = Color(0xFFB0E1A0);
          } else {
            nuevo = Colors.white;
          }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: nuevo,
        primary: Color.fromARGB(255, 87, 87, 87),
      ),
      onPressed: () {
        
         _toogleStateButton(details);
        
      },
      child: ListTile(
        title: Text(
          details.demTitulo,
          style: Styles.textTitle,
        ),
      ),
    );
  }

  Widget pruebaItem(BuildContext context, List<Details> details) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [for (var d in details) _itemPedido(context, d)],
    );
  }

  /*
  Widget itemPedido(BuildContext context, Details details) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
      margin: EdgeInsets.only(left: 1, right: 1),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      height: 50,
      child: Text(
        details.demTitulo,
        style: Styles.textTitle,
      ),
    );
  }
  */

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
            onPressed: () {},
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
}
