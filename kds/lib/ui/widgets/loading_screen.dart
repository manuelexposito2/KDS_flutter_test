
import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({Key? key, required this.message})
      : super(key: key);

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
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
