import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student extends StatefulWidget {
  @override
  _StudentState createState() => _StudentState();
}

class _StudentState extends State<Student> {
  bool _isLoading = false;
  Future<List<ClassicStudent>> _handleStudent() async {
    
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionID = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString('csrf_token2');
    var userpk = localStorage.getString('userPk');
    //var serverid = localStorage.getString("serverid");

    String url = "http://10.0.2.2:8000/api/v1/student/";

    var res = await http.get(url, headers: {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Cookie": "$sessionID; $csrfToken",
      "X-CSRFToken": "$csrfToken2"
    });
    var body = json.decode(res.body);
    
    

    
    List newBody = [];
    //List sectionBody = [];
    List<ClassicStudent> students = [];
    for (var element in body) {
      if (element["parent"].toString() == userpk) {
        // print(element);
        newBody.add(element);
        //print(userpk);
        //print(element["parent"]);
        //sectionBody.add(element["section"]);
      }
      
    }
   // print(newBody);
    //print(sectionBody);
    //localStorage.setString('section', sectionBody.toString());
    //var section = localStorage.getString("section");
    //print(sectionBody);
    //print(section);
    //print(newBody);

    for (var u in newBody) {
      ClassicStudent student = ClassicStudent(
          u["id"],
          u["parent"],
          u['student_first_name'],
          u["student_last_name"],
          u["student_sexe"],
          u["nationality"],
          u["student_birthday"],
          u["father_name"],
          u["father_profession"],
          u["father_phone_number"],
          u["mother_name"],
          u["mother_profession"],
          u["mother_phone_number"],
          u["complete_adress"],
          u["tlf_fix_number"],
          u["img"],
          u["nom_du_pediatre"],
          u["tlf_pediatre"],
          u["other_responsible_name"],
          u["other_responsible_tlf"],
          u["is_alergetic"],
          u["auto_medic_buy"]);
           
      students.add(student);
      
      //print(students.length);
    }
    //print(students);
    return students;
    //print(students);
    //print(userpk);
    //print(body);
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.purple[400],
        title: new Text("Mes Enfants"),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          border: Border.all(color: Colors.black)
        ),
        
        child: FutureBuilder(
          future: _handleStudent(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Container(width: 60,
                      height: 60,
                                              child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              
                                snapshot.data[index].img)),
                      ),
                      title: Text(snapshot.data[index].student_first_name,style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,),),
                      subtitle: Text(snapshot.data[index].student_last_name,style: TextStyle(fontFamily: "LuckiestGuy"),),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    Detail(snapshot.data[index])));
                      },
                    );
                  });
            }
          },
        ),
      ),
      
    )
    
    ;
    
  }
}


class Detail extends StatefulWidget {
  final ClassicStudent student;
  Detail(this.student);
  @override
  _DetailState createState() => _DetailState(student);
}

class _DetailState extends State<Detail> {
  final ClassicStudent student ;
  _DetailState(this.student);

  File imageFile;
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      patchStudent();
    });
    //print("hi");
  }

  void patchStudent()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionID = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString('csrf_token2');
    //var server = localStorage.getString("serverid");
    
    var id = student.id ;
    String dd = base64Encode(imageFile.readAsBytesSync());
    var data = {
      "img":dd
    };
    var url = "http://10.0.2.2:8000/api/v1/student/$id/";
    var res = await http.patch(url,body:json.encode(data),headers: {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Cookie": "$sessionID; $csrfToken",
      "X-CSRFToken": csrfToken2.toString()
    });
    var body = json.decode(res.body);

    //print("hello");

    //print(body);


  }

  

  Widget text(label, value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label,
            style: TextStyle(
              color: Colors.blueGrey[200],
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 20),
        ),
        Text(value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 19))
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text(student.student_first_name),
      ),
      body:SingleChildScrollView(
          
            child: Stack(children: <Widget>[
               Positioned.fill(
            child: new Image.asset(
              'assets/pf.png',
              
              fit: BoxFit.cover,
            ),
          ),
      
      Container(
          color: Colors.transparent,
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 14.5),
              ),
              Container(
                child: imageFile == null
                    ? Center(
                        child: Container(
                                                  child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 68.0,
                              backgroundImage: NetworkImage(student.img)),
                              padding: EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(color: Colors.yellow[700],shape: BoxShape.circle),
                        ),
                      )
                    : Center(
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 68.0,
                            backgroundImage: FileImage(imageFile)),
                      ),
              ),
              
              Container(
                width: 65,
                child: RaisedButton(
                    color: Colors.blueGrey[50],
                    onPressed: () {
                      _openGallery(context);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(child: Icon(Icons.add_a_photo))),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 19),
              ),

              Text(student.student_first_name+"  "+student.student_last_name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "LuckiestGuy",
                    fontSize: 30,
                    
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 15),
              ),
              text("Nationalité:",student.nationality),
              text("sexe:",student.student_sexe),
              /*
              Text("Nationalité :",style: TextStyle(
              color: Colors.blueGrey[200],
              fontFamily: "LuckiestGuy",
              fontSize: 20,)),
              SizedBox(height: 15,),
              Text(student.nationality,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              fontWeight: FontWeight.bold
            )),
              SizedBox(height: 25,),
              Text("Sexe :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200]),),
              SizedBox(height: 15,),
              Text(student.student_sexe,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/
              SizedBox(height: 25,),
              Text("Date De Naissance: ",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.student_birthday,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),
              SizedBox(height: 25,),
              Text("Nom Du Père  :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.father_name,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),/*
              SizedBox(height: 15,),
              Text("Numéro Du Père  :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.father_phone_number,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),
              SizedBox(height: 15,),
              Text("Profession Du Père :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.father_profession,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/
              SizedBox(height: 25,),
              Text("Nom De La Mère :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.mother_name,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),/*
              SizedBox(height: 15,),
              Text("Numéro De La Mère :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.mother_phone_number,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),
              SizedBox(height: 15,),
              Text("Profession De La Mère :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.mother_profession,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/
              SizedBox(height: 25,),
              Text("Addresse :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.complete_adress,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),
              SizedBox(height: 25,),
              Text("Numéro Du Téléphone Fix :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.tlf_fix_number,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),
              SizedBox(height: 25,),
              Text("Pédiatre :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.nom_du_pediatre+" :   "+student.tlf_pediatre,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),/*
              SizedBox(height: 15,),
              Text("Téléphone Du Pédiatre:",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.tlf_pediatre,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/
              SizedBox(height: 25,),
              Text("Autres Résponsables:",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.other_responsible_name+" : "+student.other_responsible_tlf,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),/*
              SizedBox(height: 15,),
              Text("Numéro De L'Autre Résponsable:",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.other_responsible_tlf,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/
              SizedBox(height: 25,),
              Text("Allergies ? :",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.is_alergetic,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 20,
              
            )),/*
              SizedBox(height: 15,),
              Text("Auto-Achat Médicaments:",style: TextStyle(fontFamily: "LuckiestGuy",fontSize: 20,color:Colors.blueGrey[200])),
              SizedBox(height: 15,),
              Text(student.auto_medic_buy,style: TextStyle(
              color: Colors.white,
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),*/

            /*
              text("Sexe   :", student.student_sexe),
              text("Date De Naissance :", student.student_birthday),
              text(" Nationalité :", student.nationality),
              text("Nom Du Père :", student.father_name),
              text("Numéro Du Père :", student.father_phone_number),
              text("Profession Du Père :", student.father_name),
              text("Nom De La Mère :", student.mother_name),
              text("Numéro De La Mère :", student.mother_phone_number),
              text(" Addresse :", student.complete_adress),
              text(" Numéro Du Téléphone Fix :", student.tlf_fix_number),
              */
              SizedBox(
                height: MediaQuery.of(context).size.height /5,
              )
              
            ],
          ))),
    ])));
      
      
      
    
  }
}



class ClassicStudent {
  final int id;
  final int parent;
  final String student_first_name;
  final String student_last_name;
  final String student_sexe;
  final String nationality;
  final String student_birthday;
  final String father_name;
  final String father_profession;
  final String father_phone_number;
  final String mother_name;
  final String mother_profession;
  final String mother_phone_number;
  final String complete_adress;
  final String tlf_fix_number;
  final String img;
  final String nom_du_pediatre;
  final String tlf_pediatre;
  final String  other_responsible_name;
  final String other_responsible_tlf;
  final String  is_alergetic;
  final String  auto_medic_buy;

  ClassicStudent(
      this.id,
      this.parent,
      this.student_first_name,
      this.student_last_name,
      this.student_sexe,
      this.nationality,
      this.student_birthday,
      this.father_name,
      this.father_profession,
      this.father_phone_number,
      this.mother_name,
      this.mother_profession,
      this.mother_phone_number,
      this.complete_adress,
      this.tlf_fix_number,
      this.img,
      this.nom_du_pediatre,
      this.tlf_pediatre,this.other_responsible_name,
      this.other_responsible_tlf,this.is_alergetic,this.auto_medic_buy);
}
