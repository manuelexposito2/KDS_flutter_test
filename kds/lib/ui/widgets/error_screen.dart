import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 80),
        width: 600,
        height: 100,
        color: Colors.white,
        child: const Text(
          
          'Error..',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
