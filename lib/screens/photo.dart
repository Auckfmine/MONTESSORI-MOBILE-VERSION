import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login_ui/screens/student.dart';
import 'package:random_string/random_string.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  bool _isLoading = false;
  Future<List<ClassicStudent>> _handlePhoto() async {
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
        u["auto_medic_buy"],
        u['photo_1'],
        u['photo_2'],
        u['photo_3'],
        u['photo_4'],
        u['photo_5'],
        u['photo_6'],
      );

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
        title: new Text("Photos"),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.purple[100], border: Border.all(color: Colors.black)),
        child: FutureBuilder(
          future: _handlePhoto(),
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
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data[index].img)),
                      ),
                      title: Text(
                        snapshot.data[index].student_first_name,
                        style: TextStyle(
                          fontFamily: "LuckiestGuy",
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data[index].student_last_name,
                        style: TextStyle(fontFamily: "LuckiestGuy"),
                      ),
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
    );
  }
}

class Detail extends StatefulWidget {
  final ClassicStudent student;
  Detail(this.student);
  @override
  _DetailState createState() => _DetailState(student);
}

class _DetailState extends State<Detail> {
  final ClassicStudent student;
  _DetailState(this.student);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[300],
          title: Text(student.student_first_name),
        ),
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          /*Positioned.fill(
            child: new Image.asset(
              'assets/pf.png',
              
              fit: BoxFit.cover,
            ),
          ),*/

          Container(
              color: Colors.transparent,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 19),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => DetailScreen(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_1 == null
                                ? Text("Pas D'image du Jour")
                                : Image.network(student.photo_1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen2(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_2 == null
                                ? Text("Pas D'image du Jour")
                                : Image.network(student.photo_2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen3(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_3 == null
                                ? Text("")
                                : Image.network(student.photo_3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen4(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_4 == null
                                ? Text("Pas D'image du Jour")
                                : Image.network(student.photo_4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen5(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_5 == null
                                ? Text("Pas D'image du Jour")
                                : Image.network(student.photo_5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          border: Border.all(color: Colors.purple, width: 5)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      DetailScreen6(student)));
                        },
                        child: Hero(
                          tag: randomString(10),
                          child: Center(
                            child: student.photo_6 == null
                                ? Text("Pas D'image du Jour")
                                : Image.network(student.photo_6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ))),
        ])));
  }
}

class DetailScreen extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: photo.photo_1 == null
                ? Text('Pas de planning pour le Moment')
                : PhotoView(
                    imageProvider: NetworkImage(
                      photo.photo_1,
                    ),
                  ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class DetailScreen2 extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen2(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: photo.photo_2 == null
                ? Text('Pas de planning pour le Moment')
                : PhotoView(
                    imageProvider: NetworkImage(
                      photo.photo_2,
                    ),
                  ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class DetailScreen3 extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen3(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'btn2',
              child: photo.photo_3 == null
                  ? Text('Pas de planning pour le Moment')
                  : PhotoView(
                      imageProvider: NetworkImage(
                        photo.photo_3,
                      ),
                    )),
        ),
        onTap: () {},
      ),
    );
  }
}

class DetailScreen4 extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen4(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: photo.photo_4 == null
                ? Text('Pas de planning pour le Moment')
                : PhotoView(
                    imageProvider: NetworkImage(
                      photo.photo_4,
                    ),
                  ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class DetailScreen5 extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen5(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: photo.photo_5 == null
                ? Text('Pas de planning pour le Moment')
                : PhotoView(
                    imageProvider: NetworkImage(
                      photo.photo_5,
                    ),
                  ),
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class DetailScreen6 extends StatelessWidget {
  final ClassicStudent photo;
  DetailScreen6(this.photo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'btn2',
            child: photo.photo_6 == null
                ? Text('Pas de planning pour le Moment')
                : PhotoView(
                    imageProvider: NetworkImage(
                      photo.photo_3,
                    ),
                  ),
          ),
        ),
        onTap: () {},
      ),
    );
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
  final String other_responsible_name;
  final String other_responsible_tlf;
  final String is_alergetic;
  final String auto_medic_buy;
  final String photo_1;
  final String photo_2;
  final String photo_3;
  final String photo_4;
  final String photo_5;
  final String photo_6;

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
      this.tlf_pediatre,
      this.other_responsible_name,
      this.other_responsible_tlf,
      this.is_alergetic,
      this.auto_medic_buy,
      this.photo_1,
      this.photo_2,
      this.photo_3,
      this.photo_4,
      this.photo_5,
      this.photo_6);
}
