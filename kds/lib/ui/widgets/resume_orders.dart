

import 'package:flutter/material.dart';
import 'package:kds/ui/styles/styles.dart';

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
          
          Expanded(
            flex: 20,
            child: ListView.builder(
              padding: Styles.zeroPadding,
              scrollDirection: Axis.vertical,
              itemCount: widget.lineasComandas!.length,
              itemBuilder: (context, index) {
                return OutlinedButton(
                  style: Styles.tileStyle,
                  onPressed: () {},
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                    dense: true,
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
