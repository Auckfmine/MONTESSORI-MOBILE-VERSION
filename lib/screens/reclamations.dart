import 'dart:convert';

import 'package:http/http.dart' as http ;

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Reclammation extends StatefulWidget {
  @override
  _ReclammationState createState() => _ReclammationState();
}

class _ReclammationState extends State<Reclammation> {
  bool _isLoading = false;

  TextEditingController reclammation = TextEditingController();
  TextEditingController reclammation_title = TextEditingController();

  final TextStyle style = TextStyle(
    fontFamily: 'Sacramento',
    fontSize: 18.0,
  );
  @override
  Widget build(BuildContext context) {
    final signupbutton = Container(
        margin: EdgeInsets.only(left: 80.0, right: 80.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.purple,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            onPressed:_isLoading? null: _addChild,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0))),
            child: Text(_isLoading?"en cours ...":"Envoyer",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontFamily: "LuckiestGuy",
                    fontSize: 20)),
          ),
        ));

    final authText = new Text("Réclamation",
        textAlign: TextAlign.center,
        style: style.copyWith(
            fontSize: 30.0,
            color: Color(0xffE6007E),
            
            fontFamily: "LuckiestGuy"));

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Stack(
            
            children: <Widget>[
              Positioned.fill(
                child: new Image.asset(
                  'assets/ac.png',
                  
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(36.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 120.0,
                          height: 120.0,
                          child: Image.asset(
                            "assets/gg.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        authText,
                        SizedBox(
                          height: 50.0,
                          width: 50.0,
                        ),
                        TextField(
          
          
          obscureText: false,
          style: TextStyle(fontSize: 25,fontFamily: "Sacramento",fontWeight: FontWeight.bold),
          controller: reclammation_title,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 15.0),
              hintText: "Titre De La Reclammation",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: Color(0xffE6007E),
                    width: 0.0,
                  ))),
        ),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("Votre Reclammation", reclammation),
                        Container(
                          padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                          child: signupbutton,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height/30,
                          
                        ),
                        
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
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

  void _addChild() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      
      "title":reclammation_title.text,
      'msg':reclammation.text,
      
    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString("csrf_token2");
    //var server = localStorage.getString("serverid");

    //print(sessionId);
    //print(csrfToken);
    //print(csrfToken2);

    var url = "http://10.0.2.2:8000/api/v1/reclamation/";
    var res = await http.post(url,
                              
            body: jsonEncode(data), 
            headers:{'Content-Type':'application/json',
                      "Accept":"application/json",
                      "Cookie": "$sessionId; $csrfToken",
                      "X-CSRFToken":csrfToken2.toString(),
                      
                      
                      });
    var body = json.decode(res.body);
   // print(body);
    //print(res.statusCode);
    if (res.statusCode != 201) {

      _showDialog("Veillez remplir tous les champs");
    }
    else {
      _showDialog("Reclamation Ajoutée Avec Succès");

    }



    

    setState(() {
      _isLoading = false;
    });
  }
}

class CostumInput extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  CostumInput(this.hintText, this.controller);

  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontFamily: 'Sacramento',
      fontSize: 30,
      fontWeight: FontWeight.bold
    );

    return Container(
        color: Colors.transparent,
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: 10,
          obscureText: false,
          style: style,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: hintText,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                    color: Color(0xffE6007E),
                    width: 0.0,
                  ))),
        ));
  }
}

