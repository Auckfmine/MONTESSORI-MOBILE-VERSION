import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_login_ui/functions/handle_date.dart';
import 'package:http/http.dart' as http;

void test_date(date, event) async {
  var date2 = date.toString().substring(0, 10);
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
  var userPk = localStorage.getString("userPk");

  String url = "http://10.0.2.2:8000/api/v1/date";

  var res = await http.get(url, headers: {
    'Content-Type': 'application/json',
    "Accept": "application/json",
    "Cookie": "$sessionID; $csrfToken",
    "X-CSRFToken": csrfToken2.toString()
  });
  var body = json.decode(res.body);
print(body);
  //print(body);
  //print(correctchildid);
  //print(correctStudentName);

  List newBody = [];
  
  //List sectionBody = [];

  for (var element in body) {
    if (userPk.trim() == element["father"].toString().trim()) {
      
      
      for (var i = 0; i < correctchildid.length; i++) {
        if (element["child"].toString().trim() ==
            correctchildid[i].toString().trim()) {
              
          if (date2.toString().trim() == element["date"].toString().trim()){
            newBody.add(element);
           
          }
          
        }
      }
    }
  }
  print(newBody);
}
