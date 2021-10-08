
import 'package:FirsteProjectFlutter/models/ServiceItem.dart';
import 'package:FirsteProjectFlutter/screens/Services/shop_item_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:FirsteProjectFlutter/models/service.dart';
import '../../app_properties.dart';


class CheckOutPage extends StatefulWidget {
  final ValueSetter<ServiceItem> valueSetter;
  CheckOutPage({this.valueSetter});
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  List<Service> services;
  var info;
  void initState() {
    _affich();
    services=[];
    super.initState();
  }

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "http://beauty.procreagency.com/api/getallservice";
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
    for (int i = 0; i < info.length; i++) {
      Service si = Service(
        info[i]['id'],
        info[i]['nom_service'],
        info[i]['description'],
        info[i]['prix'],
        info[i]['nb_points'],
        info[i]['categorie_id'],
        info[i]['image'],
      );

      setState(() {
       services.add(si);
      });
      //print(promo[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body: 
      services.isEmpty ?Center(child: CircularProgressIndicator())
      :ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 100),
                  child: Center(
                      child: Text('Services',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0))),
                )
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(75.0)),
            ),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Container(
                        height: MediaQuery.of(context).size.height - 180.0,
                        child: ListView(children: [
                          for (int i = 0; i < services.length; i++)
                            _buildFoodItem(services[i])
                        ]))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFoodItem(Service serv) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Expanded(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShopItemList(
                          id: serv.id,
                          nom: serv.nomService,
                          description: serv.description,
                          price: serv.prix,
                          photo: serv.image,
                          categorieid: serv.categorieId,
                          nbpoints: serv.nbPoints)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Row(children: [
                      Hero(
                          tag: serv.image,
                          child: Image(
                              image: NetworkImage(serv.image),
                              fit: BoxFit.cover,
                              height: 75.0,
                              width: 75.0)),
                      SizedBox(width: 10.0),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(serv.nomService,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                            Text('${serv.prix}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15.0,
                                    color: Colors.grey))
                          ])
                    ])),
                    Icon(Icons.add_shopping_cart_sharp),
                  ],
                ))));
  }
}
