import 'package:flutter/material.dart';
import 'home.dart';
import 'package:toast/toast.dart';

void main() => runApp(MaterialApp(
  home:MyApp()));

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Raleway',
      ),
           home: Home(),
        
      debugShowCheckedModeBanner: false,
    );
  }

}