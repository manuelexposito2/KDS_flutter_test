import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/orders_list.dart';
import 'package:kds/ui/widgets/timer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrdersList(),
        //Positioned(bottom: 10, left: 10, child: TimerWidget()),
      ],
    );
  }
}
