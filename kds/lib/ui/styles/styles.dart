import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
  // Colors
  static const Color succesColor = Color.fromARGB(255, 52, 172, 42);
  static const Color mediumColor = Color(0xFFEFA617);
  static const Color baseColor = Color.fromARGB(255, 14, 148, 226);
  static const Color alertColor = Color.fromARGB(255, 212, 22, 22);

  //Text

  static TextStyle get textTitle => GoogleFonts.getFont('Roboto',
      fontSize: 23, color: Color.fromARGB(255, 87, 87, 87), fontWeight: FontWeight.w700);

  static TextStyle get urgent => GoogleFonts.getFont('Roboto',
      fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700);

  static TextStyle get regularText => GoogleFonts.getFont('Roboto',
      fontSize: 15, color: Colors.white);

  
}
