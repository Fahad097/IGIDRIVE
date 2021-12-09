import 'dart:convert';

import 'package:IGI_Drive/Screens/TripSidescreen.dart';
import 'package:IGI_Drive/Screens/mapScreen.dart';
import 'package:IGI_Drive/Screens/pdfView.dart';
import 'package:IGI_Drive/Screens/setting.dart';
import 'package:IGI_Drive/Screens/sideAccount.dart';
import 'package:IGI_Drive/Screens/sideService.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'AuthScreens/Login.dart';
import 'Screens/feedback.dart';
import 'ServiceForms/contactUs.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String userName = "";
  String userEmail = "";
  bool checkLogin = false;

  @override
  initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  getData() async {
    final storage = new FlutterSecureStorage();

     userName = await storage.read(key: "userName");
      userEmail = await storage.read(key: "userEmail");
      setState(() {
        checkLogin = true;
      });
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Color(0xff01a8dd),
      padding: EdgeInsets.only(top: 50, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height * 0.04),
          Padding(
                              padding: const EdgeInsets.all(8.0),

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    checkLogin ? userName : '......',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsBold',
                        fontSize: 18),
                  ),
                  Text(checkLogin ? userEmail : '......',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'PoppinsMedium',
                      ))
                ],
              )
          ),
                    SizedBox(height: height * 0.04),

          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TripSideScree()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('My Trips',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SideAccount()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.supervised_user_circle_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('My Account',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SideService()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cleaning_services_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Service Center',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_searching_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('My Location',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launchInBrowser(
                      'https://www.youtube.com/watch?v=_qlgEbB_Dk4');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.video_library_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Videos',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.admin_panel_settings_outlined,
              //         color: Colors.white,
              //         size: 27,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text('Maintainance',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //               fontFamily: 'PoppinsRegular'))
              //     ],
              //   ),
              // ),

              GestureDetector(
                onTap: () {

                  _launchInBrowser("http://api.igiinsurance.com.pk:8888/drive_api/promotion.pdf");
                  
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => PdfView(
                  //           url:
                  //               "http://api.igiinsurance.com.pk:8888/drive_api/promotion.pdf")),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notification_important_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Promotions',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Icon(
              //         Icons.feedback_outlined,
              //         color: Colors.white,
              //         size: 27,
              //       ),
              //       SizedBox(
              //         width: 10,
              //       ),
              //       Text('Customer Feedback',
              //           style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 16,
              //               fontFamily: 'PoppinsRegular'))
              //     ],
              //   ),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Settings',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedBack()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.feedback_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('FeedBack',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactusSCreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.headset_mic_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Contact Us',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  launch("tel://04234507777");

                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_outlined,
                        color: Colors.white,
                        size: 27,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Call Helpline',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'PoppinsRegular'))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () async {
              final storage = new FlutterSecureStorage();

              String notiToken = await storage.read(key: "notiToken");
              String notiID = await storage.read(key: "notiID");

              var url3 =
                  'http://api.igiinsurance.com.pk:8888/drive_api/token_delete.php?id=${notiID}&token=${notiToken}';
              print(url3);
              http.Response res = await http.get(
                Uri.parse(url3),
                headers: <String, String>{
                  'token': 'c66026133e80d4960f0a5b7d418a4d08'
                },
              );
              var data33 = json.decode(res.body.toString());
              print(data33);
               TripLoadedCheck = false;
 EventLoadedCheck = false;
 ratingLoadCheck = false;

 tripList.tripListData = [];
 eventList.eventListData = [];

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
              await storage.deleteAll();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.power_settings_new_outlined,
                    color: Colors.white,
                    size: 27,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'PoppinsRegular'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
