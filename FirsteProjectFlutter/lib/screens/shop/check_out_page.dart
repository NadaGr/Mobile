import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/models/service.dart';
import 'package:FirsteProjectFlutter/screens/address/add_address_page.dart';
import 'package:flutter/material.dart';
import 'components/shop_item_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: must_be_immutable
class CheckOutPage extends StatefulWidget {
  String nomCategorie;
  int idcat;
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
  CheckOutPage({this.nomCategorie, this.idcat});
}

class _CheckOutPageState extends State<CheckOutPage> {
  var id;
  var nom;
  var info;
  List<Service> services;
  void initState() {
    _affich();
    id = widget.idcat;
    nom = widget.nomCategorie;
    services = [];
    super.initState();
  }

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    print("$id");
    String myUrl = "http://beauty.procreagency.com/api/getServiceByCat/$id";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    print(response.body);
    var data = json.decode(response.body);
    print(data);
    if (data != null) {
      setState(() {
        info = data;
        print(info);
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
  //SwiperController swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      body:  services.isEmpty
          ? (Center(child: CircularProgressIndicator()))
          :ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  //height: 48.0,

                  //color: yellow,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        nom,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Text(
                        '${services.length} Services',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontWeight: FontWeight.normal,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
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
                          for (int i = 0; i <services.length; i++)
                            _buildFoodItem(
                              services[i]
                              // info[i]['id'],
                              // photo, //info != null ? info[i]['image'] : '',
                              // info[i]['nom_service'],
                              // info[i]['description'],
                              // info[i]['prix'],
                            )
                        ]))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFoodItem( Service s
      // int id, String imgPath, String name, String description, price
      ) {
    return Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: Expanded(
            child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShopItemList(
                          id: id,
                          nom:s.nomService,
                          description: s.description,
                          price: s.prix,
                          photo: s.image,
                          categorieid: s.categorieId,
                          nbpoints: s.nbPoints)));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Row(children: [
                      Hero(
                          tag: s.image,
                          child: Image(
                              image: NetworkImage(s.image),
                              fit: BoxFit.cover,
                              height: 75.0,
                              width: 75.0)),
                      SizedBox(width: 10.0),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.nomService,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                            Text('${s.prix}',
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
