import 'package:flutter/material.dart';
import 'package:kds/ui/styles/styles.dart';

class LabeledCheckbox extends StatefulWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<LabeledCheckbox> createState() => _LabeledCheckboxState();
}

class _LabeledCheckboxState extends State<LabeledCheckbox> {
  late String label;
  late EdgeInsets padding;
  late bool value;
  late ValueChanged<bool> onChanged;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    label = widget.label;
    padding = widget.padding;
    onChanged = widget.onChanged;
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),

              value: value,
              onChanged: (bool? newValue) {
                setState(() {
                  
                  onChanged(newValue!);
                });
              },
            ),
            Expanded(
                child: Text(
              label,
              style: Styles.textBoldInfo,
            )),
          ],
        ),
      ),
    );
  }
}


/* 
class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    Key? key,
    required this.label,
    required this.padding,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            Expanded(
                child: Text(
              label,
              style: Styles.textBoldInfo,
            )),
          ],
        ),
      ),
    );
  }
}
 */