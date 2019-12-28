import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login_ui/goodbye.dart';
import 'package:flutter_login_ui/screens/Notes.dart';
import 'package:flutter_login_ui/screens/calendar.dart';
import 'package:flutter_login_ui/screens/photo.dart';

import 'package:flutter_login_ui/screens/reclamations.dart';
import 'package:flutter_login_ui/screens/reponseRv.dart';
import 'package:flutter_login_ui/screens/reservation.dart';
import 'package:flutter_login_ui/screens/student.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/api/api.dart';

import 'package:flutter_login_ui/screens/Add-Child.dart';

import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cantine.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  Future selectNotification(String payload) {}

  Future showNotification() async {
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

  Future<List<ClassicHomepage>> _handleHompage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var sessionId = localStorage.getString('session_id');
    var csrfToken = localStorage.getString('csrf_token');
    var csrfToken2 = localStorage.getString("csrf_token2");
    var group = localStorage.getString("section");
    //var server = localStorage.getString("serverid");

    if (group != null) {
      var reformed_group = group.substring(1, group.length - 1);
      List group2 = reformed_group.split(',');

      //print(group2);
      //print(sessionId);
      //print(csrfToken);
      //print(csrfToken2);

      var url = "http://10.0.2.2:8000/api/v1/homepage/";
      var res = await http.get(url, headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        "Cookie": "$sessionId; $csrfToken",
        "X-CSRFToken": csrfToken2.toString(),
      });
      var body = json.decode(res.body);
      List homepage = [];
      //print(body);

      for (var element in body) {
        for (var i = 0; i < group2.length; i++) {
          if (element["group"].toString() == group2[i].trim()) {
            homepage.add(element);
          }
        }
      }
      var optimalHompage = homepage.toSet().toList();
      //print(optimalHompage);

      List<ClassicHomepage> homepages = [];
      for (var u in optimalHompage) {
        ClassicHomepage home = ClassicHomepage(
          u["id"],
          u["theme"],
          u["planning_cantine"],
          u["planning_goute"],
          u["citation"],
          u['Planning'],
          u["message"],
          u["daily_img"],
          u["group"],
          u["Event_title"],
          u["Event_description"],
          u["Event_date"],
          u["Event_img"],
        );
        homepages.add(home);
        //print(homepages);
        //print(homepages);
        //print(students.length);
      }
      //print(homepages);
      return homepages;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        floatingActionButton: Container(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            heroTag: "hello",
            elevation: 60,
            backgroundColor: Colors.purple,
            onPressed: showNotification,
            child: Icon(
              Icons.notifications_active,
              size: 45,
              color: Colors.white,
            ),
          ),
        ),
        
        appBar: AppBar(
          title: Text(
            "Minino's",
            style: TextStyle(fontFamily: "LuckiestGuy"),
          ),
          backgroundColor: Colors.purple,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: <Color>[
                    Colors.deepPurple,
                    Colors.purpleAccent
                  ])),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                            color: Colors.transparent,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            elevation: 30.0,
                            child: Image.asset(
                              'assets/gg.png',
                              width: 120.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            )),
                        Text(
                          "Minino's",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontFamily: 'LuckiestGuy'),
                        )
                      ],
                    ),
                  )),
              CustomListTile(
                  Icons.person,
                  'Mes Enfants',
                  () => {
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Student()),
                        )
                      }),
              CustomListTile(
                  Icons.calendar_today,
                  'Reserver Un Rendez-vous',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Rv()),
                        )
                      }),
              CustomListTile(
                  Icons.add,
                  'Ajouter Enfant',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddChild()),
                        )
                      }),
              CustomListTile(
                  Icons.book,
                  'Notes',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        )
                      }),
              CustomListTile(
                  Icons.question_answer,
                  'Réponses Aux Rv',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Reponse()),
                        )
                      }),
              CustomListTile(
                  Icons.restaurant,
                  'Cantine',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Cantine()),
                        )
                      }),
              CustomListTile(
                  Icons.book,
                  'Reclamation',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Reclammation()),
                        )
                      }),
                      CustomListTile(
                  Icons.photo,
                  'Photos',
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Photo()),
                        )
                      }),
              CustomListTile(Icons.lock, 'Déconnexion', logout)
            ],
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: _handleHompage(),
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
                    return Container(
                        child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(),
                        child: new Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Image.asset(
                                "assets/li.png",
                                fit: BoxFit.cover,
                              ),
                            ),

                            /*color: Colors.purple[300],
                              elevation: 70.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              borderOnForeground: false,*/
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height /
                                                10),
                                  ),
                                  Container(
                                    width: 400,
                                    height: 300,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.purple[700],
                                            width: 6)),
                                    padding: EdgeInsets.only(left: 20, top: 20),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Thème :",
                                          style: TextStyle(
                                              fontFamily: "LuckiestGuy",
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                              color: Colors.pink),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 1),
                                        ),
                                        Container(
                                            child: Center(
                                          child: snapshot.data[index].theme==null?
                                          Text(
                                            "Pas de Théme",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "IndieFlower",
                                                fontSize: 20,
                                                color: Colors.black),
                                          ):
                                          Text(
                                            snapshot.data[index].theme,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "IndieFlower",
                                                fontSize: 40.0,
                                                color: Colors.black),
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 100.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          "Message De L'Administration :  ",
                                          style: TextStyle(
                                            fontFamily: "LuckiestGuy",
                                            fontSize: 30,
                                            color: Colors.pink,
                                          ))),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: snapshot.data[index].message==null? Text(""):
                                      Text(snapshot.data[index].message,
                                          style: TextStyle(
                                            fontFamily: "LuckiestGuy",
                                            fontSize: 20,
                                          ))),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Planning De La Cantine: ",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              color: Colors.purple, width: 5)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen4(snapshot
                                                          .data[index])));
                                        },
                                        child: Hero(
                                          tag: randomString(10),
                                          child: Center(
                                            
                                            child: snapshot.data[index].planning_cantine==null?
                                            Text('Pas De Planning Pour La Cantine'):
                                            Image.network(
                                                snapshot.data[index].planning_cantine),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Planning Du Goûter : ",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              color: Colors.purple, width: 5)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen5(snapshot
                                                          .data[index])));
                                        },
                                        child: Hero(
                                          tag: randomString(10),
                                          child: Center(
                                            
                                            child: snapshot.data[index].planning_goute==null?
                                            Text('Pas De Planning Du Goûter'):
                                            Image.network(
                                                snapshot.data[index].planning_goute),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Citations : ",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              color: Colors.purple, width: 5)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen6(snapshot
                                                          .data[index])));
                                        },
                                        child: Hero(
                                          tag: randomString(10),
                                          child: Center(
                                            
                                            child: snapshot.data[index].citation==null?
                                            Text('Pas De Citations'):
                                            Image.network(
                                                snapshot.data[index].citation),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                  
                                  
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Planning : ",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              color: Colors.purple, width: 5)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen(snapshot
                                                          .data[index])));
                                        },
                                        child: Hero(
                                          tag: randomString(10),
                                          child: Center(
                                            
                                            child: snapshot.data[index].Planning==null?
                                            Text('pas de planning'):
                                            Image.network(
                                                snapshot.data[index].Planning),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Image Du Jour  : ",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /
                                        1.25,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          border: Border.all(
                                              color: Colors.purple, width: 5)),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailScreen3(snapshot
                                                          .data[index])));
                                        },
                                        child: Hero(
                                          tag: randomString(10),
                                          child: Center(
                                            child:snapshot.data[index].daily_img==null? Text("Pas D'image du Jour"):
                                             Image.network(
                                                snapshot.data[index].daily_img),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Evénnement :",
                                        style: TextStyle(
                                          fontFamily: "LuckiestGuy",
                                          fontSize: 30,
                                          color: Colors.pink,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          snapshot.data[index].Event_title==null?
                                          Text("-titre  : Pas d'évènement ",style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),):
                                          Text(
                                            " -Titre  :${snapshot.data[index].Event_title}",
                                            style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          snapshot.data[index].Event_description==null?
                                          Text("- Descripton  :pas D'évènement",style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),):
                                          Text(
                                            " -Description  :${snapshot.data[index].Event_description}",
                                            style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Stack(
                                        children: <Widget>[
                                          snapshot.data[index].Event_date==null?
                                          Text(" -Date  :pas D'évènement",style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),):
                                          Text(
                                            " -Date  :${snapshot.data[index].Event_date}",
                                            style: TextStyle(
                                                fontFamily: "LuckiestGuy",
                                                fontSize: 20.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.25,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                            border: Border.all(
                                                color: Colors.purple, width: 5)),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailScreen2(snapshot
                                                            .data[index])));
                                          },
                                          child: Hero(
                                            tag: randomString(10),
                                            child: Center(
                                              child: snapshot.data[index].Event_img==null?
                                              Text("pas D'image D'évènement",style: TextStyle(
                                                fontFamily: "Raleway",
                                                fontSize: 20.0),):
                                              Image.network(
                                                snapshot.data[index].Event_img,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height /
                                                8),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void logout() async {
    var data = {};

    var res = await CallApi().postData(data, 'accounts/logout/');
    var body = jsonDecode(res.body);
    var status = res.statusCode;
    // print(body);
    //print(status);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('session_id');
    localStorage.remove('csrf_token');
    localStorage.remove('csrf_token2');
    localStorage.remove("section");
    localStorage.remove('studentid');
    localStorage.remove("studentFullName");
    localStorage.remove("userPk");
    //localStorage.remove("serverid");

    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Goodbye()));

    //logout form the server ...
    // clear the user
    // clear the token
  }
}

class CustomListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey.shade400))),
            child: InkWell(
                splashColor: Colors.purpleAccent,
                onTap: onTap,
                child: Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(icon),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(text, style: TextStyle(fontSize: 16.0)),
                          )
                        ],
                      ),
                      Icon(Icons.arrow_right)
                    ],
                  ),
                ))));
  }
}

class ClassicHomepage {
  final int id;
  final String theme;
  final String planning_cantine;
  final String planning_goute;
  final String citation;
  final String Planning;
  final String message;
  final String daily_img;
  final String group;
  final String Event_title;
  final String Event_description;
  final String Event_date;
  final String Event_img;

  ClassicHomepage(
    this.id,
    this.theme,
    this.planning_cantine,
    this.planning_goute,
    this.citation,
    this.Planning,
    this.message,
    this.daily_img,
    this.group,
    this.Event_title,
    this.Event_description,
    this.Event_date,
    this.Event_img,
  );
}

class DetailScreen extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: home.Planning==null?
            Text('Pas de planning pour le Moment'):
            Image.network(
              home.Planning,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DetailScreen2 extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen2(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn1',
            child: home.Event_img==null?
            Text("Pas d'image d'évènement"):
            Image.network(
              home.Event_img,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DetailScreen3 extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen3(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn1',
            child: home.daily_img==null?
            Text("Pas d'image du jour"):
            Image.network(
              home.daily_img,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
class DetailScreen4 extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen4(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: home.planning_cantine==null?
            Text('Pas de planning de la cantine pour le Moment'):
            Image.network(
              home.planning_cantine,
              
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class DetailScreen5 extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen5(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: home.planning_goute==null?
            Text('Pas de planning Du Goûter'):
            Image.network(
              home.planning_goute,
              
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}


class DetailScreen6 extends StatelessWidget {
  final ClassicHomepage home;
  DetailScreen6(this.home);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: home.citation==null?
            Text('Pas De Citations'):
            Image.network(
              home.citation,
              
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
