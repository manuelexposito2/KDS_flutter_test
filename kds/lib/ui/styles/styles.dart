import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
// Colors
  static const Color succesColor = Color.fromARGB(255, 52, 172, 42);
  static const Color mediumColor = Color(0xFFEFA617);
  static const Color baseColor = Color.fromARGB(255, 14, 148, 226);
  static const Color alertColor = Color.fromARGB(255, 212, 22, 22);
  static final Color yellowBtn = Color(0xFFF0AD4E);
  static final Color greenBtn = Color(0xFF5CB85C);
  static final Color whiteBtn = Colors.white;
  static final Color blueBtnColor = Color(0xFF337AB7);

  static final Color bottomNavColor = Color.fromARGB(136, 41, 34, 34);

//SIZES

  static TextStyle btnTextSize(color) =>
      TextStyle(fontSize: 18.0, color: color);
  static double btnPaddingV = 26.0;
  static double btnPaddingH = 70.0;


  
//BUTTONS STYLE

  static final buttonEnProceso = ElevatedButton.styleFrom(
    primary: yellowBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
  );
  static final buttonTerminadas = ElevatedButton.styleFrom(
    primary: greenBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
  );
  static final buttonTodas = ElevatedButton.styleFrom(
    primary: whiteBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(5), bottomRight: Radius.circular(5))),
  );

  static final btnActionStyle = ElevatedButton.styleFrom(
      primary: blueBtnColor,
      padding: const EdgeInsets.all(20.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))));

  //Text

  static TextStyle get textTitle => GoogleFonts.getFont('Roboto',
      fontSize: 23,
      color: Color.fromARGB(255, 87, 87, 87),
      fontWeight: FontWeight.w700);

  static TextStyle get urgent => GoogleFonts.getFont('Roboto',
      fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700);

  static TextStyle get regularText =>
      GoogleFonts.getFont('Roboto', fontSize: 15, color: Colors.white);
}
