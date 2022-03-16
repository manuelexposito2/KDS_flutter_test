import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  var navbarHeight = 50.0;
  var version = "v.1.1.9";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: navbarHeight,
      color: Color.fromARGB(179, 29, 16, 16),
      child: Row(
        children: [
        //TODO:
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.white),
              children: [
                TextSpan(text: version),
                WidgetSpan(
                  child: Icon(Icons.lock_clock, size: 20, color: Colors.white,),
                ),
                TextSpan(
                  text: "12:45:00",
                ),
              ],
            ),
          ),
          Row(
            children: [],
          ),
          Row(
            children: [],
          )

          ///// 4 OPCIONES
        ],
      ),
    );
  }
}
