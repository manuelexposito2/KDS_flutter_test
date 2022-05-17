import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/ui/screens/error_screen.dart';
import 'package:kds/ui/screens/home_screen.dart';

import 'package:kds/utils/user_shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  bool showUrlForm = false;
  String? rutaActual = 'http://192.168.1.42:82';

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
   

    super.initState();

    //Primero buscamos la UrlKDS del fichero numierKDS.ini, y cuando la tengamos, hacemos la conexión
    //con websocket y buscamos la configuración.

    //TODO: Quedaría gestionar los errores y una mejor pantalla de carga.
    UserSharedPreferences.removeResumeCall();

    try {
      rutaActual = 'http://192.168.1.42:82';
      Socket socket = io(
          'http://192.168.1.42:82',
          OptionBuilder()
              .setTransports(['websocket'])
              //.disableAutoConnect()
              .enableAutoConnect()
              .build());

      socket.onConnect((_) {
        print("Connected");

        ConfigRepository.readConfig().then((config) {
          print(config.toJson().toString());
          Navigator.pushReplacement<void, void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => HomeScreen(
                      socket: socket,
                      config: config,
                    )),
          );
        });
      });
    } catch (e) {
      setState(() {
        showUrlForm = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        showUrlForm = true;
      });
    });
    //TODO: Dar la opción a reintroducir la URL desde aquí.
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: showUrlForm
              ? _formUrl()
              : Center(child: CircularProgressIndicator())),
    );
  }

  _formUrl() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            rutaActual == "http://" || rutaActual!.isEmpty
                ? Text("Conecta la app al servidor.",
                    style: TextStyle(fontSize: 25.0))
                : Text(
                    "Parece que hay un problema con la ruta. \n La ruta actual es: $rutaActual, ¿es correcta?",
                    style: TextStyle(fontSize: 25.0),
                  ),
            SizedBox(
              width: 470,
              height: 200,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(hintText: "192.168.1.43:82"),
                        controller: urlController,
                        validator: (value) {
                          print(value);
                          if (value!.isEmpty) {
                            return "La URL no es válida";
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _submitForm(context);
                                Navigator.of(context).pop();
                                _askForManuallyRestart(context);
                              }
                            },
                            child: Text("Cambiar URL")),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _submitForm(BuildContext context) async {
    setState(() {
      rutaActual = urlController.text;
    });

    //return ConfigRepository.writeNewUrl(urlController.text);
  }

  _askForManuallyRestart(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Todo listo."),
            content: Text("Reinicia el programa para conectarte al servidor."),
          );
        });
  }
}
