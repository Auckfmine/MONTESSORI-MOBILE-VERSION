import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http ;

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AddChild extends StatefulWidget {
  @override
  _AddChildState createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  bool _isLoading = false;

  TextEditingController student_first_name = TextEditingController();
  TextEditingController student_last_name = TextEditingController();
  TextEditingController student_sexe = TextEditingController();
  TextEditingController student_birthday = TextEditingController();
  TextEditingController father_name = TextEditingController();
  TextEditingController father_profession = TextEditingController();
  TextEditingController father_phone_number = TextEditingController();
  TextEditingController mother_name = TextEditingController();
  TextEditingController mother_profession = TextEditingController();
  TextEditingController mother_phone_number = TextEditingController();
  TextEditingController complete_adress = TextEditingController();
  TextEditingController tlf_fix_number = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController nom_du_pediatre =TextEditingController();
  TextEditingController tlf_pediatre = TextEditingController();
  TextEditingController other_responsible_name = TextEditingController();
  TextEditingController other_responsible_tlf = TextEditingController();
  TextEditingController is_alergetic = TextEditingController();
  TextEditingController auto_medic_buy = TextEditingController();



  final TextStyle style = TextStyle(
    fontFamily: 'Raleway',
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
                    color: Colors.white,fontFamily: "LuckiestGuy",fontSize: 20)),
          ),
        ));

    final authText = new Text("Ajout Enfant",
        textAlign: TextAlign.center,
        style: style.copyWith(
            fontSize: 30.0,
            fontFamily: "LuckiestGuy",
            color: Color(0xffE6007E),
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
                  'assets/ac.png',
                  
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
                          width: 120.0,
                          height: 120.0,
                          child: Image.asset(
                            "assets/logo.png",
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
                        CostumInput("Nom", student_first_name),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("Prénom", student_last_name),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("Sexe", student_sexe),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Nationalité', nationality),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Date De Naissance  (jj/mm/aaaa)', student_birthday),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Nom Du Pére', father_name),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Profession Du Pére', father_profession),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput2('Numéro Du Pére', father_phone_number),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Nom De La Mére', mother_name),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Profession De La Mére', mother_profession),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput2('Numéro De La Mére', mother_phone_number),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Adrésse Compléte', complete_adress),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput2('Numéro Du Télephone-Fixe', tlf_fix_number),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput('Nom Du Pédiatre', nom_du_pediatre),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput2('Télephone Du Pédiatre', tlf_pediatre),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("Nom D'un Autre Responsable", other_responsible_name),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput2("Télephone D'un Autre Responsable", other_responsible_tlf),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("L' enfant est-il allergique ? (Oui/Non)", is_alergetic),
                        SizedBox(
                          height: 10.0,
                          width: 10.0,
                        ),
                        CostumInput("Auto-Achat Des Médicaments  (Oui/Non)", auto_medic_buy),


                        
                        
                        Container(
                          padding: EdgeInsets.only(top: 40.0, bottom: 20.0),
                          child: signupbutton,
                        )
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
            title: new Text('Ajout Enfant'),
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
      'student_first_name':student_first_name.text,
      'student_last_name': student_last_name.text,
      'student_sexe': student_sexe.text,
      'nationality': nationality.text,
      'student_birthday': student_birthday.text,
      'father_name': father_name.text,
      'father_profession': father_profession.text,
      'father_phone_number': father_phone_number.text,
      'mother_name': mother_name.text,
      'mother_profession': mother_profession.text,
      'mother_phone_number': mother_phone_number.text,
      'complete_adress': complete_adress.text,
      'tlf_fix_number': tlf_fix_number.text,
      'user' : user.text,
      'nom_du_pediatre':nom_du_pediatre.text,
      'tlf_pediatre':tlf_pediatre.text,
      'other_responsible_name':other_responsible_name.text,
      'other_responsible_tlf' :other_responsible_tlf.text,
      'is_alergetic':is_alergetic.text,
      'auto_medic_buy':auto_medic_buy.text,


    };
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString("csrf_token2");
    //var server = localStorage.getString("serverid");

    //print(sessionId);
    //print(csrfToken);
    //print(csrfToken2);

    var url = "http://10.0.2.2:8000/api/v1/student/";
    var res = await http.post(url,
                              
            body: jsonEncode(data), 
            headers:{'Content-Type':'application/json',
                      "Accept":"application/json",
                      "Cookie": "$sessionId; $csrfToken",
                      "X-CSRFToken":csrfToken2.toString(),
                      
                      
                      });
    var body = json.decode(res.body);
   // print(body);
   // print(res.statusCode);
    if (res.statusCode != 201) {
        print(body);
      _showDialog("Veuillez Remplir Tous Les Champs");
    }
    else {
      
      _showDialog("Enfant Ajouté Avec Succès");

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
      fontSize: 20.0,
      fontWeight: FontWeight.bold
    );

    return Container(
        color: Colors.transparent,
        child: TextField(
          obscureText: false,
          style: style,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 15.0),
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

class CostumInput2 extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  CostumInput2(this.hintText, this.controller);

  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontFamily: 'Sacramento',
      fontSize: 20.0,
      fontWeight: FontWeight.bold
    );

    return Container(
        color: Colors.transparent,
        child: TextFormField(
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          obscureText: false,
          style: style,
          controller: controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 15.0),
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

