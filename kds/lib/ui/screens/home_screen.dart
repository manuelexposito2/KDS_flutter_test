import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/orders_list.dart';

import 'package:kds/utils/websocket_events.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.socket!.on(WebSocketEvents.setUrgent, ((data) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => OrdersList(
                  socket: widget.socket,
                )),
      );
    }));

    return OrdersList(socket: widget.socket);
  }
}
