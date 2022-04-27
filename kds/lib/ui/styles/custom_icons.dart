

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcons{

  static Widget clock(color, double width) => SvgPicture.asset('assets/images/clock.svg', color: color, width: width);
  static Widget fullscreen = const Icon(Icons.fullscreen);
  static Widget refresh = const Icon(Icons.refresh);
  static Widget person = const Icon(Icons.person);
  static Widget menu = const Icon(Icons.menu);

  static Widget closeBlueBtn(context) => ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.close, size: 23.5),
                      ),
                      TextSpan(
                        text: "Cerrar",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ));
}