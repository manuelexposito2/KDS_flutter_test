import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kds/ui/styles/styles.dart';

class ComandaCard extends StatefulWidget {
  const ComandaCard({Key? key}) : super(key: key);

  @override
  State<ComandaCard> createState() => _ComandaCardState();
}

class _ComandaCardState extends State<ComandaCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
     
      margin: EdgeInsets.all(10),
      color: Colors.green,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('10 min.', style: TextStyle(color: Colors.white),), Text('1/5', style: TextStyle(color: Colors.white),)],
                ),),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      Text(
                        'Nombre',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [Icon(Icons.push_pin, color: Colors.white,), Text('1', style: TextStyle(color: Colors.white),)],
                      ),
                      Container(
                        width: 40,
                        height: 30,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              primary: Color.fromARGB(255, 71, 71, 71)),
                          child: Icon(Icons.info),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 195,
                  height: 50,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white, primary: Color.fromARGB(255, 87, 87, 87), textStyle: TextStyle(fontSize: 18)),
                    onPressed: () {},
                    icon: Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(255, 54, 115, 194), size: 30,
                    ),
                    label: Text(
                      'Preparar',
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white, primary: Color.fromARGB(255, 87, 87, 87)),
                    child: Icon(Icons.print),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Color.fromARGB(255, 223, 60, 49),
            alignment: Alignment.center,
            height: 50,
            //Hacer condición de que solo sale este espacio si se da tap en el botón de urgente
            child: Text('¡¡¡URGENTE!!!', style: TextStyle(fontSize: 25, color: Colors.white),),
          ),
          Container(
            color: Color.fromARGB(255, 241, 241, 241),
            margin: EdgeInsets.only(left: 1, right: 1, bottom: 1),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            height: 50,
            child: Text('Comandas'),
          )
        ],
      ),
    );
  }
}
