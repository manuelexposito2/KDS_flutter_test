// ignore_for_file: void_checks

import 'package:flutter/material.dart';
import 'package:kds/models/last_orders_response.dart';
import 'package:kds/ui/styles/styles.dart';

class ResumeOrdersWidget extends StatefulWidget {
  ResumeOrdersWidget({Key? key, required this.lineasComandas})
      : super(key: key);

  //TODO: Hacer una operación STREAM desde HOME y pasarla a ResumeOrdersWidget
  final List<Details>? lineasComandas;
  @override
  State<ResumeOrdersWidget> createState() => _ResumeOrdersWidgetState();
}

class _ResumeOrdersWidgetState extends State<ResumeOrdersWidget> {
  //Para probar el stream

  @override
  Widget build(BuildContext context) {
    //widget.lineasComandas = Stream.value("Otro dato");

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
          Expanded(
            flex: 20,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: widget.lineasComandas!.length,
              itemBuilder: (context, index) {

                //TODO:
                //Método que transforme el título separandolo por la X y sumando por nombre.

                var titulo = widget.lineasComandas!
                    .elementAt(index)
                    .demTitulo
                    .toString();

                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    primary: Color.fromARGB(255, 87, 87, 87),
                  ),
                  onPressed: () {},
                  child: ListTile(
                    title: Text(
                      titulo,
                      style: Styles.textTitle,
                    ),
                  ),
                );
              },
            ),
          ),

          /*
          StreamBuilder(
            stream: widget.lineasComandas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //return TILE CLICKABLE
                for(var w in words!){
                  return Text(w);
                }
              }

              if (snapshot.hasError) {
                return Text("Nada por aquí.");
              } else {
                return Text("Espera...");
              }
            },
          )
*/
        ],
      ),
    );
  }
}
