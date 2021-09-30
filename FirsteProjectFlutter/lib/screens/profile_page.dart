import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/models/panier.dart';
import 'package:FirsteProjectFlutter/screens/faq_page.dart';
import 'package:FirsteProjectFlutter/screens/payment/payment_page.dart';
import 'package:FirsteProjectFlutter/screens/rating/rating_page.dart';
import 'package:FirsteProjectFlutter/screens/settings/change_password_page.dart';
import 'package:FirsteProjectFlutter/screens/settings/help_page.dart';
import 'package:FirsteProjectFlutter/screens/settings/settings_page.dart';
import 'package:FirsteProjectFlutter/screens/tracking_page.dart';
import 'package:FirsteProjectFlutter/screens/wallet/wallet_page.dart';
import 'package:flutter/material.dart';
import 'package:FirsteProjectFlutter/models/client.dart';
//import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/welcome_back_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Client client;
  var info;
  
  @override
  void initState() {
    _affich();    
     client=null;
    super.initState();
  }

  

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "https://beauty.procreagency.com/api/getClientwithId";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var data = json.decode(response.body);
    print(data);
    if (data != null) {
      setState(() {
        info = data;
      });
    }
    Client cl =Client(
      info[0]['id'],
      info[0]['nom_user'],
      info[0]['prenom'],
      info[0]['telephone'],
      info[0]['adresse'],
      info[0]['user_id'],
      info[0]['photo'],

    );
    setState(() {
          client=cl;
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9F9F9),
      body: 
      Client == null ?Center(child: CircularProgressIndicator())
      :SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 48,
                  backgroundImage: NetworkImage('${client.photo}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${client.nomUser}' + '${client.prenom}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: transparentYellow,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  height: 150,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/wallet.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => WalletPage())),
                            ),
                            Text(
                              'Wallet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Image.asset('assets/icons/contact_us.png'),
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => PaymentPage())),
                            ),
                            Text(
                              'Profil',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                         Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Image.asset('assets/icons/trucking.png'),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => RatingPage()))),
                            Text(
                              'Suivis',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Image.asset('assets/icons/support.png'),
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => HelpPage()))),
                            Text(
                              'Help',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Change Password'),
                  leading: Image.asset('assets/icons/change_pass.png'),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ChangePasswordPage())),
                ),
                ListTile(
                  title: Text('Sign out'),
                  leading: Image.asset('assets/icons/sign_out.png'),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => WelcomeBackPage())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
