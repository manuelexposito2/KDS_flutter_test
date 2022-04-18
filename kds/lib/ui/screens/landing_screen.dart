import 'package:flutter/material.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/ui/screens/error_screen.dart';
import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/widgets/orders_list.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();

    ConfigRepository.getUrlKDS().then(
      (value) {
        Socket socket = io(
            value,
            OptionBuilder()
                .setTransports(['websocket'])
                .disableAutoConnect()
                .build());
        socket.connect();
        socket.onConnect((_) {
          print("Connected");

          ConfigRepository.readConfig().then((value) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => HomeScreen(
                        socket: socket,
                        config: value,
                      )),
            );
          }).onError((error, stackTrace) {
            Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => ErrorScreen()),
            );
          });
        });
        socket.onDisconnect((_) => print('disconnect'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
