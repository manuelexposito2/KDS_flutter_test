import 'package:flutter/material.dart';
import 'package:kds/ui/widgets/prueba.dart';

void main() {
  
  runApp(const MyApp());
  //flutter run -d chrome --web-port=82
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Prueba()
      },
    );
  }
}

