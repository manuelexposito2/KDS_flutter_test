import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/widgets/bottom_nav_bar.dart';

class Prueba extends StatefulWidget {
  const Prueba({ Key? key }) : super(key: key);

  @override
  State<Prueba> createState() => _PruebaState();
}

class _PruebaState extends State<Prueba> {
  
  late OrderRepository orderRepository;
  late Future<List<Order>> futureComandas;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderRepository = OrderRepositoryImpl();
    futureComandas = orderRepository.getOrders("T");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: futureBuilder(),
      bottomNavigationBar: BottomNavBar(),
      
    );
  }

  futureBuilder(){
    return FutureBuilder<List<Order>>(
  future: futureComandas,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return comandasList(snapshot.data!);
    } else if (snapshot.hasError) {
      return Text('${snapshot.error}');
    }

    // By default, show a loading spinner.
    return const CircularProgressIndicator();
  },
);
  }


  comandasList(List<Order> orders){
    return SizedBox(
        height: 270,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return comandasItem(orders.elementAt(index));
            }));
  }
  }

  comandasItem(Order order){


    return Text(order.camOperario);

  }






