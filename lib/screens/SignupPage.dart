import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_login_ui/api/api.dart';



class SignupPage extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passWordController = TextEditingController();
  TextEditingController passWordConfirmController = TextEditingController();

  bool _isLoading = false;

  final TextStyle style = TextStyle(
    fontFamily: 'Raleway',
    fontSize: 18.0,
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final username = Container(
        color: Colors.transparent,
        child: TextField(
          obscureText: false,
          style: style,
          controller: userNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Nom de l'utilisateur",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Color(0xffE6007E), width: 0.0))),
        ));

    final signupbutton = Container(
      padding: EdgeInsets.only(top: 25.0),
        margin: EdgeInsets.only(left: 80.0, right: 80.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Color(0xffE6007E),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(15, 15.0, 10.0, 15.0),
            onPressed: _isLoading ? null : _handlelogin,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14.0))),
            child: Text(_isLoading ? 'en cours ...' : "S'inscrire",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontFamily: "LuckiestGuy")),
          ),
        ));

    final textbutton = new FlatButton(
      child: new Text("Vous avez déja un compte ?",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.black,
              fontFamily: "LuckiestGuy",
              fontSize: 20.0)),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(9.0)),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    final authText = new Text("Inscription",
        textAlign: TextAlign.center,
        style: style.copyWith(
            fontSize: 35.0,
            color: Color(0xffE6007E),
            fontFamily: "LuckiestGuy"));

    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: passWordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
          hintText: "Mot De Passe",
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffE6007E)),
              borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordConfirm = TextField(
      obscureText: true,
      style: style,
      controller: passWordConfirmController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 15.0, 10, 15.0),
          hintText: "Confirmer le Mot De Passe",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = Container(
        color: Colors.transparent,
        child: TextField(
          obscureText: false,
          style: style,
          controller: emailController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Adresse E-mail",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(color: Colors.white, width: 0.0))),
        ));

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
            child: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: new Image.asset(
                  'assets/register.png',
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
                          width: 190.0,
                          height: 190.0,
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
                          height: 10.0,
                          width: 10.0,
                        ),
                        username,
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        emailField,
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        passwordField,
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        passwordConfirm,
                        SizedBox(
                          height: 10.0,
                        ),
                        signupbutton,
                        SizedBox(
                          height: 50.0,
                        ),
                        textbutton,
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
            title: new Text("Minino's :"),
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

  void _handlelogin() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'username': userNameController.text,
      'email': emailController.text,
      'password1': passWordController.text,
      'password2': passWordConfirmController.text,
    };
    var res = await CallApi().postData(data, 'accounts/registration/');
    var body = jsonDecode(res.body);
    var status = res.statusCode;

    if (status != 201) {
      
      if (body['password1'] != null ||
          body['password2'] != null ||
          
          body["email"] != null) {
        _showDialog("veillez remplir les champs corréctement");
      }
      if (body["non_field_errors"] != null) {
        _showDialog("veillez verifier les champs entrées");
      }
    } else {
      _showDialog("Compte Creé Avec Succès");
    }

    setState(() {
      _isLoading = false;
    });
  }
}
