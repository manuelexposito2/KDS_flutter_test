import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/comanda_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ComandaCard(),);
  }
}