import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:FirsteProjectFlutter/screens/main/main_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}
 
class _RegisterPageState extends State<RegisterPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';
  TextEditingController name = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cmfPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      'Inscription',
      style: TextStyle(
          color: Colors.white,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
          shadows: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ]),
    );

    Widget registerButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: MediaQuery.of(context).size.height / 150,
      child: InkWell(
        onTap: () {
          if (name.text.trim().toLowerCase().isNotEmpty &&
              prenom.text.trim().toLowerCase().isNotEmpty &&
              telephone.text.trim().toLowerCase().isNotEmpty &&
              email.text.trim().toLowerCase().isNotEmpty &&
              password.text.trim().isNotEmpty &&
              cmfPassword.text.trim().isNotEmpty) {
            databaseHelper
                .registerData(
                    name.text.trim().toLowerCase(),
                    prenom.text.trim().toLowerCase(),
                    telephone.text.trim().toLowerCase(),
                    email.text.trim().toLowerCase(),
                    password.text.trim(),
                    cmfPassword.text.trim())
                .whenComplete(() {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => MainPage()));
            });
          } else {
            if (name.text.trim().toLowerCase().isEmpty ||
                prenom.text.trim().toLowerCase().isEmpty ||
                telephone.text.trim().toLowerCase().isEmpty ||
                email.text.trim().toLowerCase().isEmpty ||
                password.text.trim().isEmpty ||
                cmfPassword.text.trim().isEmpty) {
              _showDialog();
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 50,
          child: Center(
              child: new Text("Registre",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: mainButton,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    Widget registerForm = Container(
      height: 420,
      child: Stack(
        children: <Widget>[
          Container(
            height: 600,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 32.0, right: 12.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: name,
                    style: TextStyle(fontSize: 13.5),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                    controller: prenom,
                    style: TextStyle(fontSize: 13.5),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Prenom',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                    controller: telephone,
                    style: TextStyle(fontSize: 13.5),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Telephone',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                    controller: email,
                    style: TextStyle(fontSize: 13.5),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                    controller: password,
                    style: TextStyle(fontSize: 13.5),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: TextField(
                    controller: cmfPassword,
                    style: TextStyle(fontSize: 13.5),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Confirmer Password',
                    ),
                  ),
                ),
              ],
            ),
          ),
          registerButton,
        ],
      ),
    );

    Widget socialRegister = Column(
      children: <Widget>[
        Text(
          'You can sign in with',
          style: TextStyle(
              fontSize: 12.0, fontStyle: FontStyle.italic, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.find_replace),
              onPressed: () {},
              color: Colors.white,
            ),
            IconButton(
                icon: Icon(Icons.find_replace),
                onPressed: () {},
                color: Colors.white),
          ],
        )
      ],
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background1.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            decoration: BoxDecoration(
              color: transparentYellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Spacer(flex: 5),
                title,
                Spacer(),
                registerForm,
                Spacer(flex: 2),
                Padding(
                    padding: EdgeInsets.only(bottom: 5), child: socialRegister)
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 2,
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('Remplissez tous les champs'),
            actions: <Widget>[
              new RaisedButton(
                child: new Text(
                  'Close',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
