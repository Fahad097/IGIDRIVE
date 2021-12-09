import 'dart:async';

import 'package:IGI_Drive/Screens/DashboardScreen.dart';
import 'package:IGI_Drive/Screens/Servicecenter.dart';
import 'package:IGI_Drive/Screens/profileScreen.dart';
import 'package:IGI_Drive/Screens/trip.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'Screens/Notification.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';

int pageIndex = 0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String notLength = "0";
  Timer timer;

  @override
  void initState() {
    getword();
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getword());

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  getword() async {
    NotificationListt.NotificationListData = [];
    final storage = new FlutterSecureStorage();

    String imei = await storage.read(key: "imei");

    //print('showimi');
    //print(imei);

    var map = new Map<String, dynamic>();

    var url =
        'http://api.igiinsurance.com.pk:8888/drive_api/show_notification_test.php?imei_number=${imei}';
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    //print(data);

    int not_length = 0;
    if (data['data'].length > 0) {
      NotificationListt.NotificationListData.addAll(data['data']);
      for (var i = 0; i < data['data'].length; i++) {
        if (data['data'][i]['notification_view'].toString() == "unseen") {
          not_length = not_length + 1;
        }
      }
      //print('length notification ${not_length}');
      await storage.write(key: 'not_length', value: not_length.toString());
    }

    print('run');

    notLength = await storage.read(key: "not_length");
    print('length not ${notLength}');
    setState(() {
      notLength = notLength;
    });
  }

  double xOffset = 0;
  double yOffset = 0;
  int pageIndex = 0;

  double scaleFactor = 1;
  var rating = 3.0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(width);

    return AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, 0)
          ..scale(scaleFactor)
          ..rotateY(isDrawerOpen ? -0.5 : 0),
        duration: Duration(milliseconds: 370),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
        child: GestureDetector(
          onTap: () {
            isDrawerOpen
                ? setState(() {
                    xOffset = 0;
                    yOffset = 0;
                    scaleFactor = 1;
                    isDrawerOpen = false;
                  })
                : print('sada');
          },
          child: Container(
            decoration: BoxDecoration(
              //Here goes the same radius, u can put into a var or function
              borderRadius: BorderRadius.circular(40.0),
            ),
            child: ClipRRect(
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40.0)
                  : BorderRadius.circular(0),
              child: Scaffold(
                backgroundColor: Color(0xffFCFCFC),

                bottomNavigationBar: BottomNavyBar(
                  selectedIndex: pageIndex,
                  showElevation: true,
                  itemCornerRadius: 20,
                  curve: Curves.easeIn,
                  onItemSelected: (index) {
                    setState(() {
                      pageIndex = index;
                      print(pageIndex);
                    });
                  },
                  items: <BottomNavyBarItem>[
                    BottomNavyBarItem(
                      icon: Icon(Icons.dashboard_outlined),
                      title: Text('Dashboard'),
                      activeColor: Color(0xff01a8dd),
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.location_on_outlined),
                      title: Text('Trips'),
                      activeColor: Color(0xff01a8dd),
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.headset_mic_outlined),
                      title: Text(
                        'Service',
                      ),
                      activeColor: Color(0xff01a8dd),
                      textAlign: TextAlign.center,
                    ),
                    BottomNavyBarItem(
                      icon: Icon(Icons.person_outlined),
                      title: Text('Profile'),
                      activeColor: Color(0xff01a8dd),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                // bottomNavigationBar: CurvedNavigationBar(
                //   animationCurve: Curves.easeInOut,
                //   animationDuration: Duration(milliseconds: 400),
                //   backgroundColor: Color(0xff01a8dd),
                //   items: <Widget>[
                //     Icon(
                //       Icons.dashboard_outlined,
                //       size: 30,
                //       color: Color(0xff01a8dd),
                //     ),
                //     Icon(
                //       Icons.location_on_outlined,
                //       size: 30,
                //       color: Color(0xff01a8dd),
                //     ),
                //     Icon(
                //       Icons.headset_mic_outlined,
                //       size: 30,
                //       color: Color(0xff01a8dd),
                //     ),
                //     Icon(
                //       Icons.person_outlined,
                //       size: 30,
                //       color: Color(0xff01a8dd),
                //     ),
                //   ],
                //   onTap: (index) {
                //     setState(() {
                //       pageIndex = index;
                //       print(pageIndex);
                //     });
                //   },
                // ),

                appBar: AppBar(
                    backgroundColor: Colors.white,
                    leading: isDrawerOpen
                        ? Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  xOffset = 0;
                                  yOffset = 0;
                                  scaleFactor = 1;
                                  isDrawerOpen = false;
                                });
                              },
                              child: Container(
                                child: Icon(
                                  Icons.menu_outlined,
                                  size: 30,
                                  color: Color(0xff01a8dd),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  xOffset = 255;
                                  yOffset = 150;
                                  scaleFactor = 0.7;
                                  isDrawerOpen = true;
                                });
                              },
                              child: Container(
                                child: Icon(
                                  Icons.menu,
                                  color: Color(0xff01a8dd),
                                ),
                              ),
                            ),
                          ),
                    centerTitle: true,
                    // flexibleSpace: Container(
                    //   decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       image: AssetImage('images/nav.jpg'),
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    title: Text(
                      pageIndex == 0
                          ? 'Dashboard'
                          : pageIndex == 1
                              ? "Location"
                              : pageIndex == 2
                                  ? "Customer Services"
                                  : pageIndex == 3
                                      ? "My Account"
                                      : "",
                      style: TextStyle(
                          fontFamily: 'PoppinsMedium',
                          fontSize: 22,
                          color: Color(0xff01a8dd)),
                    ),
                    elevation: 1,
                    actions: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationList()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15, top: 10),
                          child: Stack(
                            children: <Widget>[
                              new Icon(
                                Icons.notifications_none,
                                size: 33,
                                color: Color(0xff01a8dd),
                              ),
                              new Positioned(
                                right: 0,
                                child: new Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: Color(0xff01a8dd),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: new Text(
                                    notLength != null ? notLength : "0",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => NotificationList()),
                      //     );
                      //   },
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(right: 15),
                      //     child: Icon(
                      //       Icons.notifications_none,
                      //       size: 33,
                      //     ),
                      //   ),
                      // )
                    ]),

                body: SingleChildScrollView(
                  child: Container(
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage("images/sidebg.png"),
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      child: Column(
                    children: [
                      pageIndex == 0 ? DashboardScreen() : Container(),
                      pageIndex == 1 ? TripScreen() : Container(),
                      pageIndex == 2 ? ServiceCenter() : Container(),
                      pageIndex == 3 ? ProfileScreen() : Container(),
                    ],
                  )),
                ),
              ),
            ),
          ),
        ));
  }
}
