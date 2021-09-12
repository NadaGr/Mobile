//import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:FirsteProjectFlutter/models/categorie.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:FirsteProjectFlutter/screens/shop/check_out_page.dart';

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Categorie> categories = [];
  var photo =
      "https://kozmatin.com/wp-content/uploads/2021/02/makeup_composition_overhead-732x549-thumbnail.jpg";
  var info;
  //DatabaseHelper databaseHelper = new DatabaseHelper();
  void initState() {
    _affich();
    super.initState();
  }

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "http://192.168.1.22:8000/api/getallcat";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var data = json.decode(response.body);
    //print(data);
    if (data != null) {
      setState(() {
        info = data;
        //print(info);
      });
    }
    for (int i=0; i<info.length; i++){
      Categorie cat=Categorie(
        info[i]['id'],
        info[i]['nom_categorie'],
        info[i]['image'],
      );
       setState(() {
        categories.add(cat);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFAF8),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCFAF8),
        title: Text('Categories',
            style: TextStyle(
                fontFamily: 'Varela',
                color: Color(0xFFD17E50),
                fontSize: 20.0)),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          Container(
              padding: EdgeInsets.only(right: 15.0),
              width: MediaQuery.of(context).size.width - 30.0,
              height: MediaQuery.of(context).size.height - 50.0,
              child: GridView.count(
                crossAxisCount: 2,
                primary: false,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.8,
                children: <Widget>[
                  for (int i = 0; i < categories.length; i++)
                    // _buildCard(
                    //     info != null ? info[i]['nom_categorie'] : '',
                    //     info != null ? info[i]['id'] : '',
                    //     info != null ? info[i]['image']:'',
                    //     false,
                    //     false,
                    //     context)
                  _buildCard(categories[i],false,
                   false,
                   context)

                ],
              )),
          SizedBox(height: 15.0)
        ],
      ),
    );
  }
//Widget _buildCard(String name, int id, String imgPath, bool added,
  Widget _buildCard(Categorie cat, bool added,
      bool isFavorite, context) {
    return Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
        child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      CheckOutPage(nomCategorie: cat.nomCategorie, idcat: cat.id)));
            },
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3.0,
                          blurRadius: 5.0)
                    ],
                    color: Colors.white),
                child: Column(children: [
                  Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            isFavorite
                                ? Icon(Icons.favorite, color: Color(0xFFEF7532))
                                : Icon(Icons.favorite_border,
                                    color: Color(0xFFEF7532))
                          ])),
                  Hero(
                      tag: cat.image,
                      child: Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(cat.image),
                                  fit: BoxFit.contain)))),
                  SizedBox(height: 7.0),
                  Text(cat.nomCategorie,
                      style: TextStyle(
                          color: Color(0xFF575E67),
                          fontFamily: 'Varela',
                          fontSize: 14.0)),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(color: Color(0xFFEBEBEB), height: 1.0)),
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.shopping_basket,
                                color: Color(0xFFD17E50), size: 12.0),
                            Text('View More Services',
                                style: TextStyle(
                                    fontFamily: 'Varela',
                                    color: Color(0xFFD17E50),
                                    fontSize: 12.0))
                          ]))
                ]))));
  }
}
