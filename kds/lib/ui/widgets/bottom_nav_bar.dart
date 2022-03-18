import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kds/ui/styles/custom_icons.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var navbarHeightmin = 280.0;
  var navbarHeightMedium = 150.0;
  var navbarHeight = 70.0;

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.minWidth > 1250) {
          return Container(
            height: navbarHeight,
            color: Styles.bottomNavColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_time(), _buttonsNavigate(), _buttonsFilter()],
                )),
          );
        } else if (constraints.minWidth > 900){
          return Container(
            height: navbarHeightMedium,
            color: Styles.bottomNavColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_time(), _buttonsNavigate(), _buttonsFilter()],
              )
            ],
          )),
          );
        }
        
         else {
          return Container(
            height: navbarHeightmin,
            color: Styles.bottomNavColor,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: responsiveWidth / 40),
                child: Column(
            children: [
              Column(
                children: [_time(), _buttonsNavigateMin(), _buttonsFilter()],
              )
            ],
          )),
          );
        }
      },
    );
  }

  Widget _time() {
    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.white,),
        children: [
          TextSpan(text: version),
          WidgetSpan(
            child: CustomIcons.clock(Colors.white, 28),
          ),
          TextSpan(text: _timeString, style: TextStyle(fontSize: 30.0)),
        ],
      ),
    );
  }

  Widget _buttonsNavigate() {
    return Row(
      //3 BOTONES
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("En proceso", style: Styles.btnTextSize(Colors.white)),
          style: Styles.buttonEnProceso,
        ),
        ElevatedButton(
            onPressed: () {},
            child: Text("Terminadas", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonTerminadas),
        ElevatedButton(
            onPressed: () {},
            child: Text(
              "Todas",
              style: Styles.btnTextSize(Colors.black),
            ),
            style: Styles.buttonTodas)
      ],
    );
  }

  Widget _buttonsNavigateMin() {
    return Container(
      padding: EdgeInsets.only(bottom: 10, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text("En proceso", style: Styles.btnTextSize(Colors.white)),
            style: Styles.buttonEnProcesomin,
          ),
          ElevatedButton(
              onPressed: () {},
              child:
                  Text("Terminadas", style: Styles.btnTextSize(Colors.white)),
              style: Styles.buttonTerminadasmin),
          ElevatedButton(
              onPressed: () {},
              child: Text(
                "Todas",
                style: Styles.btnTextSize(Colors.black),
              ),
              style: Styles.buttonTodasmin)
        ],
      ),
    );
  }

  Widget _buttonsFilter() {
    return SizedBox(
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
    );
  }

  Widget _buttonsFiltermin() {
    return SizedBox(
      width: 280.0,
      child: Column(
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
    );
  }
}
