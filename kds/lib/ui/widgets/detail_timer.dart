import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kds/models/status/config.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/utils/constants.dart';
import 'package:kds/utils/user_shared_preferences.dart';

class DetailTimerWidget extends StatefulWidget {
  DetailTimerWidget(
      {Key? key, required this.id, required this.status, required this.config})
      : super(key: key);

  String id;
  String status;
  Config config;
  @override
  State<DetailTimerWidget> createState() => _DetailTimerWidgetState();
}

class _DetailTimerWidgetState extends State<DetailTimerWidget> {
  var lastTerminatedDetail = "";
  int seconds = 0;
  int minutes = 0;
  int hours = 0;

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
    if (widget.status != "T" &&
        widget.config.mostrarUltimoTiempo!.contains("S")) {
      setState(() {
        hours = 0;
        minutes = 0;
        seconds = 0;
      });
      UserSharedPreferences.setDetailTimer(widget.id, _checkTimerDetail());
    }
    if (widget.config.mostrarUltimoTiempo!.contains("S") &&
            widget.status == "T" ||
        (widget.config.soloUltimoPlato!.contains("S") &&
            lastTerminatedDetail == widget.id)) {
      UserSharedPreferences.getDetailTimer(widget.id).then((value) {
        var timer = value.split(":");

        setState(() {
          hours = int.parse(timer[0]);
          minutes = int.parse(timer[1]);
          seconds = int.parse(timer[2]);
        });
      });

      Timer.periodic(const Duration(seconds: 1), (timer) {
        
        setState(() {
          seconds++;
        });
        //Seteamos cada segundo
        UserSharedPreferences.setDetailTimer(widget.id, _checkTimerDetail());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _checkTimerDetail(),
      style: Styles.timerDetailStyle(
          double.parse(widget.config.letra!) * increaseFont),
    );
  }

//Temporizador de los details terminados
  _checkTimerDetail() {
    _writeNumber(int value) {
      if (value < 10) {
        return "0$value";
      } else {
        return "$value";
      }
    }

    if (seconds >= 60) {
      setState(() {
        seconds = 0;
        minutes++;
      });

      if (minutes >= 60) {
        setState(() {
          minutes = 0;
          hours++;
        });
      }
    }

    return "${_writeNumber(hours)}:${_writeNumber(minutes)}:${_writeNumber(seconds)}";
  }
}
