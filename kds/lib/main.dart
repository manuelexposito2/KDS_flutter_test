import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/screens/landing_screen.dart';
import 'package:kds/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(const MyApp());
  Socket socket = io(
      'http://$apiBaseUrl:$puertoKDS',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());
  socket.connect();
  socket.onConnect((_) {
   
    print("Connected");
  });
   runApp(MyApp(
      socket: socket,
    ));
  socket.onDisconnect((_) => print('disconnect'));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key, this.socket}) : super(key: key);

  Socket? socket;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => LandingScreen(
              socket: socket,
            ),
      },
    );
  }
}
