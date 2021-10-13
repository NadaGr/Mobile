
import 'dart:io';

import 'package:FirsteProjectFlutter/app_properties.dart';
import 'package:FirsteProjectFlutter/custom_background.dart';
import 'package:FirsteProjectFlutter/models/panier.dart';
import 'package:FirsteProjectFlutter/models/promotion.dart';
import 'package:FirsteProjectFlutter/screens/Services/check_out_page.dart';
import 'package:FirsteProjectFlutter/screens/category/category_list_page.dart';
import 'package:FirsteProjectFlutter/screens/notifications_page.dart';
import 'package:FirsteProjectFlutter/screens/profile_page.dart';
import 'package:FirsteProjectFlutter/screens/search_page.dart';
import 'package:FirsteProjectFlutter/screens/tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<String> timelines = ['Promotion', 'Best of Week'];
String selectedTimeline = 'Promotion';


class _MainPageState extends State<MainPage>
    with TickerProviderStateMixin<MainPage> {
  SwiperController swiperController;
  TabController tabController;
  TabController bottomTabController;
  List<Promotion> promo ;
  var info;
  Promotion p;
  List<Panier> panier;
  @override
  void initState() {
    _affich();
    promo = [];
    panier = [];
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    bottomTabController = TabController(length: 4, vsync: this);
  }
  

  void _affich() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.getString(key) ?? 0;
    var v = value.toString().split("|");
    var string = v[1];
    String myUrl = "http://beauty.procreagency.com/api/getallpromo";
    http.Response response = await http.get(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $string'
    });
    var data = json.decode(response.body);
    if (data != null) {
      setState(() {
        info = data;
      });
      print(info);
    }
    for (int i=0; i < info.length; i++) {
      for(int j=0; j <= i; j++)
       p = Promotion(
          info[i]['id'],
          info[i]['nom'],
          info[i]['date_debut'],
          info[i]['date_fin'],
          info[i]['pourcentage'],
          info[i]['image'],
          info[i]['services']['nom_service'],
          info[i]['services']['description'],
          info[i]['services']['prix'],
          info[i]['services']['nb_points'],
          info[i]['services']['image']  

          );
      setState(() {
        promo.add(p);
      });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    Widget appBar = Container(
      height: kToolbarHeight + MediaQuery.of(context).padding.top,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => NotificationsPage())),
              icon: Icon(Icons.notifications)),
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SearchPage())),
              icon: SvgPicture.asset('assets/icons/search_icon.svg'))
        ],
      ),
    );

    Widget topHeader = Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeline = timelines[0];

                   });
                },
                child: Text(
                  timelines[0],
                  style: TextStyle(
                      fontSize: timelines[0] == selectedTimeline ? 20 : 14,
                      color: darkGrey),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedTimeline = timelines[1];
                   });
                },
                child: Text(timelines[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: timelines[1] == selectedTimeline ? 20 : 14,
                        color: darkGrey)),
              ),
            ),
           ],
        ));

    return Scaffold(
      bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
      body: CustomPaint(
        painter: MainBackground(),
        child: TabBarView(
          controller: bottomTabController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            //Text(info[0]['nom']),
            SafeArea(
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  // These are the slivers that show up in the "outer" scroll view.
                  return <Widget>[
                    SliverToBoxAdapter(
                      child: appBar,
                    ),
                    SliverToBoxAdapter(
                      child: topHeader,
                    ),
                    SliverToBoxAdapter(
                      child: ProductList(
                        products: promo,
                      ),
                    ),
                  ];
                },
                body: TabView(
                  tabController: tabController,
                ),
              ),
            ),
            CheckOutPage(),
            TrackingPage(),
            ProfilePage(),
          ],
        ),
      ),
    );
  }
}

