import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/bottom_nav_bar.dart';
import 'package:kds/ui/widgets/comanda_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var responsiveHeight = MediaQuery.of(context).size.height;
    var responsiveWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ComandaCard(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
