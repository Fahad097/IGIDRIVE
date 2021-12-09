import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'eventDetailsmapscreen.dart';
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

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final _currentDate = DateTime.now();
  final _dayFormatter = DateFormat('d');
  final _monthFormatter = DateFormat('MMM');
  final _dayyFormatter = DateFormat('EEE');
  var DataArray = [];
  var DataArray2 = [];

  int currentindex;
  int dateindex;
  String base64Image = '';
  String selectedDate = '';
  String selectedTime = '';
  bool showTrip = false;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      this.getNot();
    });
  }

  List<Widget> textWidgetList = List<Widget>();

  getNot() async {
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
      EventLoadedCheck = true;

      eventList.eventListData = data['items'];
          Navigator.pop(context);

    }

    DataArray.addAll(eventList.eventListData);
    DataArray2.addAll(eventList.eventListData);


    getImi();
  }

  getImi() async {
    var data = DataArray;
    print('data ${data}');

    if (data.length > 0) {
      print('have data');

      double Height = MediaQuery.of(context).size.height;
      double Width = MediaQuery.of(context).size.width;

      setState(() {
        showTrip = true;
      });
    } else {
      setState(() {
        showTrip = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xff01a8dd),
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Event Details',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: Container(
        child: showTrip
            ? SingleChildScrollView(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/sidebg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Center(
                                    child: Text(
                                  'Your Event List',
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
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      // set current index!
                                                      currentindex = i;
                                                      selectedDate =
                                                          '${_monthFormatter.format(date)} + ${_dayFormatter.format(date)} + ${_dayyFormatter.format(date)}';
                                                      print(date);
                                                      print(dateFormat
                                                          .format(date));

                                                      print(DataArray2.where((i) =>
                                                          dateFormat
                                                              .format(DateTime
                                                                  .parse(i[
                                                                      'eventDate']))
                                                              .toString() ==
                                                          dateFormat
                                                              .format(date)
                                                              .toString()).toList());

                                                      var dumBData = DataArray2
                                                          .where((i) =>
                                                              dateFormat
                                                                  .format(DateTime
                                                                      .parse(i[
                                                                          'eventDate']))
                                                                  .toString() ==
                                                              dateFormat
                                                                  .format(date)
                                                                  .toString()).toList();

                                                      DataArray.clear();

                                                      print('test');
                                                      print(dumBData);
                                                      setState(() {
                                                        DataArray.addAll(
                                                            dumBData);
                                                      });
                                                      setState(() {
                                                        getImi();
                                                      });
                                                      print(DataArray);

                                                      print(DataArray.length);
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
                                                            color: currentindex ==
                                                                    i
                                                                ? Color(
                                                                    0xff01a8dd)
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
                                                            height:
                                                                Height * 0.002,
                                                          ),
                                                          Text(
                                                              _dayFormatter
                                                                  .format(date),
                                                              style: TextStyle(
                                                                  color: currentindex ==
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
                                                                  fontSize:
                                                                      25)),
                                                          SizedBox(
                                                            height:
                                                                Height * 0.002,
                                                          ),
                                                          Text(
                                                              _dayyFormatter
                                                                  .format(date),
                                                              style: TextStyle(
                                                                  color: currentindex ==
                                                                          i
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .grey,
                                                                  fontFamily:
                                                                      'PoppinsRegular',
                                                                  fontSize:
                                                                      17)),
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Center(
                                                          child: Text(
                                                        'Select Trip Date',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'PoppinsRegular',
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff8f9ba8)),
                                                      )),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
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
                      showTrip
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: DataArray.length,
                              itemBuilder: (context, i) {
                                // print(
                                //     'event Name ${DataArray[i]['eventClass']}');
                                // print(
                                //     'event type ${DataArray[i]['eventType']}');

                                String dateStart = DataArray[i]['eventDate'];
                                DateTime input = DateTime.parse(dateStart)
                                    .add(Duration(hours: 5));

                                String datee =
                                    DateFormat('hh:mm a').format(input);

                                String date =
                                    '${datee}      ${input.day}-${input.month}-${input.year}';

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsMapScreen(
                                                    data: DataArray[i])),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: Color(0xfff7f7f7)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(width: Width * 0.04),
                                                  Text(
                                                    DataArray[i][
                                                                'eventClass'] ==
                                                            "overspeedevent"
                                                        ? "Over Speeding"
                                                        : DataArray[i][
                                                                    'eventType'] ==
                                                                "harsh_accel"
                                                            ? "Harsh Acceleration"
                                                            : DataArray[i][
                                                                        'eventType'] ==
                                                                    "enter"
                                                                ? "Zone Enter"
                                                                : DataArray[i][
                                                                            'eventType'] ==
                                                                        "exit"
                                                                    ? "Zone Exit"
                                                                    : DataArray[i]['eventType'] ==
                                                                            "harsh_brake"
                                                                        ? "Harsh Braking"
                                                                        : DataArray[i]['eventType'] ==
                                                                                "harsh_corner"
                                                                            ? "Harsh Corner"
                                                                            : DataArray[i]['eventType'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontSize: 15,
                                                        color: Colors.grey),
                                                  ),
                                                  SizedBox(width: Width * 0.1),
                                                  Text(
                                                    date,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'PoppinsRegular',
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                      height: Width * 0.12,
                                                      width: Width * 0.12,
                                                      child: Image.asset(
                                                          'images/Oval@2x.png')),
                                                  SizedBox(
                                                    width: Width * 0.02,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                          width: Width * 0.76,
                                                          child: Text(
                                                            DataArray[i]['details']
                                                                            [
                                                                            'telemetry']
                                                                        [
                                                                        'location']
                                                                    ['address']
                                                                .toString(),
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'PoppinsRegular',
                                                                color: Colors
                                                                    .grey[500]),
                                                          )),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              })
                          : Container(),
                    ],
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
