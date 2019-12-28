import 'package:flutter/material.dart';
import 'package:flutter_login_ui/SplashScreen.dart';
import 'package:flutter_login_ui/goodbye.dart';
import 'package:flutter_login_ui/screens/LoginPage.dart';
import 'package:flutter_login_ui/screens/student.dart';










void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MONTESSORI', 
      home: Scaffold(
        body: SplashScreen(),
      ),   
    );
  }
}



