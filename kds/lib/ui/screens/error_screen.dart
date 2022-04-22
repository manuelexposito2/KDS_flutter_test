import 'package:flutter/material.dart';
import 'package:kds/models/status/config.dart';

import 'package:kds/ui/screens/home_screen.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ErrorScreen extends StatelessWidget {
  ErrorScreen({Key? key, required this.config, required this.socket})
      : super(key: key);

  Socket socket;
  Config config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 80),
            width: 900,
            height: 400,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Icon(
                        Icons.warning,
                        color: Color(0xFFA94442),
                        size: 70,
                      ),
                    ),
                    Text(
                      'Atención',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 60),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Icon(
                        Icons.warning,
                        color: Color(0xFFA94442),
                        size: 70,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, bottom: 30),
                  child: Text(
                    'No se ha podido conectar con el servidor. Inicie Numier TPV y Numier PDA y pulse el botón Recargar',
                    style: Styles.textWarning,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => HomeScreen(
                                socket: socket,
                                config: config,
                              )),
                    );
                  },
                  icon: Icon(Icons.replay_outlined),
                  label: Text('Recargar'),
                  style: Styles.btnActionStyle,
                )
              ],
            )),
      ),
    );
  }
}
