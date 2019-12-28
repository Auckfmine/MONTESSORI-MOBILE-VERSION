import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Widget note() {
    return Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.purple[700], width: 5)),
        padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/500 ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Notes",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: "LuckiestGuy"),
            ),
            Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/12)),
            Text(
              "Ces notes vous permet de suivre \nl'avancement de votre enfant \nau sein de notre institution",
              style: TextStyle(color: Colors.white),
            )
          ],
        ));
  }

  Widget details() {
    return Center(
      child: Column(
        children: <Widget>[
          text("Attitude en Classe :", 'hhh'),
          text("Note 2 :", 'hhh'),
          text("Note 3 :", 'hhh'),
          text("Note 4 :", 'hhh'),
          text("Note 5 :", 'hhh'),
        ],
      ),
    );
  }

  Widget text(label, value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label,
            style: TextStyle(
              color: Colors.purple[700], //blueGrey[200],
              fontFamily: "LuckiestGuy",
              fontSize: 15,
              
            )),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 50),
        ),
        Image.asset(value,width: 70,
        height: 50,
            
              ),
        Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 14)),
                
      ],
    );
  }

  Future<List<ClassicNotes>> _handleNotes() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionID = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString('csrf_token2');

    var childId = localStorage.getString('studentid');
    //var server = localStorage.getString("serverid");

    var newChildId = childId.substring(1, childId.length - 1);
    var correctchildid = newChildId.split(",");
    var studentName = localStorage.getString("studentFullName");
    var newStudentName = studentName.substring(1, studentName.length - 1);
    var correctStudentName = newStudentName.split(",");
    var studentImage = localStorage.getString("studentImage");
    var newstudentimage = studentImage.substring(1, studentImage.length - 1);
    var correctStudentImage = newstudentimage.split(',');
    List gg2 = [];
    for (var element in correctStudentImage) {
      gg2.add(element.trim());
    }

    String url = "http://10.0.2.2:8000/api/v1/notes/";

    var res = await http.get(url, headers: {
      'Content-Type': 'application/json',
      "Accept": "application/json",
      "Cookie": "$sessionID; $csrfToken",
      "X-CSRFToken": csrfToken2.toString()
    });
    var body = json.decode(res.body);

    //print(body);
    //print(correctchildid);
    //print(correctStudentName);

    List newBody = [];
    //List sectionBody = [];
    List<ClassicNotes> notes = [];
    for (var element in body) {
      for (var i = 0; i < correctchildid.length; i++) {
        if (element["student"].toString() ==
            correctchildid[i].toString().trim()) {
          newBody.add(element);
        }
      }
    }
   // print(newBody);

    List gg = [];

    for (var i = 0; i < newBody.length; i++) {
      ClassicNotes note = ClassicNotes(
          newBody[i]["id"],
          newBody[i]["Attitude_En_Classe"],
          newBody[i]["Respect_Des_Consignes"],
          newBody[i]["Autonomie"],
          newBody[i]["Sociabilite"],
          newBody[i]["Concentration"],
          newBody[i]["Proprete"],
          newBody[i]["title"],
          correctStudentName[i].trim(),
          gg2[i]);

      notes.add(note);
      //print(newBody[i]["title"]);
    }

    //print(notes.length);

    //print(notes);
    return notes;

    //print(userpk);
    //print(body);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Scaffold(
      //backgroundColor: Colors.purple,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
          Color(0xff3e9296),
          Color(0xff45a3a8),
          Color(0xff50b2b7),
          Color(0xff62babe),
          Color(0xff74c2c5),
         /* Colors.pink,
          Colors.pink[600],
          Colors.pink[700],
          Colors.pink[800],*/
        ], begin: Alignment.centerRight, end: Alignment.centerLeft)),
        child: FutureBuilder(
            future: _handleNotes(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Loading..."),
                  ),
                );
              } else {
                return Swiper(
                  pagination: new SwiperPagination(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(children: <Widget>[
                        Positioned(
                          top: MediaQuery.of(context).size.height / 12,
                          left: MediaQuery.of(context).size.width / 6.5,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Colors.purple[700],
                                    shape: BoxShape.circle),
                                child: 
                                CircleAvatar(
                                  backgroundImage:NetworkImage(snapshot.data[index].img,)
                                      
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          17)),
                              Text(snapshot.data[index].student,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "LuckiestGuy",
                                    color: Colors.white,
                                  )),
                            ],
                          ),
                        ),

                        //Positioned(child: Text("Notes : "),top:MediaQuery.of(context).size.height / 3 ,left:MediaQuery.of(context).size.width / 50 ,),
                        Positioned(
                          top: MediaQuery.of(context).size.height/4,
                          left: MediaQuery.of(context).size.width/22,
                          child: note(),
                        ),
                        Positioned(left: MediaQuery.of(context).size.width/10,
                        top: MediaQuery.of(context).size.height/2.3,
                        child: Text("${snapshot.data[index].title.toString()}",style: TextStyle(fontSize: 20,fontFamily: "LuckiestGuy",color: Colors.white),textAlign: TextAlign.left,),),
                          
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2,
                            left: MediaQuery.of(context).size.width / 11,
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  
                                  SizedBox(height: 4,),
                                  text("Attitude en Classe:", snapshot.data[index].note1.toString()=='1'?"assets/+.png":snapshot.data[index].note1.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  text("Respect Des Consignes (discipline):", snapshot.data[index].note2.toString()=='1'?"assets/+.png":snapshot.data[index].note2.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  text("Autonomie:", snapshot.data[index].note3.toString()=='1'?"assets/+.png":snapshot.data[index].note3.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  text("Sociabilité:", snapshot.data[index].note4.toString()=='1'?"assets/+.png":snapshot.data[index].note4.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  text("Concentration:", snapshot.data[index].note5.toString()=='1'?"assets/+.png":snapshot.data[index].note5.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  text("Propreté:", snapshot.data[index].note6.toString()=='1'?"assets/+.png":snapshot.data[index].note6.toString()=='2'?"assets/++.png":"assets/+++.png"),
                                  
                                ],
                              ),
                            ))
                      ]);
                    });
              }
            }),
      ),
    );
  }
}

class ClassicNotes {
  int id;
  String note1;
  String note2;
  String note3;
  String note4;
  String note5;
  String note6;
  String title;
  String student;
  String img;
  

  ClassicNotes(this.id,this.note1, this.note2, this.note3, this.note4,
      this.note5, this.note6,this.title, this.student, this.img);
}
