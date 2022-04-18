import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/screens/landing_screen.dart';
import 'package:kds/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

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
        '/': (context) => LandingScreen(),
      },
    );
  }
}
