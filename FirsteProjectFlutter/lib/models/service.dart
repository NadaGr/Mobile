import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Service{
  int id;
  String nomService;
  String description;
  var prix;	
  var nbPoints;
  int categorieId;
  String image;
  Service(
    this.id,
  this.nomService,
  this.description,
  this.prix,
  this.nbPoints,
  this.categorieId,
  this.image,
  );
  Future<Service> getSrvicebyId (int id) async {
    var info;
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "https://beauty.procreagency.com/api/getServicewithId";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var data = json.decode(response.body);
    print(data);
    if (data != null) {
      
         info = data;
    }
    return info;
  }
  
}