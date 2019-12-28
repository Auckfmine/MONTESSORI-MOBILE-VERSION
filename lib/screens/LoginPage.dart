import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/api/api.dart';
import 'package:flutter_login_ui/screens/SignupPage.dart';
import 'package:flutter_login_ui/screens/Home.dart';
import 'package:flutter/services.dart';

import 'Home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  bool _isLoading = false;
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: roundedButton(
                    "No", const Color(0xFF800080), const Color(0xFFFFFFFF)),
              ),
              new GestureDetector(
                onTap: () => exit(0),
                child: roundedButton(
                    " Yes ", const Color(0xFF800080), const Color(0xFFFFFFFF)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
    var loginBtn = new Container(
      padding: EdgeInsets.all(5.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: bgColor,
        borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF696969),
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style: new TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ScaffoldState scaffoldState;

  final TextStyle style = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 18.0,
  );
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Size size = MediaQuery.of(context).size;

    final emailField = Container(
        child: TextField(
      style: style,
      controller: userNameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Nom de l'utilisateur",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.purple, width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffffffff), width: 1.5)),
      ),
    ));

    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: passwordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
        hintText: "Mot De Passe",
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Colors.purple, width: 1.5)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide(color: Color(0xffffffff), width: 1.5)),
      ),
    );

    final loginButon = Container(
        margin: EdgeInsets.only(left: 80.0, right: 80.0),
        padding: EdgeInsets.only(top: 18),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xff62BABE),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            onPressed: _isLoading ? null : _login,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0))),
            child: Text(_isLoading ? "en cours ..." : "Connexion",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontFamily: "LuckiestGuy")),
          ),
        ));

    final textbutton = new FlatButton(
      child: new Text("s'inscrire ?",
          textAlign: TextAlign.center,
          style:
              style.copyWith(color: Colors.white, fontFamily: "LuckiestGuy")),
      shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      },
    );

    final authText = new Text("Authentification",
        textAlign: TextAlign.center,
        style: style.copyWith(
            fontSize: 25.0, color: Colors.black, fontFamily: "LuckiestGuy"));

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: new Image.asset(
                  'assets/login.png',
                  width: size.width,
                  height: size.height,
                  fit: BoxFit.fill,
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
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            "assets/gg.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 15,
                        ),
                        authText,
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                        emailField,
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 40,
                        ),
                        passwordField,
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 22,
                        ),
                        loginButon,
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 10),
                          child: new FlatButton(
                            child: new Text("s'inscrire ?",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontFamily: "LuckiestGuy")),
                            shape: BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupPage()),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: MediaQuery.of(context).size.height/13,)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () => {});
  }

  void _showDialog(msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: new Text('Connexion'),
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

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': userNameController.text,
      'password': passwordController.text,
    };

    var res = await CallApi().postData(data, 'accounts/login/');
    var body = json.decode(res.body);
    String header = res.headers['set-cookie'];
    //print(header);
    if (res.statusCode != 200) {
      if (body['password'] != null || body['username'] != null) {
        _showDialog("veuillez remplir les champs");
        setState(() {
          _isLoading = false;
        });
      }
      if (body["non_field_errors"] != null) {
        _showDialog(
            "veuillez verifier le nom d'utilisateur our le mot de passe");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // print(header);//all_header_object

      var list = header.split(";");

      var csrfToken = list[0];
      var sessionId = list[4];
      var sessionId2  = sessionId.split(',');
      var correctsessionid = sessionId2[1];
      
       

/*
      for (var element in list) {
        if (element.contains("sessionid")) {
          var session = element.split(",");
          csrfToken.add(session[1]);
        } else if (element.contains("csrftoken")) {
          
          csrfToken.add(element);
        } else{
          throw(Exception);
        } /*if (element.contains("SERVERID33516")) {
          server.add(element);
        }*/
      }
      */

      var csrfToken_2 = csrfToken.substring(10);
      // print(csrfToken);
      // print(sessionId);
      // print(server);
      //print(csrfToken.substring(10));
      //print(csrfToken);
      //var csrfToken2 = csrfToken[0].split("=");
      //print(csrfToken2);
      //var csrfToken_2 = csrfToken2[0];

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('session_id', correctsessionid);
      localStorage.setString("csrf_token", csrfToken);
      localStorage.setString("csrf_token2", csrfToken_2);
      localStorage.setString("userPk", body["user"]["pk"].toString());
      //localStorage.setString("serverid", server[0].toString());
      var userpk = localStorage.getString("userPk");

      //print(userpk);

      String url2 = "http://10.0.2.2:8000/api/v1/student/";

      var res = await http.get(url2, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Cookie": "${correctsessionid}; ${csrfToken}",
        "X-CSRFToken": csrfToken_2.toString()
      });
      var body2 = json.decode(res.body);
      //print (body2);
      List newBody = [];
      List sectionBody = [];
      List childId = [];
      List childName = [];
      List childImage = [];

      for (var element in body2) {
        if (element["parent"].toString() == userpk) {
          newBody.add(element);
          sectionBody.add(element["section"]);
          childId.add(element["id"]);
          childName.add(element["student_first_name"] +
              "-" +
              element["student_last_name"]);
          childImage.add(element["img"]);
        }
      }

      localStorage.setString("section", sectionBody.toString());
      localStorage.setString("studentid", childId.toString());
      localStorage.setString("studentFullName", childName.toString());
      localStorage.setString("studentImage", childImage.toString());
      Timer(Duration(seconds: 2), () => {logme()});
    }
  }

  void logme() {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
