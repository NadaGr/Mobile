import 'package:FirsteProjectFlutter/Controllers/databaseheper.dart';
import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/models/panier.dart';
import 'package:FirsteProjectFlutter/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class TrackingPage extends StatefulWidget {
  TrackingPage();

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  var info;
  var i;
  List<Panier> panier;
  List<Reservation> reservations;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  void initState() {
    _affich();
    // _panier(id);
    panier = [];
    super.initState();
  }

  var length;
  Future _affich() async {
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
    //print(data);
    if (data != null) {
      setState(() {
        i = data;
      });
    }
    String url = "http://beauty.procreagency.com/api/indexR/${i[0]['id']}";
    http.Response res = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var d = json.decode(res.body);
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
      
    }
  }

   @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: yellow,
        title: Text(
          'Historique des Réservations',
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
      body: panier.isEmpty
          ? (Center(child: CircularProgressIndicator()))
          : Column(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: ListView.builder(
                        itemCount: panier.length,
                        itemBuilder: (ctx, i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0))),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        '${panier[i].image}',
                                      ),
                                      maxRadius: 40,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          padding: EdgeInsets.only(left: 15.0),
                                          width: 40.0,
                                          child: Row(children: [
                                            Column(
                                                // crossAxisAlignment:
                                                //     CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${panier[i].nomService}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Text('\$${panier[i].prix}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: 15.0,
                                                          color: Colors.grey))
                                                ]),
                                          ])),
                                    ),
                                    //SizedBox(width: 30.0),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                          padding: EdgeInsets.only(left: 30.0),
                                          //width: 50.0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.check_circle,
                                                        size: 30,
                                                        color: Colors.blue[700],
                                                      ),
                                                      onPressed: () {
                                                        databaseHelper
                                                            .addRservation(
                                                                panier[i]
                                                                    .clientId,
                                                                panier[i]
                                                                    .serviceId,
                                                                panier[i]
                                                                    .dateTime);
                                                      }),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.cancel,
                                                        size: 30,
                                                        color:
                                                            Color(0xffF94D4D),
                                                      ),
                                                      onPressed: () {
                                                        print(
                                                            " ${panier[i].clientId}, ${panier[i].serviceId}");
                                                        databaseHelper
                                                            .removePanier(
                                                                panier[i]
                                                                    .clientId,
                                                                panier[i]
                                                                    .serviceId);
                                                      })
                                                ],
                                              ),
                                            ],
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        })),
              ],
            ),
    );
  }
}

class RefreshWidget extends StatefulWidget {
  final GlobalKey<RefreshIndicatorState> keyRefresh;
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({
    Key key,
    this.keyRefresh,
    @required this.onRefresh,
    @required this.child,
  }) : super(key: key);

  @override
  _RefreshWidgetState createState() => _RefreshWidgetState();
}

class _RefreshWidgetState extends State<RefreshWidget> {
  @override
  Widget build(BuildContext context) =>
      Platform.isAndroid ? buildAndroidList() : buildIOSList();

  Widget buildAndroidList() => RefreshIndicator(
        key: widget.keyRefresh,
        onRefresh: widget.onRefresh,
        child: widget.child,
      );

  Widget buildIOSList() => CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverRefreshControl(onRefresh: widget.onRefresh),
          SliverToBoxAdapter(child: widget.child),
        ],
      );
}
