

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcons{

  static Widget clock(color, double width) => SvgPicture.asset('assets/images/clock.svg', color: color, width: width);
  static Widget fullscreen = const Icon(Icons.fullscreen);
  static Widget refresh = const Icon(Icons.refresh);
  static Widget person = const Icon(Icons.person);
  static Widget menu = const Icon(Icons.menu);

}