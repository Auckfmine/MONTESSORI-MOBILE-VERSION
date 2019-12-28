import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_ui/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Rv extends StatefulWidget {
  @override
  _RvState createState() => _RvState();
}

class _RvState extends State<Rv> {
  void _showDialog(msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: new Text('alert'),
            content: Text(msg),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Fermer"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  void popUp(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Rendez-vous"),
      content: Text(
          "Vore demande a été bien envoyée.Nous vous repondrons dans le plus bref possible.\nMerci!"),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
        body: new Stack(children: <Widget>[
      Positioned.fill(
        child: Image.asset('assets/addchild.png', fit: BoxFit.cover),
      ),
      Positioned(
          top: MediaQuery.of(context).size.height / 5,
          left: MediaQuery.of(context).size.width / 8,
          child: Container(
              child: Text(
                "Rendez-vous",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 35,
                  fontFamily: "LuckiestGuy",
                ),
              ),
              color: Colors.transparent)),
      Positioned(
        top: MediaQuery.of(context).size.height / 2.5,
        left: MediaQuery.of(context).size.width / 3,
        child: Container(
            child: GestureDetector(
          onTap: _handleRv,
            
          
          child: ClipOval(
            child: Container(
              height: 120.0,
              width: 140.0,
              color: Color(0xff7B318A),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                  ),
                  Text("Réserver",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: "LuckiestGuy"))
                ],
              ),
            ),
          ),
        )),
      ),
      Positioned(
        child: Text(
          "Cliquer sur 'Réserver' ",
          style: TextStyle(fontFamily: "LuckiestGuy", fontSize: 20),
        ),
        top: 440,
        right: 80,
      )
    ]));
  }
  void _handleRv()async {

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString("csrf_token");
    var csrfToken_2 = localStorage.getString("csrf_token2");
    //var serverid = localStorage.getString("serverid");
    var url ="http://10.0.2.2:8000/api/v1/ff/";

    var data = {};

    var res = await http.post(
            url, 
            body: jsonEncode(data), 
            headers: {
              "Content-Type":"application/json",
              "Accept":"application/json",
              "Cookie": "$sessionId; $csrfToken",
              "X-CSRFToken": csrfToken_2.toString()
            }
        );
    var body = json.decode(res.body);
    var statusCode = res.statusCode ;
    //print(body);

    if( statusCode ==201 || statusCode==200){
      _showDialog("Vore demande a été bien envoyée.Nous vous repondrons dans le plus bref possible.\nMerci!");
    }
  }

  
}


