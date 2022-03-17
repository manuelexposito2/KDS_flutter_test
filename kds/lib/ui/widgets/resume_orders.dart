import 'package:flutter/material.dart';
import 'package:kds/ui/styles/styles.dart';
import 'package:kds/ui/widgets/bottom_nav_bar.dart';

class ResumeOrdersWidget extends StatefulWidget {
  const ResumeOrdersWidget({Key? key}) : super(key: key);

  @override
  State<ResumeOrdersWidget> createState() => _ResumeOrdersWidgetState();
}

class _ResumeOrdersWidgetState extends State<ResumeOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    double respWidth = MediaQuery.of(context).size.width;
    double respHeight = MediaQuery.of(context).size.height;
    

    return Container(
      margin: const EdgeInsets.all(5.0),
      height: respHeight - Styles.navbarHeight,
      decoration: BoxDecoration(
          border: Styles.borderSimple,
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: [
          Container(
            width: respWidth / 6,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: Styles.black),
            child: Text(
              "Resumen",
              textAlign: TextAlign.center,
              style: Styles.resumeTitle,
            ),
          ),
          Container(
            width: respWidth / 6,
            padding: const EdgeInsets.all(14.0),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey),
              ),
            ),
            //TODO: TRAER DATOS REALES
            child: Text(
              "1 X PRODUCTO",
              textAlign: TextAlign.center,
              style: Styles.productResumeLine,
            ),
          ),
        ],
      ),
    );
  }
}
