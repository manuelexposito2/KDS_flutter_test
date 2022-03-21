import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/widgets/bottom_nav_bar.dart';
import 'package:kds/bloc/order/order_bloc.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/error_screen.dart';
import 'package:kds/ui/widgets/loading_screen.dart';
import 'package:kds/ui/widgets/waiting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String filter = 'ALL';

  late OrderRepository orderRepository;

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
    //var responsiveHeight = MediaQuery.of(context).size.height;
    //var responsiveWidth = MediaQuery.of(context).size.width;

    //TODO: MONTAR BLOC EN UI PARA TRAER LA LISTA DE COMANDAS
    //TODO: CREAR WIDGET PARA RESUMEN CON TODAS LAS LÍNEAS

    return BlocProvider(
      create: (context) =>
          OrderBloc(orderRepository)..add(FetchOrdersWithFilterEvent(filter)),
      child: Scaffold(
        //_createOrder(context)
        body: _createOrder(context),
        bottomNavigationBar: const BottomNavBar(),
      ),
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
          return LoadingScreen(message: state.message,
          );
          //Incluir el retry
        } else if (state is OrdersFetchNoOrdersState) {
          return const WaitingScreen();
          //Incluir el mensaje requerido y el retry
        } else if (state is OrdersFetchSuccessState) {
          return _createOrdersView(context, state.orders);
        } else {
          return const Text('Not Support');
        }
      },
    );
  }

  Widget _createOrdersView(BuildContext context, List<Order> orders) {
    return Container(
      height: 300,
      child: ListView.builder(
        
        scrollDirection: Axis.horizontal ,
        itemCount: orders.length,
        itemBuilder: ((context, index) {
          //context, orders[index]
        return _createOrderItem(context, orders[index]);
      }
      )),
    );
    //separatorBuilder: (BuildContext context, int index) => const VerticalDivider(color: Colors.transparent, width: 6.0,),);
  }
//BuildContext context, Order order
  Widget _createOrderItem(BuildContext context, Order order) {

  //Imprime los minutos buscando la diferencia entre la fecha actual y la fecha de inicio
  String total() {
    var date = DateTime.fromMillisecondsSinceEpoch(order.camFecini * 1000);
    var date2 = DateTime.now();
    final horatotal = date2.difference(date);
    return horatotal.inMinutes.toString();
  }

    return Container(
      
      decoration: BoxDecoration(color: Styles.succesColor, borderRadius: BorderRadius.all(Radius.circular(5))),
      margin: EdgeInsets.all(10),
      width: 300,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                      child: IconButton(onPressed: () {}, icon: Icon(Icons.info, color: Color.fromARGB(255, 87, 87, 87),))
                    )
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
          
          itemPedido(context, order)
        ],
      ),
    );
  }

  //Hacer una condicional para que solo pase si se marca como urgente
  Widget urgente(){
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





  Widget itemPedido(BuildContext context, Order order){
    return Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5), bottomRight: Radius.circular(5))),
            margin: EdgeInsets.only(left: 1, right: 1, bottom: 1),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 50,
            child: Text(
              order.details.first.demTitulo,
              style: Styles.textTitle,
            ),
          );
  }
}
