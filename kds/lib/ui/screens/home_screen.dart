import 'package:flutter/material.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';

import 'package:kds/ui/widgets/orders_list.dart';

import 'package:kds/utils/websocket_events.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, this.socket, this.config}) : super(key: key);
  Socket? socket;
  Config? config;
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
                  config: widget.config!,
                )),
      );
    }));

    return OrdersList(
      socket: widget.socket,
      config: widget.config!,
    );
  }
}
