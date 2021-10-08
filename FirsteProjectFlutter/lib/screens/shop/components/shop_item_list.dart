import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class ShopItemList extends StatefulWidget {
  final int id,categorieid;
  final price, nbpoints;
  final photo;
  final String nom, description;

  ShopItemList({this.id, this.nom, this.description, this.price, this.photo, this.categorieid, this.nbpoints});

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  var selectedCard = 'WEIGHT';
  var info;
  DateTime dateTime;
  DatabaseHelper databaseHelper = new DatabaseHelper();
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
    String myUrl = "http://beauty.procreagency.com/api/getClientwithId";
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: yellow,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Details',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 18.0,
                  color: Colors.white)),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: 
        ListView
        (
          children: [
          Stack(
            children: [
            Container(
                height: MediaQuery.of(context).size.height - 82.0,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent),
            Positioned(
                top: 75.0,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(45.0),
                          topRight: Radius.circular(45.0),
                        ),
                        color: Colors.white),
                    height: MediaQuery.of(context).size.height - 100.0,
                    width: MediaQuery.of(context).size.width)),
            Positioned(
                top: 30.0,
                left: (MediaQuery.of(context).size.width / 2) - 100.0,
                child: Hero(
                    tag: widget.photo,
                    child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.photo),
                                fit: BoxFit.cover)),
                        height: 200.0,
                        width: 200.0))),
            Positioned(
                top: 250.0,
                left: 25.0,
                right: 25.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.nom,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('${widget.price}',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                color: Colors.grey)),
                        Container(height: 25.0, color: Colors.grey, width: 1.0),
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17.0),
                             // color: yellow
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[InkWell(
                                onTap: () {
                                  print(widget.id);
                                  showDatePicker
                                (
                                  context: context,
                                 initialDate: DateTime.now(),
                                  firstDate: DateTime(2001),
                                   lastDate: DateTime(2222)
                                   ).then((date) {
                                     setState(() {
                                      dateTime = date;
                                  databaseHelper.addPanier( widget.nom, widget.description, widget.price, widget.nbpoints, widget.categorieid, widget.photo, widget.id, info[0]["id"],dateTime);
                               
                                     });
                                   }); },
                                child: Container(
                                  height: 45.0,
                                  width: 45.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.0),
                                      color: Colors.white),
                                  child: Center(
                                    child: Icon(
                                      Icons.add_shopping_cart_sharp,
                                      //color: Color(0xFF7A9BEE),
                                      size: 35.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                            color: yellow),
                        height: 100.0,
                        child: Center(
                          child: Text(widget.description,
                              style: TextStyle(                                                              
                                  color: Colors.white,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    )
                  ],
                ))
          ])
        ]));
  }
}
