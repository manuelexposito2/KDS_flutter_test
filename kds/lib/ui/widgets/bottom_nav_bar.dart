import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  

  String? _timeString;

  //TODO: Ver como sacar la versión
  var version = "v.1.1.9";

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

//MOSTRAR LA HORA
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

//BOTTOM BAR
  @override
  Widget build(BuildContext context) {
    double responsiveWidth = MediaQuery.of(context).size.width;
    return Container(
      height: Styles.navbarHeight,
      color: Styles.bottomNavColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(text: version),
                  WidgetSpan(
                    child: CustomIcons.clock(Colors.white, 28),
                  ),
                  
                  TextSpan(text: _timeString, style: TextStyle(fontSize: 30.0)),
                ],
              ),
            ),
            Row(
              //3 BOTONES

              children: [
                ElevatedButton(
                  onPressed: () async {
                    Preferences.setQueryParam("COMANDAS EN PROCESO");
                  },
                  child: Text("En proceso",
                      style: Styles.btnTextSize(Colors.white)),
                  style: Styles.buttonEnProceso,
                ),
                ElevatedButton(
                    onPressed: () async {
                      Preferences.setQueryParam("COMANDAS TERMINADAS");
                    },
                    child: Text("Terminadas",
                        style: Styles.btnTextSize(Colors.white)),
                    style: Styles.buttonTerminadas),
                ElevatedButton(
                    onPressed: () async {
                      Preferences.setQueryParam("TODAS LAS COMANDAS");
                    },
                    child: Text(
                      "Todas",
                      style: Styles.btnTextSize(Colors.black),
                    ),
                    style: Styles.buttonTodas)
              ],
            ),
            SizedBox(
              width: 280.0,
              child: Row(
                ///// 4 OPCIONES
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.menu),
                    style: Styles.btnActionStyle,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.person),
                    style: Styles.btnActionStyle,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.refresh),
                    style: Styles.btnActionStyle,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.fullscreen),
                    style: Styles.btnActionStyle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
