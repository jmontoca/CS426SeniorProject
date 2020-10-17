//main.dart is the runner of the app. This file is required by flutter and dart to properly guide the program
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterApp/loginPage.dart';

//calls the class to intiate the program
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
        home: LoginPage(), 
    );
  }
}
