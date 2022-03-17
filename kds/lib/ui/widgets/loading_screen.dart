import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

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
            child: Lottie.asset('assets/images/loading.json'),
          ),
          Container(child: Text(message, textAlign: TextAlign.center,),)
        ],
      ),
    );
  }
}
