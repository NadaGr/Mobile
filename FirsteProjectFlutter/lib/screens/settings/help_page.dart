import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/screens/faq_page.dart';
import 'package:FirsteProjectFlutter/screens/product/components/color_list.dart';
import 'package:FirsteProjectFlutter/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  Color active = Colors.red;
  final ScaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection.index == 1) {
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });
  }

  String convertCardNumber(String src, String divider) {
    String newStr = '';
    int step = 4;
    for (int i = 0; i < src.length; i += step) {
      newStr += src.substring(i, math.min(i + step, src.length));
      if (i + step < src.length) newStr += divider;
    }
    return newStr;
  }

  String convertMonthYear(String month, String year) {
    if (month.isNotEmpty)
      return month + '/' + year;
    else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    Widget addThisCard = InkWell(
      // onTap: updateClient(
      //     info[0]['id'],
      //     info[0]['user']['user_id'],
      //     name.text.trim().toLowerCase(),
      //     prenom.text.trim().toLowerCase(),
      //     telephone.text.trim().toLowerCase(),
      //     email.text.trim().toLowerCase(),
      //     adresse.text.trim()),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 3,
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
        child: Center(
          child: Text("Modifier",
              style: const TextStyle(
                  color: const Color(0xfffefefe),
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                  fontSize: 20.0)),
        ),
      ),
    );

    return Scaffold(
      key: ScaffoldKey,
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (_, constraints) => GestureDetector(
          onPanDown: (val) {
//            FocusScope.of(context).requestFocus(FocusNode());
          },
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                margin: const EdgeInsets.only(top: kToolbarHeight),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Help',
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CloseButton()
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(16.0),
                      height: 450,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: shadow,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ListTile(
                            title: Text('Settings'),
                            subtitle: Text('Privacy and logout'),
                            leading: Image.asset(
                              'assets/icons/settings_icon.png',
                              fit: BoxFit.scaleDown,
                              width: 30,
                              height: 30,
                            ),
                            trailing: Icon(Icons.chevron_right, color: yellow),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => SettingsPage())),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('Help & Support'),
                            subtitle: Text('Help center and legal support'),
                            leading: Image.asset('assets/icons/support.png'),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: yellow,
                            ),
                          ),
                          Divider(),
                          ListTile(
                            title: Text('FAQ'),
                            subtitle: Text('Questions and Answer'),
                            leading: Image.asset('assets/icons/faq.png'),
                            trailing: Icon(Icons.chevron_right, color: yellow),
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => FaqPage())),
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
