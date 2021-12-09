import 'package:IGI_Drive/Screens/TripRouteMap.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeedingScreen extends StatefulWidget {
  final String category;
  const SpeedingScreen({Key key, this.category}) : super(key: key);
  @override
  _SpeedingScreenState createState() => _SpeedingScreenState();
}

class _SpeedingScreenState extends State<SpeedingScreen> {
  bool _shoW = false;
  double distance;
  double all_rating;
  double speed_rating;

  double break_rating;
  double concering_rating;
  double acceleration_rating;
  var dataa = {'Items': []};

  String rating = "";
    @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.getNot();

    });
  }


      getNot() async {
          showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center));
        });

   if(!TripLoadedCheck){
 final storage = new FlutterSecureStorage();

    String imei = await storage.read(key: "imei");

    print('showimi');
    print(imei);

    var map = new Map<String, dynamic>();


    var url =
        'http://api.igiinsurance.com.pk:8888/drive_api/trip_show.php?imei_number=${imei}';
    print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);
    TripLoadedCheck = true;
        tripList.tripListData = data['items'];
   }


    print(tripList.tripListData);

    Navigator.pop(context);

    getStar();
    getImi();
  }


  getStar() async {
    final storage = new FlutterSecureStorage();
    if (widget.category.toString() == "Acceleration") {
      rating = accelerationRating.toString();
    }
    if (widget.category.toString() == "Braking") {
      rating = breakRating.toString();
    }
    if (widget.category.toString() == "Cornering") {
      rating = corneringRating.toString();
    }
    if (widget.category.toString() == "Speeding") {
      rating = speedRating.toString();
    }
  }

  List<Widget> textWidgetList = List<Widget>();

  getImi() async {
    final storage = new FlutterSecureStorage();

    String imi = await storage.read(key: "imei");

    print('showimi');

    var map = new Map<String, dynamic>();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center));
        });

    // var url =
    //     'http://api.igiinsurance.com.pk:8888/drive_api/trip_show.php?imei=${imi}';
    // print(url);
    // http.Response res = await http.get(
    //   url,
    //   headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    // );
    // var data = json.decode(res.body.toString());
    // print(data);
    var data = tripList.tripListData;

    if (data.length > 0) {
      Navigator.pop(context);
      List itemList = data;

      for (Map item in itemList) {
        Map rating = item['rating'];

        if (rating != null) {
          if (rating['penalties']?.length > 0) {
            print('sss');
            List penalties = rating['penalties'];
            for (Map penalty in penalties) {
              if (penalty['name'] == widget.category) {
                print(item);
                dataa['Items'].add(item);
              }
            }
          }
        }
      }
      var total = 0.0;
      print('Distance test ${dataa['Items'].length}');
      print(dataa['Items']);

      dataa['Items'].forEach((i) {
        print(i['stats']['distance']);
        distance = total += i['stats']['distance'];
      });

      print(dataa['Items'].length);
      for (int i = 0; i < dataa['Items'].length; i++) {
        String dateStart = dataa['Items'][i]['dateStart'];
        DateTime input = DateTime.parse(dateStart);
        String date = 'Start Date: ${input.year}-${input.month}-${input.day}';
        String time = 'Start Time : ${input.hour}:${input.minute}';
        // print(date);
        // print(time);

        String dateEnd = dataa['Items'][i]['dateEnd'];
        DateTime input2 = DateTime.parse(dateEnd);
        String date2 = 'End Date: ${input2.year}-${input2.month}-${input2.day}';
        String time2 = 'End Time : ${input2.hour}:${input2.minute}';
        var second = dataa['Items'][i]['stats']['driveTime'];
        var hour = second / 3600;
        var flag = second % 3600;
        var min = flag / 60;
          final d3 = Duration(seconds: second);
  print(d3);
  
  var parts = d3.toString().split(':');
var prefix = parts[0].trim(); 
print('asdas ${parts[1]}');



        print('test in for ${dataa['Items'][i]['stats']['distance'].toString()}');

        // print(date);
        // print(time);
        double Height = MediaQuery.of(context).size.height;
        double Width = MediaQuery.of(context).size.width;
        textWidgetList.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                print(dataa['Items'][i]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TripRouteScreen(data: dataa['Items'][i])),
                );
              },
              child: Stack(
                children: [
                  Container(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: Width * 0.04),
                                Text(
                                  date,
                                  style: TextStyle(
                                      
                                       fontFamily:
                                                        'PoppinsMedium',
                                                    fontSize: 12,
                                      color: Colors.grey),
                                ),
                                SizedBox(width: Width * 0.1),
                                Text(
                                  time,
                                  style: TextStyle(
                                      fontFamily:
                                                        'PoppinsMedium',
                                                    fontSize: 12,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Height * 0.005,
                            ),
                            Row(
                              children: [
                                SizedBox(width: Width * 0.04),
                                Text(
                                  date2,
                                  style: TextStyle(
                                     fontFamily: 'PoppinsMedium',
                                                    fontSize: 12,
                                      color: Colors.grey),
                                ),
                                SizedBox(width: Width * 0.1),
                                Text(
                                  time2,
                                  style: TextStyle(
                                      fontFamily: 'PoppinsMedium',
                                      fontSize: 12,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            SizedBox(
                              height: Height * 0.008,
                            ),
                            Row(
                              children: [
                                Container(
                                    height: Width * 0.12,
                                    width: Width * 0.12,
                                    child:
                                        Image.asset('images/Group 3@3x.png')),
                                SizedBox(
                                  width: Width * 0.02,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: Width * 0.55,
                                        child: Text(
                                          dataa['Items'][i]['start']['address']
                                              .toString(),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize:12,
                                              fontFamily: 'PoppinsRegular',
                                              color: Colors.grey[500]),
                                        )),
                                    SizedBox(
                                      height: Height * 0.015,
                                    ),
                                    Container(
                                        width: Width * 0.55,
                                        child: Text(
                                            dataa['Items'][i]['end']['address']
                                                .toString(),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                                fontFamily: 'PoppinsRegular',
                                                color: Colors.grey[500])))
                                  ],
                                )
                              ],
                            ),
                          ],
                        )),
                  ),
                  Positioned(
                    right: 8.0,
                    bottom: 15.0,
                    child: Column(
                      children: [
                        Text('${dataa['Items'][i]['stats']['distance'].toString()} KM',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'PoppinsMedium',
                                fontSize: 11,
                                color: Color(0xff01a8dd))),
                        Text('${parts[0].trim()} HRS ${parts[1].toString() != "00" ? parts[1].trim() : '0'} MIN',
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'PoppinsMedium',
                                fontSize: 11,
                                color: Color(0xff01a8dd)))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      if (dataa['Items'].length >= 1) {
        setState(() {
          _shoW = true;
        });
      } else {
        setState(() {
          _shoW = false;
        });
      }
      setState(() {});
    } else {
      Navigator.pop(context);
      _shoW = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
          'Details',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),      body: SingleChildScrollView(
        child: Container(
          child: _shoW
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Travelled',
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              Text(
                                '${distance.toStringAsFixed(2)} Km',
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 20,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rating',
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              SmoothStarRating(
                                  allowHalfRating: false,
                                  onRated: (v) {},
                                  starCount: 5,
                                  rating: double.tryParse(rating),
                                  size: 20.0,
                                  isReadOnly: true,
                                  color: Color(0xffF4D03F),
                                  borderColor: Color(0xffF4D03F),
                                  spacing: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Events',
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 20,
                                    color: Colors.grey),
                              ),
                              Text(
                                '${dataa['Items'].length}',
                                style: TextStyle(
                                    fontFamily: 'PoppinsRegular',
                                    fontSize: 20,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: textWidgetList,
                    ),
                  ],
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
      ),
    );
  }
}
