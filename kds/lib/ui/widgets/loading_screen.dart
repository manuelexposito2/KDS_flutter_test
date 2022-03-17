import 'package:flutter/cupertino.dart';


class LoadingScreen extends StatelessWidget {
  final String message;

  const LoadingScreen({Key? key, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 300,
            
          ),
          Container(child: Text(message, textAlign: TextAlign.center,),)
        ],
      ),
    );
  }
}
