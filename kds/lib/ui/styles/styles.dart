import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Styles {
// Colors
  static const Color succesColor = Color(0xFF449D44);
  static const Color mediumColor = Color(0xFFEFA617);
  static const Color baseColor = Color.fromARGB(255, 14, 148, 226);
  static const Color alertColor = Color(0xFFB85C5C);
  static final Color yellowBtn = Color(0xFFF0AD4E);
  static final Color greenBtn = Color(0xFF5CB85C);
  static final Color whiteBtn = Colors.white;
  static final Color blueBtnColor = Color(0xFF337AB7);

  
  static final Color black = Color(0xFF3D3D3D);
  static final Color bottomNavColor = Color.fromARGB(132, 0, 0, 0);


//TODO: Rehacer estilo para el borde de las cajas de RESUME

//SIZES

  static TextStyle btnTextSize(color) =>
      TextStyle(fontSize: 18.0, color: color);
  static double btnPaddingV = 26.0;
  static double btnPaddingH = 70.0;

  static double navbarHeight = 70.0;

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

//Botones pantalla pequeña

static final buttonEnProcesomin = ElevatedButton.styleFrom(
  minimumSize: Size(250, 60) ,
  maximumSize: Size(250, 60),
    primary: yellowBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
  static final buttonTerminadasmin = ElevatedButton.styleFrom(
    minimumSize: Size(250, 60) ,
  maximumSize: Size(250, 60),
    primary: greenBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
  static final buttonTodasmin = ElevatedButton.styleFrom(
    minimumSize: Size(250, 60) ,
  maximumSize: Size(250, 60),
    primary: whiteBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );

//

  static final btnActionStyle = ElevatedButton.styleFrom(
      primary: blueBtnColor,
      padding: const EdgeInsets.all(20.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))));

  //Text

  static TextStyle get resumeTitle => GoogleFonts.getFont('Roboto',
      fontSize: 25, color: Colors.white, fontWeight: FontWeight.w900);

  static TextStyle get productResumeLine => GoogleFonts.getFont('Roboto',
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600);

  static TextStyle get textTitle => GoogleFonts.getFont('Roboto',
      fontSize: 24,
      color: Color.fromARGB(255, 87, 87, 87),
      fontWeight: FontWeight.w700);

  static TextStyle get urgent => GoogleFonts.getFont('Roboto',
      fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700);

  static TextStyle get regularText =>
      GoogleFonts.getFont('Roboto', fontSize: 17, color: Colors.white);

  static TextStyle get textWarning => GoogleFonts.getFont('Roboto',
      fontSize: 25, color: Colors.black);
  
}
