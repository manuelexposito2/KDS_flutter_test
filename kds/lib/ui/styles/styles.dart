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
  static final Color whiteBtn = Color.fromARGB(255, 255, 255, 255);
  static final Color purpleBtn = Color.fromARGB(255, 149, 27, 170);
  static final Color blueBtnColor = Color(0xFF337AB7);

  static final Color incidenciaColor = Color(0xFFf44336);

  static final Color black = Color(0xFF3D3D3D);
  static final Color bottomNavColor = Color.fromARGB(132, 0, 0, 0);

  static BoxBorder borderSimple = Border.all(color: black);

  static ButtonStyle tileStyle = ButtonStyle(
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0))),
  );

//SIZES
  static double urgentDefaultSize = 27.0;
  static TextStyle btnTextSize(color) =>
      TextStyle(fontSize: 18.0, color: color);
  static double btnPaddingV = 26.0;
  static double btnPaddingH = 70.0;
  static double navbarHeightConfMax = 130.0;
  static double navbarHeightConfMed = 250.0;
  static double navbarHeightConfMin = 350.0;
  static double navbarHeightConfMinReparto = 390;

  static double navbarHeight = 100.0;
  static EdgeInsets zeroPadding = EdgeInsets.all(0.0);
  static double buttonsOptionsWidth = 280.0;
  static EdgeInsets espaciadoInfo = EdgeInsets.only(bottom: 20);
//BUTTONS STYLE

  static final buttonEnProceso = ElevatedButton.styleFrom(
    primary: yellowBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), bottomLeft: Radius.circular(5))),
  );

  static final buttonRecoger = ElevatedButton.styleFrom(
    primary: purpleBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(0), bottomLeft: Radius.circular(0))),
  );

  static final buttonRecogerMin = ElevatedButton.styleFrom(
    minimumSize: Size(250, 60),
    maximumSize: Size(250, 60),
    primary: purpleBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );

  static final buttonTerminadas = ElevatedButton.styleFrom(
    primary: greenBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.zero)),
  );
// -------------------------------------
  static final buttonPeso = ElevatedButton.styleFrom(
    primary: whiteBtn,
    minimumSize: Size(260, 120),
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
    minimumSize: Size(250, 60),
    maximumSize: Size(250, 60),
    primary: yellowBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
  static final buttonTerminadasmin = ElevatedButton.styleFrom(
    minimumSize: Size(250, 60),
    maximumSize: Size(250, 60),
    primary: greenBtn,
    padding:
        EdgeInsets.symmetric(vertical: btnPaddingV, horizontal: btnPaddingH),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5))),
  );
  static final buttonTodasmin = ElevatedButton.styleFrom(
    minimumSize: Size(250, 60),
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

  static Widget infoTitle(Icon icon, String text, String data) {
    return Padding(
      padding: espaciadoInfo,
      child: Row(
        children: [
          icon,
          Text(text, style: Styles.textBoldInfo),
          Text(data, style: Styles.textRegularInfo)
        ],
      ),
    );
  }

  static TextStyle get resumeTitle => GoogleFonts.getFont('Roboto',
      fontSize: 25, color: Colors.white, fontWeight: FontWeight.w900);

  static TextStyle get productResumeLine => GoogleFonts.getFont('Roboto',
      fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600);

  static TextStyle textTitle(double fontSize) => GoogleFonts.getFont('Roboto',
      fontSize: fontSize,
      color: Color.fromARGB(255, 87, 87, 87),
      fontWeight: FontWeight.w700);

  static TextStyle subTextTitle(double fontSize) =>
      GoogleFonts.getFont('Roboto',
          fontSize: fontSize, color: Color.fromARGB(255, 87, 87, 87));

  static TextStyle urgent(double fontSize) => GoogleFonts.getFont('Roboto',
      fontSize: fontSize, color: Colors.white, fontWeight: FontWeight.w700);

  static TextStyle get regularText =>
      GoogleFonts.getFont('Roboto', fontSize: 17, color: Colors.white);

  static TextStyle get textWarning =>
      GoogleFonts.getFont('Roboto', fontSize: 25, color: Colors.black);

      static TextStyle get textPesoBtn =>
      GoogleFonts.getFont('Roboto', fontSize: 25, color: Color.fromARGB(255, 44, 44, 44));

  static TextStyle get textBoldInfo =>
      GoogleFonts.getFont('Roboto', fontSize: 27, fontWeight: FontWeight.w700);

  static TextStyle timerDetailStyle(double fontSize) =>
      GoogleFonts.getFont('Roboto',
          fontSize: fontSize, color: Colors.red, fontWeight: FontWeight.w800);

  static TextStyle get textTitleInfo =>
      GoogleFonts.getFont('Roboto', fontSize: 34);

  static TextStyle get textRegularInfo =>
      GoogleFonts.getFont('Roboto', fontSize: 25);

  static TextStyle get textTicketInfo =>
      GoogleFonts.getFont('Red Hat Mono', fontSize: 14);

  static TextStyle get textButtonOperario =>
      GoogleFonts.getFont('Roboto', fontSize: 40, color: Colors.white);

  static TextStyle get textButtonCancelar =>
      GoogleFonts.getFont('Roboto', fontSize: 35, color: Colors.white);

  static TextStyle get textContadores =>
      GoogleFonts.getFont('Roboto', fontSize: 32, color: Colors.green);

  //UTILS

  static Container separadorComanda = Container(
    color: Colors.grey[800],
    height: 6.0,
  );
}
