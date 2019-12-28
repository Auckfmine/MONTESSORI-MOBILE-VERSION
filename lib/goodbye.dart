import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/LoginPage.dart';


class Goodbye extends StatefulWidget {
  @override
  _GoodbyeState createState() => _GoodbyeState();
}

class _GoodbyeState extends State<Goodbye> {
  @override
  void initState() {
    
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.pink),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 110,
                        child: Image.asset("assets/gg.png",width: MediaQuery.of(context).size.width/2 ,)
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        "Minino's",
                        style: TextStyle(
                            color: Colors.white,
                            
                            fontSize: 40,fontFamily: "LuckiestGuy"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Au Revoir ...",
                        style: TextStyle(
                            color: Colors.yellowAccent,
                            
                            fontSize: 30,fontFamily: "LuckiestGuy"),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "chargement ...",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white,fontFamily: "Sacramento"),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}