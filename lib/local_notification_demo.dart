import 'dart:async';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class LocalNotification extends StatefulWidget {
  @override
  _LocalNotificationState createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings("@mipmap/ic_launcher");
    var ios = IOSInitializationSettings();
    var initSetting = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) {
    print("hello");
  }

  void showNotification() async {
    var url = "http://10.0.2.2:8000/api/v1/notification/";
    var res = await http.get(url);
    var body = jsonDecode(res.body);
    //print(body);

    var android = AndroidNotificationDetails(
      "channelId",
      "channelName",
      "channelDescription",
      priority: Priority.High,
    );
    var ios = IOSNotificationDetails();
    var platform = new NotificationDetails(android, ios);
    for (var element in body) {
      flutterLocalNotificationsPlugin.show(
          0, element["titre"], element["corp_de_la_notification"], platform,
          payload: "Send Message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: new Text("show Notification"),
              onPressed: () {
                showNotification();
              },
            )
          ],
        ),
      ),
    );
  }
}
