import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http ;
import 'package:shared_preferences/shared_preferences.dart';

class Reponse extends StatefulWidget {
  @override
  _ReponseState createState() => _ReponseState();
}

class _ReponseState extends State<Reponse> {
  void _showDialog(msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: new Text('Rendez-Vous'),
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


  Future<List<ClassicRes>> _handleRep()async{

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString("csrf_token");
    var csrfToken_2 = localStorage.getString("csrf_token2");
    var userpk = localStorage.getString("userPk"); 
    //var server = localStorage.getString("serverid");

    var url = "http://10.0.2.2:8000/api/v1/ff";


    var res = await http.get(url,headers: {
      "Content-type":"application/json",
      "Accept":"application/json",
      "Cookie": "$sessionId; $csrfToken",
              "X-CSRFToken": csrfToken_2.toString()
    });
    var body = json.decode(res.body);
    List myResponses = [];

    
      for (var u in body){
        if (u["Rv_user"].toString()==userpk.toString()){
          myResponses.add(u);

        }
      }
      //print(myResponses);
     
      List<ClassicRes> responses = [];

      for (var u in myResponses){

        ClassicRes response = ClassicRes(
          u["id"],
          u["Rv_user"],
          u["Rv_Requested_Date"],
          u['Rv_available_date'],
          u["Rv_admin_comment"],
        );
      responses.add(response);
      //print(responses);
      //print(students.length);
    }
   // print(responses.length);
    return responses;
      
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.purple[100] ,
      appBar: new AppBar(
        backgroundColor: Colors.purple,
        title: new Text("Reponses"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _handleRep(),
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
                      
                      if(snapshot.data[index].Rv_available_date==null){
                        return Container(
                  child: Center(
                    child: Text("En Attend De la réponse de l'administration  ..."),
                  ),
                );
                        

                      }else{return ListTile(
                        
                        title: Text(snapshot.data[index].Rv_admin_comment),
                        subtitle: Text(snapshot.data[index].Rv_available_date),
                        
                        
                      );}
                      
                    },
              );
            }
          },
        ),
      ),
    );
  }
}






class ClassicRes{

  int id ;
  int Rv_user;
  String Rv_Requested_Date;
  String Rv_available_date;
  String Rv_admin_comment;


    ClassicRes(this.id,this.Rv_user,this.Rv_Requested_Date,this.Rv_available_date,this.Rv_admin_comment);
}