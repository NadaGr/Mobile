import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:FirsteProjectFlutter/screens/main/main_page.dart';
import '../notifications_page.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class WelcomeBackPage extends StatefulWidget {
  @override
  _WelcomeBackPageState createState() => _WelcomeBackPageState();
}

class _WelcomeBackPageState extends State<WelcomeBackPage> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String msgStatus = '';
  var mytoken;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  
//  _firebaseMessaging.getToken().then((String token) {
//       assert(token != null);
//       setState(() {
//         mytoken = "Push Messaging token: $token";
//       });
//       print(mytoken);
//     });
 @override
  void initState() {
    super.initState();
     _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         NotificationsPage(message : message);
        //_showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //_navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        mytoken =  token;
      });
      print(mytoken);
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget welcomeBack = Text(
      'Login',
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

    Widget subTitle = Padding(
        padding: const EdgeInsets.only(right: 56.0),
        child: Text(
          'Connectez-vous à votre compte',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ));

    Widget loginButton = Positioned(
      left: MediaQuery.of(context).size.width / 4,
      bottom: 40,
      child: InkWell(
        onTap: () {
          if (email.text.trim().toLowerCase().isNotEmpty &&
              password.text.trim().isNotEmpty) {
            databaseHelper
                .loginData(
                    email.text.trim().toLowerCase(), password.text.trim(),mytoken)//,mytoken
                .whenComplete(() {
              if (databaseHelper.status) {
                _showDialog();
                msgStatus = 'Check email or password';
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MainPage()));
              }
            });
          } else {
            if (email.text.trim().toLowerCase().isEmpty ||
                password.text.trim().isEmpty) {
              _showDialog();
            }
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: 50,
          child: Center(
              child: new Text("Connexion",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255,127,80, 1),
                    Color.fromRGBO(255,127,80, 1),
                    Color.fromRGBO(255,127,80, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
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

    Widget loginWithFcbButton = Positioned(
      //right: MediaQuery.of(context).size.width / 8 ,
      //left: MediaQuery.of(context).size.width / 10,
      //bottom: MediaQuery.of(context).size.height /50,
      child: InkWell(
        onTap: () {
          Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MainPage()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 0.5,
          height: 40,
          child: Center(
              child: new Text("f | Login With Facebook",
                  style: const TextStyle(
                      color: const Color(0xfffefefe),
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontSize: 15.0))),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(30,144,255,1),
                    Color.fromRGBO(30,144,255, 1),
                    Color.fromRGBO(30,144,255, 1),
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(255, 0, 0, 0.16),
                  offset: Offset(0, 5),
                  blurRadius: 10.0,
                )
              ],
              borderRadius: BorderRadius.circular(9.0)),
        ),
      ),
    );

    

    Widget loginForm = Container(
      height: 240,
      child: Stack(
        children: <Widget>[
          Container(
            height: 160,
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
                  child: TextField(
                    controller: email,
                    style: TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      icon: new Icon(Icons.email),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextField(
                    controller: password,
                    style: TextStyle(fontSize: 16.0),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: new Icon(Icons.vpn_key),
                    ),
                  ),
                ),
              ],
            ),
          ),
          loginButton,
        ],
      ),
    );

    Widget forgotPassword = Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Forgot your password? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
            },
            child: Text(
              'Reset password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
    Widget register = Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Register? ',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Color.fromRGBO(255, 255, 255, 0.5),
              fontSize: 14.0,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => RegisterPage()));
            },
            child: Text(
              'Inscription',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
              children: <Widget>[
                
                Spacer(flex: 1),
                register,
                Spacer(flex: 2),
                welcomeBack,
                Spacer(flex: 3,),
                subTitle,
                Spacer(flex: 4),
                loginForm,
               // loginWithFcbButton,
                Spacer(flex: 5),
                forgotPassword
              ],
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
            content: new Text('Check your email or password'),
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
