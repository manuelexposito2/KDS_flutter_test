import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/utils/constants.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  String? _timeString;

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
    return SizedBox(
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
    );
  }

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
