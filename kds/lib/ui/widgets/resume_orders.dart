// ignore_for_file: void_checks

import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/ui/styles/styles.dart';
import "package:collection/collection.dart";

class ResumeOrdersWidget extends StatefulWidget {
  ResumeOrdersWidget({Key? key, required this.lineasComandas})
      : super(key: key);

  //TODO: Hacer una operación STREAM desde HOME y pasarla a ResumeOrdersWidget
  final List<String>? lineasComandas;
  @override
  State<ResumeOrdersWidget> createState() => _ResumeOrdersWidgetState();
}

class _ResumeOrdersWidgetState extends State<ResumeOrdersWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topCenter,
              width: respWidth,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(color: Styles.black),
              child: Text(
                "Resumen",
                textAlign: TextAlign.center,
                style: Styles.resumeTitle,
              ),
            ),
          ),
          //TODO: Hacer más estrechas las tiles y marcar la linea entre ellas
          Expanded(
            flex: 20,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.lineasComandas!.length,
              itemBuilder: (context, index) {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    primary: Color.fromARGB(255, 87, 87, 87),
                  ),
                  onPressed: () {},
                  child: ListTile(
                    //style: ListTileStyle.drawer,
                    title: Text(
                      widget.lineasComandas!.elementAt(index),
                      style: Styles.textTitle,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
