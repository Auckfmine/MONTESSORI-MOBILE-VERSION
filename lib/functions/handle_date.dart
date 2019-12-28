import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void handleCantine() async {
  var url = "http://10.0.2.2:8000/api/v1/date";
  var res = await http.get(url, headers: {
    "Content-type": "application/json",
    "Accept": "application/json",
  });

  var body = json.decode(res.body);

  //print(body[0]["date"]);
  //print(body);
  var newBody = [];
  
  for (var i in body) {
    newBody.add(i["date"]);
    
  }
  //print(newBody);

  var step_1 = newBody.toString();
  var step_2 = step_1.substring(1, step_1.length - 1);

  //print(step_2);
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  localStorage.setString("date", step_2);


  
}
