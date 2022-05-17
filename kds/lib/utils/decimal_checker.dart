import 'package:flutter/services.dart';
import 'dart:math' as math;

class DecimalChecker extends TextInputFormatter {
  DecimalChecker({this.decimalRange = 3})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String valueTxt = newValue.text;
    TextSelection valueSet = newValue.selection;
    var newlength = newValue.text.length;
    var oldlength = oldValue.text.length;
    if (oldlength < newlength) {
      Pattern p = RegExp(r'(\d+\.?)|(\.?\d+)|(\.?)');
      valueTxt = p
          .allMatches(valueTxt)
          .map<String>((Match match) => match.group(0)!)
          .join();
      print("------>");
      if (valueTxt.startsWith('.')) {
        valueTxt = '0.';
      } else if (valueTxt.contains('.')) {
        if (valueTxt.substring(valueTxt.indexOf('.') + 1).length >
            decimalRange) {
          valueTxt = oldValue.text;
        } else {
          if (valueTxt.split('.').length > 2) {
            List<String> split = valueTxt.split('.');
            valueTxt = split[0] + '.' + split[1];
          }
        }
      }

      valueSet = newValue.selection.copyWith(
        baseOffset: math.min(valueTxt.length, valueTxt.length + 1),
        extentOffset: math.min(valueTxt.length, valueTxt.length + 1),
      );

      return TextEditingValue(
          text: valueTxt, selection: valueSet, composing: TextRange.empty);
    } else {
      return TextEditingValue(
          text: valueTxt, selection: valueSet, composing: TextRange.empty);
    }
  }
}
