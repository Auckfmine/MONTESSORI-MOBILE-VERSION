//import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Profile> {
  File imageFile;
  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    //print("hi");
  }

  Widget input(String label, String placeholder) {
    return Theme(
      data: ThemeData(primaryColor: Colors.white),
      child: SizedBox(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            hintText: placeholder,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 10),

            //enabledBorder: OutlineInputBorder(borderSide:BorderSide(color: Colors.white))  ,
          ),
        ),
        width: 200,
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
              color: Colors.blueGrey[200],
              fontFamily: "Raleway",
              fontSize: 15,
              fontWeight: FontWeight.bold,
            )),
        Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.height / 20),
        ),
        Text(value,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Raleway",
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
    return new Scaffold(
        body: SingleChildScrollView(
          
            child: Stack(children: <Widget>[
               Positioned.fill(
            child: new Image.asset(
              'assets/profile.png',
              
              fit: BoxFit.fill,
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
                    ? Text(
                        'No image selected',
                        style: TextStyle(color: Colors.black),
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

              Text("Foulen Ben Foulen",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Raleway",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 19),
              ),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              text("Name   :", "Rourou"),
              SizedBox(
                height: MediaQuery.of(context).size.height /7,
              )
              
            ],
          ))),
    ])));
    

  }

  
}
