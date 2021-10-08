import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  String serverUrl = "http://beauty.procreagency.com/api";
  var status;

  var token;
  getServer() {
    return serverUrl;
  }
// , String token, "token": "$token"
  loginData(String email, String password, String token) async {
    print("$email, $password, $token");
    String myUrl = "$serverUrl/login";
    final response = await http.post(myUrl,
        headers: {'Accept': 'application/json'},
        body: {"email": "$email", "password": "$password", "token": "$token"});
        
    var data = json.decode(response.body);
    print(data);
    //print(data["error"]);
    status = data["error"];
    //print(status);
    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["access_token"]}');
      _save(data["access_token"]);
    }
  }

  registerData(String name, String prenom, String telephone, String email,
      String password, String cfpasswor) async {
    String myUrl = "$serverUrl/register";
    final response = await http.post(myUrl, headers: {
      'Accept': 'application/json'
    }, body: {
      "name": "$name",
      "prenom": "$prenom",
      "email": "$email",
      "password": "$password",
      "telephone": "$telephone",
      "password_confirmation": "$cfpasswor"
    });
    status = response.body.contains('error');

    var data = json.decode(response.body);

    if (status) {
      print('data : ${data["error"]}');
    } else {
      print('data : ${data["access_token"]}');
      _save(' ${data["access_token"]}');
    }
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "$serverUrl/user";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });

    //print(response.body);
    return json.decode(response.body);
  }

   addRservation(int id ,int serviceid, DateTime dateTime) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];

    String myUrl = "$serverUrl/addReservation";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    }, body: {
      "client_id": "$id",
      "etat": "En Attente",
      "service_id":"$serviceid",
      "date_res": "$dateTime" 
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }
  addPanier(String nomservice,String description, prix, nbpoints,int categorieid,String image,int serviceid,int clientid, var dateres) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];

    String myUrl = "$serverUrl/addR";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    }, body: {
      "nom_service": "$nomservice",
       "description":"$description",
       "prix":"$prix",
       "nb_points":"$nbpoints",
       "categorie_id":"$categorieid",
       "image":"$image",
       "service_id":"$serviceid",
       "client_id":"$clientid",
       "date_res":"$dateres",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }
removePanier(int clientid, int serviceid) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];

    String myUrl = "$serverUrl/moveR/$clientid/$serviceid";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }
   modifierProfile(int id, String nomUser, String prenom, String telephone, String adresse )async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];

    String myUrl = "$serverUrl/updateclient";
    http.put(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    }, body: {
      "id":"$id",
      "nom_user":"$nomUser",
      "prenom":"$prenom",
      "telephone":"$telephone",
      "adresse":"$adresse",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }




  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }
  //updateclient
 

  /*void deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrl/.../$id";
    http.delete(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
    } ).then((response){
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  


  void editData(int id,String name , String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key ) ?? 0;

    String myUrl = "$serverUrl/.../$id";
    http.put(myUrl,
        headers: {
          'Accept':'application/json',
          'Authorization' : 'Bearer $value'
        },
        body: {
          "name": "$name",
          "price" : "$price"
        }).then((response){
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

*/

}
