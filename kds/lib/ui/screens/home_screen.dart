import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/orders_list.dart';
import 'package:kds/ui/widgets/timer_widget.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.socket}) : super(key: key);
  Socket? socket;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrdersList(socket: widget.socket),
        //Positioned(bottom: 10, left: 10, child: TimerWidget()),
      ],
    );
  }
}
