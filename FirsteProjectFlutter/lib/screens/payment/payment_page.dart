import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/screens/product/components/color_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Color active = Colors.red;
  DatabaseHelper databaseHelper= new DatabaseHelper();
  final ScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController prenom = TextEditingController();
  TextEditingController telephone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController adresse = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool _nameValide = true;
  bool _prenomvalid = true;
  bool _telephoneValid = true;
  bool _emailValid = true;
  bool _adresseValid = true;
  var info;

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "http://192.168.1.22:8000/api/getClientwithId";
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
  }

  // updateClient(int id,int user_id, String name, String prenom, String telephone,
  //     String email, String adresse) async {
  //    final prefs = await SharedPreferences.getInstance();
  //   final key = 'token';
  //   final value = prefs.getString(key) ?? 0;
  //   var v = value.toString().split("|");
  //   var string = v[1];
  //   String myUrl = "http://192.168.1.22:8000/api/updateclient";
  //   final response = await http.put(myUrl, headers: {
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $string'
  //   }, body: {
  //     "id": "$id",
  //     "user_id":"$user_id",
  //     "name": "$name",
  //     "prenom": "$prenom",
  //     "email": "$email",
  //     "telephone": "$telephone",
  //     "adresse": "$adresse"
  //   }).then((response) {
  //     print('Response status : ${response.statusCode}');
  //     print('Response body : ${response.body}');
  //   });}

  @override
  void initState() {
    _affich();
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
    Widget addThisCard = 
    InkWell(
      onTap:() {
        databaseHelper.modifierProfile(
          info[0]['id'],
          name.text.trim().toLowerCase(),
          prenom.text.trim().toLowerCase(), 
          telephone.text.trim().toLowerCase(),
          adresse.text.trim().toLowerCase()
          ).whenComplete(() {
            _showDialog();
          });
          }
        ,
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
                          'Profil',
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 48,
                                backgroundImage:
                                    NetworkImage('${info[0]['photo']}'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 60.0),
                                child: IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () {}),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16)
                              ],
                              controller: name,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${info[0]['nom_user']}'),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16)
                              ],
                              controller: prenom,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${info[0]['prenom']}'),
                            ),
                          ),
                         
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16)
                              ],
                              controller: telephone,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  //alignLabelWithHint: true,
                                  hintText: '${info[0]['telephone']}'),
                            ),
                            ),
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.grey[200],
                            ),
                            child: TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16)
                              ],
                              controller: adresse,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '${info[0]['adresse']}'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Center(
                        child: Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: addThisCard,
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Success'),
            content: new Text('Success'),
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
