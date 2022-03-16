import 'package:flutter/material.dart';

class Styles {
//COLORES

  static final Color yellowBtn = Color(0xFFF0AD4E);
  static final Color greenBtn = Color(0xFF5CB85C);
  static final Color whiteBtn = Colors.white;
  static final Color blueBtnColor = Color(0xFF337AB7);

  static final Color bottomNavColor = Color.fromARGB(136, 41, 34, 34);

//SIZES

static TextStyle btnTextSize(color) => TextStyle(fontSize: 18.0, color: color);
static double btnPaddingV = 26.0;
static double btnPaddingH = 70.0;
//BUTTONS STYLE

  static final buttonEnProceso = ElevatedButton.styleFrom(
    primary: yellowBtn,
    padding: EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
  );
  static final buttonTerminadas = ElevatedButton.styleFrom(
    primary: greenBtn,
    padding: EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
  );
  static final buttonTodas = ElevatedButton.styleFrom(
    primary: whiteBtn,
    padding: EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
  );

  static final btnActionStyle = ElevatedButton.styleFrom(
      primary: blueBtnColor,
      padding: const EdgeInsets.all(20.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))));
}
