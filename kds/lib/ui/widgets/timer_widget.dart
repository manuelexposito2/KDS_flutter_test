import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kds/main.dart';
import 'package:kds/repository/impl_repo/config_repository.dart';
import 'package:kds/ui/screens/landing_screen.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/utils/constants.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();
  String? _timeString;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }
/*
  @override
  void dispose() {
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    //Widget encargado de imprimir la hora actual
    return GestureDetector(
      onDoubleTap: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  Text("Escriba la ruta en la que se encuentra el servidor."),
              actions: [],
              content: SizedBox(
                width: 300,
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
                              return "La URL introducida no es válida";
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
            );
          },
          barrierDismissible: true),
      child: SizedBox(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.white,
            ),
            children: [
              TextSpan(text: version),
              WidgetSpan(
                child: CustomIcons.clock(Colors.white, 28.0),
              ),
              TextSpan(text: _timeString, style: TextStyle(fontSize: 30.0)),
            ],
          ),
        ),
      ),
    );
  }

  _submitForm(BuildContext context) {
    ConfigRepository.writeNewUrl(urlController.text);
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

  //Método que trae la hora
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('Hms', 'en_US').format(dateTime);
  }
}
