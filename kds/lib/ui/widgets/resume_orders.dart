// ignore_for_file: void_checks

import 'package:flutter/material.dart';
import 'package:kds/ui/styles/styles.dart';

class ResumeOrdersWidget extends StatefulWidget {
  ResumeOrdersWidget({Key? key, Stream<String>? lineasComandas})
      : super(key: key);

  //TODO: Hacer una operación STREAM desde HOME y pasarla a ResumeOrdersWidget
  Stream<String>? lineasComandas;
  @override
  State<ResumeOrdersWidget> createState() => _ResumeOrdersWidgetState();
}

class _ResumeOrdersWidgetState extends State<ResumeOrdersWidget> {
  //Para probar el stream

  List<String> lista = ["Producto 1", "Producto 2", "Producto 3"];

  @override
  Widget build(BuildContext context) {
    //widget.lineasComandas = Stream.value("Otro dato");
    widget.lineasComandas = Stream.fromIterable(lista);
    
    //bucle???s
    //widget.lineasComandas?.map((event) => '$event').listen(print);

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
            width: respWidth,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: Styles.black),
            child: Text(
              "Resumen",
              textAlign: TextAlign.center,
              style: Styles.resumeTitle,
            ),
          ),
          StreamBuilder(
            stream: widget.lineasComandas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return TILE CLICKABLE
                //TODO: Ver por qué saca el último del stream solamente
                return Text(snapshot.data!.toString());
              }

              if (snapshot.hasError) {
                return Text("Nada por aquí.");
              } else {
                return Text("Espera...");
              }
            },
          )

          /*
          Container(
            width: respWidth,
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
          ),*/
        ],
      ),
    );
  }
}
