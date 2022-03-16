import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComandaCard extends StatefulWidget {
  const ComandaCard({Key? key}) : super(key: key);

  @override
  State<ComandaCard> createState() => _ComandaCardState();
}

class _ComandaCardState extends State<ComandaCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('10 min.'), Text('1/5')],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.person), Text('Nombre')],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [Icon(Icons.push_pin), Text('1')],
                    ),
                    Container(
                        child: Ink(
                      decoration: const ShapeDecoration(
                          color: Colors.black, shape: CircleBorder()),
                      child: IconButton(
            icon: const Icon(Icons.info),
            color: Colors.white,
            onPressed: () {},
          ),
                    ))
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Icon(Icons.play_arrow), Icon(Icons.print)],
            ),
          ),
          Container(
            child: Text('URGENTE'),
          ),
          Container(
            child: Text('Comandas'),
          )
        ],
      ),
    );
  }
}
