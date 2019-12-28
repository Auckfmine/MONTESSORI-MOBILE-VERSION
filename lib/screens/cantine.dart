import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http ;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cantine extends StatefulWidget {
  @override
  _CantineState createState() => _CantineState();
}

class _CantineState extends State<Cantine> {
  int _currentValue = 0;

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return new NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 100,
            title: new Text(
              "Choisir Le Nombre De Bons",
            ),
            initialIntegerValue: _currentValue,
          );
        }).then((int value) {
      if (value != null) {
        setState(() => _currentValue = value);
      }
    });
  }
    
  void popUp(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Cantine"),
      content: Text("Votre demande a été bien envoyée.   Merci!"),
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
      body: SingleChildScrollView(
              child: Stack(children: <Widget>[
          Positioned.fill(
            child: new Image.asset(
              'assets/addchild.png',
              fit: BoxFit.cover,
            ),
          ),
          
          Container(color: Colors.transparent,
          child: Stack(children: <Widget>[
            Positioned(
            top: MediaQuery.of(context).size.height / 3,
            child: Text(
                "  Vous Pouvez Réserver des bons de cantine\n   en cliquant sur le boutton ci-dessous",style: TextStyle(fontFamily: "LuckiestGuy"),),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 2,
              left: MediaQuery.of(context).size.width / 3.5,
              child: Container( decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],),
                            child: RaisedButton(
                  color: Color(0xffD3D3D3),
                  child: new Text("Bons Réservés : $_currentValue ",
                      style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black,fontFamily: "LuckiestGuy")),
                  onPressed: () {
                    _showDialog();
                  },
                ),
              )),
          Padding(
              child: Center(
                child: Container(
                  //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/40),
                  width: MediaQuery.of(context).size.height / 5,
                  height: MediaQuery.of(context).size.width / 7.4,
                  child: RaisedButton(
                    //padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/5),
                      color: Color(0xff7B318A),
                      onPressed: _handleCantine
                        
                      ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                          child: Text("Envoyer",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "LuckiestGuy",
                                  color: Colors.white)))),
                ),
              ),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 1.2,
              ) 
              ),
          Positioned(
            top: MediaQuery.of(context).size.height / 10,
            left: MediaQuery.of(context).size.width / 3,
            child: SizedBox(
              
                width: 130,
                height: 130,
                child: Image.asset(
                  'assets/gg.png',
                  fit: BoxFit.cover,
                )),
          ),
          
          ],),)
        ,SizedBox(height: MediaQuery.of(context).size.height,)]),
      ),
    );
  }



  void _handleCantine()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    

    var url = "http://10.0.2.2:8000/api/v1/cantine";
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString('csrf_token2');
    //var server = localStorage.getString("serverid");

    var data = {
      "meals":_currentValue,

    };

    var res = await http.post(url,body: jsonEncode(data),headers:{
      "Content-type":"application/json",
      "Accept":"application/json",
      "Cookie":"$sessionId; $csrfToken",
      "X-CSRFToken":"$csrfToken2",
    } );

    var body = json.decode(res.body);


    
    popUp(context);
  }
}
