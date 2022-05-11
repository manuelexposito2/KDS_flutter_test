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

  Duration duration = Duration();

  Timer? timer;
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
    UserSharedPreferences.getDetailTimer(widget.id).then((value) {
      duration = Duration(seconds: value);
    });

    if (widget.config.mostrarUltimoTiempo!.contains("S") &&
            widget.status == "T" ||
        (widget.config.soloUltimoPlato!.contains("S") &&
            lastTerminatedDetail == widget.id)) {
      startTimer();
    }
  }

  void addTime() {
    final addSeconds = 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      addTime();

      UserSharedPreferences.setDetailTimer(widget.id, duration.inSeconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: Styles.timerDetailStyle(
          double.parse(widget.config.letra!) * increaseFont),
    );
  }
}
