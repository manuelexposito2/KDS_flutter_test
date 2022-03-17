import 'package:flutter/material.dart';
import 'package:kds/repository/impl_repo/order_repository_impl.dart';
import 'package:kds/repository/repository/order_repository.dart';
import 'package:kds/ui/widgets/bottom_nav_bar.dart';
import 'package:kds/ui/widgets/comanda_card.dart';
import 'package:kds/ui/widgets/resume_orders.dart';
import 'package:kds/utils/preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? filter;
  OrderRepository? orderRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderRepository = OrderRepositoryImpl();
    Preferences.getQueryParam().then((value) => value = filter);
  }

  @override
  Widget build(BuildContext context) {
    var responsiveHeight = MediaQuery.of(context).size.height;
    var responsiveWidth = MediaQuery.of(context).size.width;

    //TODO: MONTAR BLOC EN UI PARA TRAER LA LISTA DE COMANDAS
    //TODO: CREAR WIDGET PARA RESUMEN CON TODAS LAS LÍNEAS

    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ComandaCard(),
          
          ResumeOrdersWidget()
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }


}
