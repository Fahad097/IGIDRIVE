import 'dart:math' as math;

import 'package:IGI_Drive/Screens/eventList.dart';
import 'package:IGI_Drive/Screens/mapScreen.dart';
import 'package:IGI_Drive/eventDetailsScreens/speeding.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:IGI_Drive/Screens/pdfView.dart';
import 'package:IGI_Drive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _shoW = false;
  double all_rating;
  double speed_rating;

  double break_rating;
  double concering_rating;
  double acceleration_rating;

  int needle_speed_rating;

  int needle_break_rating;
  int needle_concering_rating;
  int needle_acceleration_rating;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.getImi();
    });
  }

  getNot() async {
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
  }

  getImi() async {
    if (!ratingLoadCheck) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
                child: SpinKitWave(
                    color: Color(0xff01a8dd), type: SpinKitWaveType.center));
          });

      final storage = new FlutterSecureStorage();

      String imi = await storage.read(key: "imei");

      var url =
          'https://api.igiinsurance.com.pk/drive_api/rating.php?imei=${imi}';
      print(url);
      http.Response res = await http.get(
        Uri.parse(url),
        headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
      );
      var data = json.decode(res.body.toString());
      print('ya ha rating d ${data}');

      if (data['status'].toString() == "success") {
        ratingLoadCheck = true;
        //print(data);
        overallRating = data['over_all_rating'].toDouble();
        speedRating = data['over_speed_rating'].toDouble();
        breakRating = data['harsh_braking_rating'].toDouble();
        corneringRating = data['harsh_conering_rating'].toDouble();
        accelerationRating = data['harsh_accleration_rating'].toDouble();

        all_rating = double.parse(overallRating.toString());
        break_rating = double.parse(breakRating.toString());
        concering_rating = double.parse(corneringRating.toString());
        acceleration_rating = double.parse(accelerationRating.toString());
        speed_rating = double.parse(speedRating.toString());

        print(all_rating);
        print(acceleration_rating);
        print(speed_rating);
        print(break_rating);
        print(concering_rating);
        needle_acceleration_rating = acceleration_rating.toInt();
        needle_speed_rating = speed_rating.toInt();
        needle_break_rating = break_rating.toInt();
        needle_concering_rating = concering_rating.toInt();
        print('Test ${speed_rating.toInt()}');
        Navigator.pop(context);
        setState(() {});
        _shoW = true;
      }
    } else {
      print('debug 1');
      all_rating = double.parse(overallRating.toString());
      break_rating = double.parse(breakRating.toString());
      concering_rating = double.parse(corneringRating.toString());
      acceleration_rating = double.parse(accelerationRating.toString());
      speed_rating = double.parse(speedRating.toString());

      print('debug 1=2');

      print(all_rating);
      print(acceleration_rating);
      print(speed_rating);
      print(break_rating);
      print(concering_rating);
      needle_acceleration_rating = acceleration_rating.toInt();
      needle_speed_rating = speed_rating.toInt();
      needle_break_rating = break_rating.toInt();
      needle_concering_rating = concering_rating.toInt();
      print('Test ${speed_rating.toInt()}');
      // Navigator.pop(context);
      setState(() {});
      _shoW = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return _shoW
        ? Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.02,
                  ),
                  getSemiCircleProgressStyle(),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  _shoW
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SpeedingScreen(category: 'Speeding')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                height: 109,
                                width: width * 0.21,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 3, left: 3, top: 3),
                                      child: Image.asset('images/dail.png'),
                                    ),
                                    Positioned(
                                        left: 28,
                                        bottom: 68,
                                        child: RotationTransition(
                                          turns: new AlwaysStoppedAnimation(double.parse(
                                                      needle_speed_rating
                                                          .toInt()
                                                          .toString()) ==
                                                  0
                                              ? 90.0 / 180.0
                                              : double.parse(needle_speed_rating
                                                          .toInt()
                                                          .toString()) ==
                                                      1
                                                  ? 70.0 / 180.0
                                                  : double.parse(
                                                              needle_speed_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                          2
                                                      ? 60.0 / 180.0
                                                      : double.parse(needle_speed_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                              3
                                                          ? 40.0 / 180.0
                                                          : double.parse(needle_speed_rating.toInt().toString()) == 4
                                                              ? 20.0 / 180.0
                                                              : double.parse(needle_speed_rating.toInt().toString()) == 5
                                                                  ? 0.0 / 180.0
                                                                  : 180.0),
                                          child: Image.asset(
                                            'images/Needle_large.png',
                                            height: height * 0.013,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                        ),
                                        RatingBarIndicator(
                                          rating: speed_rating,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Color(0xffF4D03F),
                                          ),
                                          itemCount: 5,
                                          itemSize: 10.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: Text(
                                            'Over   Speeding',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'PoppinsRegular'),
                                          )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SpeedingScreen(category: 'Braking')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                height: 109,
                                width: width * 0.21,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 3, left: 3, top: 3),
                                      child: Image.asset('images/dail.png'),
                                    ),
                                    Positioned(
                                        left: 28,
                                        bottom: 68,
                                        child: RotationTransition(
                                          turns: new AlwaysStoppedAnimation(double.parse(
                                                      needle_break_rating
                                                          .toInt()
                                                          .toString()) ==
                                                  0
                                              ? 90.0 / 180.0
                                              : double.parse(needle_break_rating
                                                          .toInt()
                                                          .toString()) ==
                                                      1
                                                  ? 70.0 / 180.0
                                                  : double.parse(
                                                              needle_break_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                          2
                                                      ? 60.0 / 180.0
                                                      : double.parse(needle_break_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                              3
                                                          ? 40.0 / 180.0
                                                          : double.parse(needle_break_rating.toInt().toString()) == 4
                                                              ? 20.0 / 180.0
                                                              : double.parse(needle_break_rating.toInt().toString()) == 5
                                                                  ? 0.0 / 180.0
                                                                  : 180.0),
                                          child: Image.asset(
                                            'images/Needle_large.png',
                                            height: height * 0.013,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                        ),
                                        RatingBarIndicator(
                                          rating: break_rating,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Color(0xffF4D03F),
                                          ),
                                          itemCount: 5,
                                          itemSize: 10.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: Text(
                                            'Harsh   Breaking',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'PoppinsRegular'),
                                          )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpeedingScreen(
                                          category: 'Acceleration')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                height: 109,
                                width: width * 0.21,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 3, left: 3, top: 3),
                                      child: Image.asset('images/dail.png'),
                                    ),
                                    Positioned(
                                        left: 28,
                                        bottom: 68,
                                        child: RotationTransition(
                                          turns: new AlwaysStoppedAnimation(double.parse(
                                                      needle_acceleration_rating
                                                          .toInt()
                                                          .toString()) ==
                                                  0
                                              ? 90.0 / 180.0
                                              : double.parse(
                                                          needle_acceleration_rating
                                                              .toInt()
                                                              .toString()) ==
                                                      1
                                                  ? 70.0 / 180.0
                                                  : double.parse(
                                                              needle_acceleration_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                          2
                                                      ? 60.0 / 180.0
                                                      : double.parse(needle_acceleration_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                              3
                                                          ? 40.0 / 180.0
                                                          : double.parse(needle_acceleration_rating.toInt().toString()) == 4
                                                              ? 20.0 / 180.0
                                                              : double.parse(needle_acceleration_rating.toInt().toString()) == 5
                                                                  ? 0.0 / 180.0
                                                                  : 180.0),
                                          child: Image.asset(
                                            'images/Needle_large.png',
                                            height: height * 0.013,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                        ),
                                        RatingBarIndicator(
                                          rating: acceleration_rating,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Color(0xffF4D03F),
                                          ),
                                          itemCount: 5,
                                          itemSize: 10.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: Text(
                                            'Harsh Acceleration',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'PoppinsRegular'),
                                          )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SpeedingScreen(
                                          category: 'Cornering')),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                ),
                                height: 109,
                                width: width * 0.21,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 3, left: 3, top: 3),
                                      child: Image.asset('images/dail.png'),
                                    ),
                                    Positioned(
                                        left: 28,
                                        bottom: 68,
                                        child: RotationTransition(
                                          turns: new AlwaysStoppedAnimation(double.parse(
                                                      needle_concering_rating
                                                          .toInt()
                                                          .toString()) ==
                                                  0
                                              ? 90.0 / 180.0
                                              : double.parse(
                                                          needle_concering_rating
                                                              .toInt()
                                                              .toString()) ==
                                                      1
                                                  ? 70.0 / 180.0
                                                  : double.parse(
                                                              needle_concering_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                          2
                                                      ? 60.0 / 180.0
                                                      : double.parse(needle_concering_rating
                                                                  .toInt()
                                                                  .toString()) ==
                                                              3
                                                          ? 40.0 / 180.0
                                                          : double.parse(needle_concering_rating.toInt().toString()) == 4
                                                              ? 20.0 / 180.0
                                                              : double.parse(needle_concering_rating.toInt().toString()) == 5
                                                                  ? 0.0 / 180.0
                                                                  : 180.0),
                                          child: Image.asset(
                                            'images/Needle_large.png',
                                            height: height * 0.013,
                                          ),
                                        )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 35,
                                        ),
                                        RatingBarIndicator(
                                          rating: concering_rating,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Color(0xffF4D03F),
                                          ),
                                          itemCount: 5,
                                          itemSize: 10.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Center(
                                              child: Text(
                                            'Harsh Cornering',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontFamily: 'PoppinsRegular'),
                                          )),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventList()),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      height: height * 0.078,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                children: <TextSpan>[
                                  // new TextSpan(
                                  //     text: '2 ',
                                  //     style: new TextStyle(
                                  //         fontSize: 20, fontFamily: 'PoppinsRegular')),
                                  new TextSpan(
                                      text: ' EVENTS',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey,
                                          fontFamily: 'PoppinsMedium')),
                                ],
                              ),
                            ),
                            Container(
                                height: height * 0.035,
                                child:
                                    Image.asset('images/driving-events@2x.png'))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        height: height * 0.078,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MY CAR LOCATION',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                      fontFamily: 'PoppinsMedium')),
                              Container(
                                  height: height * 0.035,
                                  child: Image.asset('images/Location@2x.png'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.1,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget getSemiCircleProgressStyle() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          height: 200,
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -110,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                      showLabels: false,
                      showTicks: false,
                      startAngle: 180,
                      canScaleToFit: true,
                      endAngle: 0,
                      radiusFactor: 0.8,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.07,
                        color: const Color.fromARGB(30, 0, 169, 181),
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: all_rating * 100 / 5,
                            width: 0.07,
                            gradient: const SweepGradient(colors: <Color>[
                              Color(0xffFA391B),
                              Color(0xffF7E42A),
                              Color(0xff52C94C),
                              Color(0xff01a8dd)
                            ], stops: <double>[
                              0.25,
                              0.5,
                              0.75,
                              1
                            ]),
                            sizeUnit: GaugeSizeUnit.factor,
                            enableAnimation: true,
                            animationDuration: 1500,
                            animationType: AnimationType.linear,
                            cornerStyle: CornerStyle.bothCurve)
                      ],
                    ),
                  ]),
                ),
                Positioned(
                  top: 65,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RatingBarIndicator(
                            rating: all_rating / 6.5,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Color(0xffF4D03F),
                            ),
                            itemCount: 1,
                            itemSize: 45.0,
                            direction: Axis.vertical,
                          ),
                        ),
                        RichText(
                          text: new TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: all_rating.toStringAsFixed(1),
                                  style: new TextStyle(
                                      fontSize: 40,
                                      fontFamily: 'PoppinsRegular')),
                              new TextSpan(
                                  text: ' /5',
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.grey[400],
                                      fontFamily: 'PoppinsRegular')),
                            ],
                          ),
                        ),
                        Text(
                          'FIFTEEN DAYS SCORE',
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'PoppinsMedium'),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -112,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                      showLabels: false,
                      showTicks: false,
                      startAngle: 180,
                      canScaleToFit: true,
                      endAngle: 0,
                      radiusFactor: 0.7,
                      axisLineStyle: AxisLineStyle(
                        thickness: 0.01,
                        color: const Color.fromARGB(30, 0, 169, 181),
                        thicknessUnit: GaugeSizeUnit.factor,
                        cornerStyle: CornerStyle.bothCurve,
                      ),
                      pointers: <GaugePointer>[
                        RangePointer(
                            value: 100,
                            width: 0.01,
                            color: Colors.grey,
                            sizeUnit: GaugeSizeUnit.factor,
                            enableAnimation: true,
                            animationDuration: 1,
                            animationType: AnimationType.linear,
                            cornerStyle: CornerStyle.bothCurve)
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}

final Gradient gradient = new LinearGradient(
  colors: <Color>[
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,

    // Colors.blueAccent.withOpacity(1.0),
  ],
  stops: [
    0.1,
    0.3,
    0.6,
    1.0,
  ],
);

class Circular_arc extends StatefulWidget {
  final double all_rating;
  const Circular_arc({Key key, this.all_rating}) : super(key: key);

  @override
  _Circular_arcState createState() => _Circular_arcState();
}

class _Circular_arcState extends State<Circular_arc>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    final curvedAnimation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);

    animation = Tween<double>(begin: 0.0, end: widget.all_rating / 2)
        .animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });
    animController.repeat(max: 1);
    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.all_rating);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(300, 300),
            painter: ProgressArc(null, Colors.black54, true),
          ),
          CustomPaint(
            size: Size(300, 300),
            painter: ProgressArc(animation.value, Colors.redAccent, false),
          ),
          Positioned(
            top: height * 0.06,
            left: width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: RatingBarIndicator(
                    rating: widget.all_rating / 6.5,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Color(0xffF4D03F),
                    ),
                    itemCount: 1,
                    itemSize: 45.0,
                    direction: Axis.vertical,
                  ),
                ),
                RichText(
                  text: new TextSpan(
                    // Note: Styles for TextSpans must be explicitly defined.
                    // Child text spans will inherit styles from parent
                    style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      new TextSpan(
                          text: widget.all_rating.toStringAsFixed(1),
                          style: new TextStyle(
                              fontSize: 40, fontFamily: 'PoppinsRegular')),
                      new TextSpan(
                          text: ' /5',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.grey[400],
                              fontFamily: 'PoppinsRegular')),
                    ],
                  ),
                ),
                Text(
                  'FIFTEEN DAYS SCORE',
                  style: TextStyle(
                      color: Colors.grey[400], fontFamily: 'PoppinsMedium'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ProgressArc extends CustomPainter {
  bool isBackground;
  double arc;
  Color progressColor;

  ProgressArc(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, 300, 300);
    final startAngle = -math.pi;
    final sweepAngle = arc != null ? arc : math.pi;
    final userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    if (!isBackground) {
      paint.shader = gradient.createShader(rect);
    }
    canvas.drawArc(rect, startAngle, sweepAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
