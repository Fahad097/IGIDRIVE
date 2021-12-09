import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:IGI_Drive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'eventDetailsmapscreen.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool showTrip = false;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getImi();
    getNot();
  }

  getNot() async {
    final storage = new FlutterSecureStorage();

    String imei = await storage.read(key: "imei");

    print('showimi');
    print(imei);

    var map = new Map<String, dynamic>();


    var url =
        'http://api.igiinsurance.com.pk:8888/drive_api/seen_notification.php?imei_number=${imei}';
    print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);

    int not_length = 0;
    await storage.write(
        key: 'not_length', value: not_length.toString());

  }



  List<Widget> textWidgetList = List<Widget>();

  getImi() async {
    var data = NotificationListt.NotificationListData;
    print(data);
    if (data.length > 0) {
      print('have data');

      double Height = MediaQuery.of(context).size.height;
      double Width = MediaQuery.of(context).size.width;

      for (int i = 0; i < data.length; i++) {


        textWidgetList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Color(0xfff7f7f7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications_none, size: 30,                          color: Color(0xff01a8dd),
                          ),
                          SizedBox(width: Width * 0.1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalize(data[i]['notification_title'].toString()),
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 15,
                                    color: Colors.grey),
                              ),
                              SizedBox(height: 5,),
                              Text(
                                data[i]['notification_date'].toString(),
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 13,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          SizedBox(width: Width * 0.1),
                          Text(
                              data[i]['notification_time'].toString(),
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 13,
                                color: Colors.grey),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //         height: Width * 0.12,
                      //         width: Width * 0.12,
                      //         child: Image.asset('images/Oval@2x.png')),
                      //     SizedBox(
                      //       width: Width * 0.02,
                      //     ),
                      //     Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [
                      //         Container(
                      //             width: Width * 0.76,
                      //             child: Text(
                      //               data[i]['details']['telemetry']
                      //                       ['location']['address']
                      //                   .toString(),
                      //               maxLines: 1,
                      //               style: TextStyle(
                      //                   fontFamily: 'PoppinsRegular',
                      //                   color: Colors.grey[500]),
                      //             )),
                      //       ],
                      //     )
                      //   ],
                      // ),
                    ],
                  )),
            ),
          ),
        );
      }
      setState(() {
        showTrip = true;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Color(0xff01a8dd),)),
        centerTitle: true,

        backgroundColor: Colors.white,
         elevation: 1,
  title: Text(
          'Notification',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),      body: Container(
        child: showTrip
            ? SingleChildScrollView(
                child: Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("images/sidebg.png"),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Column(
                    children: textWidgetList,
                  ),
                ),
              )
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Image.asset(
                      'images/undraw_empty_xct9.png',
                    ),
                  ),
                  Center(
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Text(
                          'No Data Available',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'PoppinsBold',
                              color: Color(0xff01a8dd),
                              fontSize: 18),
                        )),
                  )
                ],
              ),
      ),
    );
  }
}
