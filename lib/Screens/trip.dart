import 'dart:math' as math;

import 'package:IGI_Drive/Screens/TripRouteMap.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:convert';
import 'dart:io';

import 'package:IGI_Drive/AuthScreens/Login.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:IGI_Drive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'mapScreen.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class TripScreen extends StatefulWidget {
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  bool showTrip = false;
  double all_rating;
  var AllData;
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayyFormatter = DateFormat('EEE');
  var DataArray = [];
  var DataArray2 = [];
  var _isChecked = [];

  int currentindex;
  int dateindex;
  String base64Image = '';
  String selectedDate = '';
  String selectedTime = '';
  var FiteredData = [];
  var datashowThis = [];
  var datashowThis2 = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.getNot();
      this.getEvent();
    });
  }


  getEvent() async {
    print('event call');
    if (!EventLoadedCheck) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
                child: SpinKitWave(
                    color: Color(0xff01a8dd), type: SpinKitWaveType.center));
          });

      final storage = new FlutterSecureStorage();

      String imei = await storage.read(key: "imei");

      print('showimi');
      print(imei);

      var map = new Map<String, dynamic>();
      var url =
          'http://api.igiinsurance.com.pk:8888/drive_api/event_show.php?imei_number=${imei}';
      print(url);
      http.Response res = await http.get(
        Uri.parse(url),
        headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
      );
      var data = json.decode(res.body.toString());
      print(data);
      eventList.eventListData = data['items'];
          Navigator.pop(context);
    }
  }





  List<Widget> textWidgetList = List<Widget>();

  getNot() async {
    print('trip call');
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center));
        });

    if (!TripLoadedCheck) {
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

    for (var i = 0; i < tripList.tripListData.length; i++) {
      DateTime input = DateTime.parse(tripList.tripListData[i]['dateStart'])
          .add(Duration(hours: 5));
          
      String dateee = '${input.year}-${input.month}-${input.day.toString().length == 1 ? '0${input.day}' : '${input.day}'}';

print('tripList.tripListData ${tripList.tripListData}');
      if (FiteredData.where((element) {
        print('issue ${element['dateStart']}');
            if (FiteredData.length > 0) {
              DateTime check =
                  DateTime.parse(element['dateStart']).add(Duration(hours: 5));
              String dateeee = '${check.year}-${check.month}-${check.day}';
              print('add karo');
              print('${dateeee}   ${dateee}');
              return dateeee == dateee;
            } else {
              print('add ni karo');
              return false;
            }

// print('dateeee ${dateeee}');
// print('dateee ${dateee}');
// if(dateeee == null){
//   return false;

// }
// else{
//   return true;
// }
          }).toList().length >
          0) {
        print('if');
      } else {
        print('else');
       if(FiteredData.where((element) => element['dateStart'] == dateee).length > 0 ){
       }
       else{
                   FiteredData.add({"dateStart": dateee, "data": []});

       }
      }
    }
    num kmCout = 0;

    for (var i = 0; i < FiteredData.length; i++) {
      var matchData = tripList.tripListData.where((element) {
        // element['slotName'] == FiteredData[i]['dateStart'];

        DateTime check =
            DateTime.parse(element['dateStart']);
              String dateeee = '${check.year}-${check.month}-${check.day.toString().length == 1 ? '0${check.day}' : '${check.day}'}';

        kmCout = kmCout + element['stats']['distance'];
        print('kmCout ${kmCout}');

        if (dateeee == FiteredData[i]['dateStart']) {
          return true;
        } else {
          return false;
        }
      }).toList();
      print('matchData ${matchData}');
      //  FiteredData.insert(i, matchData);
      datashowThis
          .add({'dateStart': FiteredData[i]['dateStart'], 'data': matchData});
           datashowThis2
          .add({'dateStart': FiteredData[i]['dateStart'], 'data': matchData});
    }

    print('FiteredData ${FiteredData}');
    print('datashowThis ${datashowThis}');

    print(tripList.tripListData);
    DataArray.addAll(tripList.tripListData);
    DataArray2.addAll(tripList.tripListData);
    Navigator.pop(context);

    getImi();
  }

  getImi() async {
    // print('data Length ${DataArray.length}');
    final storage = new FlutterSecureStorage();

    String imi = await storage.read(key: "imei");
    //print('showimi');
    //print("this"+imi);
    String d1 = await storage.read(key: "overall_rating");
    all_rating = double.parse(overallRating.toString());

    var data = DataArray;
    if (data.length > 0) {
      // print(data);
      //print('have data');
      //print(data.length);

      setState(() {
        showTrip = true;
      });
    } else {
      setState(() {
        showTrip = false;
      });
      //print('no data');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
    return Container(
      child:
        showTrip
          ? Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: Height * 0.02,
                  ),
                  getSemiCircleProgressStyle(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Center(
                                child: Text(
                              'Your Trip List',
                              style: TextStyle(
                                  fontFamily: 'PoppinsRegular',
                                  fontSize: 17,
                                  color: Color(0xff8f9ba8)),
                            )),
                          ),
                          GestureDetector(
                              onTap: () {
                                showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        final dates = <Widget>[];
                                        DateFormat dateFormat =
                                            DateFormat("yyyy-MM-dd");

                                        for (int i = 0; i < 15; i++) {
                                          final date = _currentDate
                                              .subtract(Duration(days: i));

                                          dates.add(Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  // set current index!
                                                  currentindex = i;
                                                  selectedDate =
                                                      '${_monthFormatter.format(date)} + ${_dayFormatter.format(date)} + ${_dayyFormatter.format(date)}';
                                                  
                                                  // print(date);
                                                  // print(dateFormat.format(date));

                                                  //  print(DataArray2.where((i) =>
                                                  //     dateFormat
                                                  //       .format(
                                                  //         DateTime.parse(i[
                                                  //            'dateStart']))
                                                  //   .toString() ==
                                                  // dateFormat
                                                  //    .format(date)
                                                  //   .toString()).toList());
                                                  //print(datashowThis.length);
                                                  var filtereddata = datashowThis2.where((element) => dateFormat
                                                          .format(
                                                              DateTime.parse(element[
                                                                  'dateStart']))
                                                          .toString() ==
                                                      dateFormat
                                                          .format(date)
                                                          .toString()).toList();
                                                      
                                                  var dumBData = DataArray2.where((i) =>
                                                      dateFormat
                                                          .format(
                                                              DateTime.parse(i[
                                                                  'dateStart']))
                                                          .toString() ==
                                                      dateFormat
                                                          .format(date)
                                                          .toString()).toList();
                                                          
                                                  DataArray.clear();
                                                  datashowThis.clear();
                                                  //('test');
                                                  setState(() {
                                                    datashowThis.addAll(filtereddata);
                                                    DataArray.addAll(dumBData);
                                                  });
                                                  setState(() {
                                                    getImi();
                                                  });
                                                  //  print(DataArray);

                                                  //  print(DataArray.length);
                                                  // Navigator.of(context).pop();
                                                });
                                              },
                                              child: Container(
                                                height: Height * 0.15,
                                                width: Width * 0.23,
                                                decoration: BoxDecoration(
                                                    color: currentindex == i
                                                        ? Color(0xff01a8dd)
                                                        : Colors
                                                            .white, // Here we checked!
                                                    border: Border.all(
                                                        color: currentindex == i
                                                            ? Color(0xff01a8dd)
                                                            : Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        _monthFormatter
                                                            .format(date),
                                                        style: TextStyle(
                                                            color:
                                                                currentindex ==
                                                                        i
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .grey,
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            fontSize: 17),
                                                      ),
                                                      SizedBox(
                                                        height: Height * 0.002,
                                                      ),
                                                      Text(
                                                          _dayFormatter
                                                              .format(date),
                                                          style: TextStyle(
                                                              color:
                                                                  currentindex ==
                                                                          i
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                              fontFamily:
                                                                  'PoppinsBold',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25)),
                                                      SizedBox(
                                                        height: Height * 0.002,
                                                      ),
                                                      Text(
                                                          _dayyFormatter
                                                              .format(date),
                                                          style: TextStyle(
                                                              color:
                                                                  currentindex ==
                                                                          i
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              fontSize: 17)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ));
                                        }

                                        return Container(
                                          height: Height * 0.3,
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                      child: Text(
                                                    'Select Trip Date',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xff8f9ba8)),
                                                  )),
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: dates,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Icon(
                                Icons.filter_alt_outlined,
                                size: 35,
                                color: Color(0xff01a8dd),
                              ))
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: datashowThis.length,
                      itemBuilder: (context, i) {
                        num kmCout = 0;
                        num timE = 0;
                        
                        for (var j = 0;
                            j < datashowThis[i]['data'].length;
                            j++) {
                          kmCout = kmCout +
                              datashowThis[i]['data'][j]['stats']['distance'];
                          timE = timE +
                              datashowThis[i]['data'][j]['stats']['driveTime'];
                        }
                        final d4 = Duration(seconds: timE);
                        DateTime now = new DateTime.now();
                        DateTime date =
                            new DateTime(now.year, now.month, now.day);
                        String currentDate =
                            "${now.year}-${now.month}-${now.day}";
                        print(currentDate);
                        var partss = d4.toString().split(':');

                        return Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xffFDFEFE),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Color(0xfff7f7f7)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: new TextSpan(
                                        // Note: Styles for TextSpans must be explicitly defined.
                                        // Child text spans will inherit styles from parent
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: '',
                                              style: new TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'PoppinsMedium')),
                                          new TextSpan(
                                              text: currentDate ==
                                                      datashowThis[i]
                                                          ['dateStart']
                                                  ? 'Today'
                                                  : datashowThis[i]
                                                      ['dateStart'],
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'PoppinsRegular',
                                                  color: Color(0xff626567))),
                                        ],
                                      ),
                                    ),
                                    RichText(
                                      text: new TextSpan(
                                        // Note: Styles for TextSpans must be explicitly defined.
                                        // Child text spans will inherit styles from parent
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          new TextSpan(
                                              text: kmCout.toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'PoppinsRegular',
                                                  color: Color(0xff626567))),
                                          new TextSpan(
                                              text: ' KM',
                                              style: new TextStyle(
                                                  fontSize: 17,
                                                  fontFamily: 'PoppinsMedium')),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                          text: new TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: partss[0]
                                                      .trim()
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      color:
                                                          Color(0xff626567))),
                                              new TextSpan(
                                                  text: ' HRS ',
                                                  style: new TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'PoppinsMedium')),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: new TextSpan(
                                            // Note: Styles for TextSpans must be explicitly defined.
                                            // Child text spans will inherit styles from parent
                                            style: new TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: partss[1]
                                                      .trim()
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'PoppinsRegular',
                                                      color:
                                                          Color(0xff626567))),
                                              new TextSpan(
                                                  text: ' MIN',
                                                  style: new TextStyle(
                                                      fontSize: 17,
                                                      fontFamily:
                                                          'PoppinsMedium')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: datashowThis[i]['data'].length,
                                itemBuilder: (context, index) {
                                  String dateStart = datashowThis[i]['data']
                                      [index]['dateStart'];
                                  DateTime input = DateTime.parse(dateStart)
                                      .add(Duration(hours: 5));

                                  final df = new DateFormat('hh:mm a');

                                  String date =
                                      'Start Date: ${input.year}-${input.month}-${input.day}';
                                  String time =
                                      'Start Time : ${df.format(input)}';
                                  // print(date);
                                  // print(time);

                                  String dateEnd =
                                      datashowThis[i]['data'][index]['dateEnd'];
                                  DateTime input2 = DateTime.parse(dateEnd)
                                      .add(Duration(hours: 5));
                                  String date2 =
                                      'End Date: ${input2.year}-${input2.month}-${input2.day}';
                                  String time2 =
                                      'End Time : ${df.format(input2)}';
                                  var second = int.parse(datashowThis[i]['data']
                                          [index]['stats']['driveTime']
                                      .toString());
                                  //  print('second ${second}');
                                  var hour = second / 3600;
                                  var flag = second % 3600;
                                  var min = flag / 60;

                                  final d3 = Duration(seconds: second);
                                  //print(d3);

                                  var parts = d3.toString().split(':');
                                  var prefix = parts[0].trim();
//print('asdas ${parts[1]}');

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TripRouteScreen(
                                                      data: datashowThis[i]
                                                          ['data'][index])),
                                        );
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              border: Border.all(
                                                  color: Color(0xfff7f7f7)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  spreadRadius: 3,
                                                  blurRadius: 5,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width:
                                                                Width * 0.04),
                                                        Text(
                                                          date,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'PoppinsMedium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(
                                                            width: Width * 0.1),
                                                        Text(
                                                          time,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'PoppinsMedium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Height * 0.005,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width:
                                                                Width * 0.04),
                                                        Text(
                                                          date2,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'PoppinsMedium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        SizedBox(
                                                            width: Width * 0.1),
                                                        Text(
                                                          time2,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'PoppinsMedium',
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: Height * 0.008,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                            height:
                                                                Width * 0.12,
                                                            width: Width * 0.12,
                                                            child: Image.asset(
                                                                'images/Group 3@3x.png')),
                                                        SizedBox(
                                                          width: Width * 0.02,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                                width:
                                                                    Width * 0.5,
                                                                child: Text(
                                                                  datashowThis[i]['data'][index]
                                                                              [
                                                                              'start']
                                                                          [
                                                                          'address']
                                                                      .toString(),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 1,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'PoppinsRegular',
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                              .grey[
                                                                          500]),
                                                                )),
                                                            SizedBox(
                                                              height: Height *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                                width:
                                                                    Width * 0.5,
                                                                child: Text(
                                                                    datashowThis[i]['data'][index]['end']
                                                                            [
                                                                            'address']
                                                                        .toString(),
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'PoppinsRegular',
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .grey[500])))
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
                                                Text(
                                                    '${datashowThis[i]['data'][index]['stats']['distance'].toString()} KM',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsMedium',
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xff01a8dd))),
                                                Text(
                                                    '${parts[0].trim()} HRS ${parts[1].toString() != "00" ? parts[1].trim() : '0'} MIN',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsMedium',
                                                        fontSize: 11,
                                                        color:
                                                            Color(0xff01a8dd)))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 15),
                              child: Container(
                                  width: Width * 1,
                                  color: Colors.grey,
                                  height: 1),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    );
  }

  Widget getSemiCircleProgressStyle() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
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

