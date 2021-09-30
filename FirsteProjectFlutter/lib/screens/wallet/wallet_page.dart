import 'package:FirsteProjectFlutter/api_service.dart';
import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/models/user.dart';
import 'package:FirsteProjectFlutter/screens/payment_history_page.dart';
import 'package:FirsteProjectFlutter/screens/request_money/request_amount_page.dart';
import 'package:FirsteProjectFlutter/screens/request_money/request_page.dart';
import 'package:FirsteProjectFlutter/screens/send_money/send_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with TickerProviderStateMixin {
  AnimationController animController;
  Animation<double> openOptions;
var id;
  var info;
   double sum;
  List<User> users = [];

  getUsers() async {
    var temp = await ApiService.getUsers(nrUsers: 5);
    setState(() {
      users = temp;
    });
  }
var pt;

  @override
  void initState() {
    _affich();
    sum=0;
   // calculer();
    animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    openOptions = Tween(begin: 0.0, end: 300.0).animate(animController);
    getUsers();
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
        info = data;  

      });
    }
    String url = "https://beauty.procreagency.com/api/getPoints/" +'${info[0]['id']}';
    http.Response res = await http.get(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    //print(response.body);
    var d = json.decode(res.body);
   // print(data);
    if (d != null) {
      setState(() {
        pt = d;

      });
    }
    print(pt);
    for(int i =0; i<pt.length; i++)
    {
    setState((){
      sum+=pt[i]['NBPointsF'];
    });
    }
    print(sum);
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: LayoutBuilder(
          builder: (builder, constraints) => SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Align(
                            alignment: Alignment(1, 0),
                            child: SizedBox(
                              height: kTextTabBarHeight,
                              child: IconButton(
                                onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder:(_)=>PaymentHistoryPage())),
                                icon:  SvgPicture.asset('assets/icons/reload_icon.svg', color: Colors.red,),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Points',
                              style: TextStyle(
                                color: darkGrey,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CloseButton()
                          ],
                        ),
                      ),
                      Text('Vos points de fidélité'),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'pt',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text('$sum',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: openOptions.value,
                                height: 80,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(45)),
                                    border:
                                        Border.all(color: yellow, width: 1.5)),
                                child: openOptions.value < 300
                                    ? Container()
                                    : Align(
                                        alignment: Alignment(0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            InkWell(
                                                onTap: () =>
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                SendPage())),
                                                child: Text('Pay')),
                                            InkWell(
                                                onTap: () =>
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                RequestPage())),
                                                child: Text('Request')),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                            Center(
                                child: CustomPaint(
                                    painter: YellowDollarButton(),
                                    child: GestureDetector(
                                      onTap: () {
                                        animController.addListener(() {
                                          setState(() {});
                                        });
                                        if (openOptions.value == 300)
                                          animController.reverse();
                                        else
                                          animController.forward();
                                      },
                                      child: Container(
                                          width: 110,
                                          height: 110,
                                          child: Center(
                                              child: Text('\$',
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          255, 255, 255, 0.5),
                                                      fontSize: 32)))),
                                    )))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            openOptions.value > 0 ? '' : 'Tap to pay / request',
                            style: TextStyle(fontSize: 10)),
                      ),
                     ],
                  ),
                ),
              ),
        ),
      ),
    );
  }
}

class YellowDollarButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;

    canvas.drawCircle(Offset(width / 2, height / 2), height / 2,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.2));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 4,
        Paint()..color = Color.fromRGBO(253, 184, 70, 0.5));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 12,
        Paint()..color = Color.fromRGBO(253, 184, 70, 1));
    canvas.drawCircle(Offset(width / 2, height / 2), height / 2 - 16,
        Paint()..color = Color.fromRGBO(255, 255, 255, 0.1));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
