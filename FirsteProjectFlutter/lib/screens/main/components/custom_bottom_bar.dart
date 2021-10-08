import 'package:FirsteProjectFlutter/models/panier.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomBottomBar extends StatefulWidget {
  final TabController controller;
  

  const CustomBottomBar({Key key, this.controller}) : super(key: key);
   @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}
class _CustomBottomBarState extends State<CustomBottomBar> {
  var length;
  var info;
  var i;
  List<Panier> panier; 
   @override
  void initState() {
    _affich();
    panier = [];
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
    //print(data);
    if (data != null) {
      setState(() {
        i = data;
      });
    }
    _panier(i[0]['id']);
    // print("${i[0]['id']}");
  }

  void _panier(id) async {
    print("$id");
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String url = "http://beauty.procreagency.com/api/indexR/$id";
    http.Response response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var d = json.decode(response.body);
    print(d);
    if (d != null) {
      setState(() {
        info = d;
      });
    }
    print(info);
    for (int i = 0; i < info.length; i++) {
      Panier p = Panier(
        info[i]['id'],
        info[i]['nom_service'],
        info[i]['description'],
        info[i]['prix'],
        info[i]['nb_points'],
        info[i]['categorie_id'],
        info[i]['image'],
        info[i]['service_id'],
        info[i]['client_id'],
        info[i]['date_res'],
      );

      setState(() {
        panier.add(p);
        length = panier.length;
      });
      //print(promo[i]);
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
                    'assets/icons/home_icon.svg',
                    fit: BoxFit.fitWidth,
                    ),
            onPressed: () {
              widget.controller.animateTo(0);
            },
          ),
          IconButton(
            icon: Image.asset('assets/icons/category_icon.png'),
            onPressed: () {
              widget.controller.animateTo(1);
            },
          ),
          panier.isEmpty ?
          
          IconButton(
            icon: SvgPicture.asset('assets/icons/cart_icon.svg'),
            onPressed: () {
              widget.controller.animateTo(2);
            },
          )
      :
          Badge(
            padding: EdgeInsets.all(8),
                  toAnimate: false,
                  badgeColor: Colors.red,
                  shape: BadgeShape.square,
                  position: BadgePosition.topEnd(
                    top: -8,end: -4
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                   badgeContent: Text(
                    '$length',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            child:
          IconButton(
            icon: SvgPicture.asset('assets/icons/cart_icon.svg'),
            onPressed: () {
              widget.controller.animateTo(2);
            },
          )),
          IconButton(
            icon: Image.asset('assets/icons/profile_icon.png'),
            onPressed: () {
              widget.controller.animateTo(3);
            },
          )
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
