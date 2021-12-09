import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:IGI_Drive/helpers/DataSaveArray.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class TripRouteScreen extends StatefulWidget {
  final data;

  const TripRouteScreen({Key key, @required this.data}) : super(key: key);
  @override
  _TripRouteScreenState createState() => _TripRouteScreenState();
}

class _TripRouteScreenState extends State<TripRouteScreen> {
  var start_currentPostion;
  var end_currentPostion;
  BitmapDescriptor pinLocationIcon;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  var speeding = {'Items': []};
  var braking = {'Items': []};
  var acceleration = {'Items': []};
  var comering = {'Items': []};
  String ApiToken = "";
  bool loading = true;
  Map<MarkerId, Marker> setmarkers = {};
  List listMarkerIds = List(); // For store data of your markers

  @override
  void initState() {
    super.initState();

    getToken();
  }

  getToken() async {
    var url = 'http://api.igiinsurance.com.pk:8888/drive_api/get_token.php';
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);
    if (data['status'].toString() == "success") {
      ApiToken = data['token'];
      getPointers();
    }
  }

  getPointers() async {
    var startDate = DateTime.parse(widget.data["dateStart"].toString());
    var endDate = DateTime.parse(widget.data["dateEnd"].toString());
    print(startDate);
    print(endDate);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String startDate2 =
        formatter.format(startDate.add(Duration(days: 1)));
    final String endDate2 = formatter.format(endDate);

    print(startDate2);
    print(endDate2);

    final storage = new FlutterSecureStorage();

    String asset_id = await storage.read(key: "asset_id");
    var url = 'http://api.igiinsurance.com.pk:8888/drive_api/get_token.php';
    //print(url);
    http.Response res = await http.get(
      Uri.parse('https://api.eu1.kt1.io/fleet/v2/data/history/telemetry/${asset_id}?start=${endDate2}&end=${startDate2}')
      ,
      headers: <String, String>{'x-access-token': ApiToken},
    );
    var data = json.decode(res.body.toString());
    print(data);
    for (var item in data['items']) {
      var itemDate = DateTime.parse(item["date"].toString());

      if (itemDate.compareTo(startDate) > 0 &&
          itemDate.compareTo(endDate) < 0) {
        print('avail');
        polylineCoordinates
            .add(LatLng(item['location']['lat'], item['location']['lon']));
      }
    }
    setCustomMapPin();
    working();
    setState(() {
      loading = false;
    });
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'images/pin.png');
  }

  addPolyLine() {
    print(polylineCoordinates);
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Color(0xff01a8dd),
        width: 3,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  working() async {
    print('asda');
    print(widget.data);
    print(eventList.eventListData);
    var startDate = DateTime.parse(widget.data["dateStart"].toString());
    var endDate = DateTime.parse(widget.data["dateEnd"].toString());
    print('startDate ${startDate}');

    print('endDate ${endDate}');

    for (var item in eventList.eventListData) {
      var itemDate = DateTime.parse(item["eventDate"].toString());

      if (itemDate.compareTo(startDate) > 0 &&
          itemDate.compareTo(endDate) < 0) {
        print('ya data arha ha ${item}');
        var rndnumber = "";
        var rnd = new Random();
        for (var i = 0; i < 6; i++) {
          rndnumber = rndnumber + rnd.nextInt(9).toString();
        }
        print('event Check ${item['eventType']}');

        print(rndnumber);
        if (item['eventType'].toString() == "harsh_brake") {
          setState(() {
            MarkerId markerId1 = MarkerId(rndnumber.toString());

            listMarkerIds.add(markerId1);

            Marker marker1 = Marker(
              markerId: markerId1,
              position: LatLng(item['details']['telemetry']['location']['lat'],
                  item['details']['telemetry']['location']['lon']),
              // ignore: deprecated_member_use
              icon: BitmapDescriptor.fromAsset("images/greenBig.png"),
            );

            setmarkers[markerId1] =
                marker1; // I Just added here markers on the basis of marker id
          });
        }
        if (item['eventType'].toString() == "start") {
          setState(() {
            MarkerId markerId1 = MarkerId(rndnumber.toString());

            listMarkerIds.add(markerId1);

            Marker marker1 = Marker(
              markerId: markerId1,
              position: LatLng(item['details']['telemetry']['location']['lat'],
                  item['details']['telemetry']['location']['lon']),
              // ignore: deprecated_member_use
              icon: BitmapDescriptor.fromAsset("images/orangeBig.png"),
            );

            setmarkers[markerId1] =
                marker1; // I Just added here markers on the basis of marker id
          });
        }

        if (item['eventType'].toString() == "harsh_accel") {
          setState(() {
            MarkerId markerId1 = MarkerId(rndnumber.toString());

            listMarkerIds.add(markerId1);

            Marker marker1 = Marker(
              markerId: markerId1,
              position: LatLng(item['details']['telemetry']['location']['lat'],
                  item['details']['telemetry']['location']['lon']),
              // ignore: deprecated_member_use
              icon: BitmapDescriptor.fromAsset("images/yellowBig.png"),
            );

            setmarkers[markerId1] =
                marker1; // I Just added here markers on the basis of marker id
          });
        }

        if (item['eventType'].toString() == "harsh_corner") {
          setState(() {
            MarkerId markerId1 = MarkerId(rndnumber.toString());

            listMarkerIds.add(markerId1);

            Marker marker1 = Marker(
              markerId: markerId1,
              position: LatLng(item['details']['telemetry']['location']['lat'],
                  item['details']['telemetry']['location']['lon']),
              // ignore: deprecated_member_use
              icon: BitmapDescriptor.fromAsset("images/blueBig.png"),
            );

            setmarkers[markerId1] =
                marker1; // I Just added here markers on the basis of marker id
          });
        }
      }
    }
    if (widget.data['rating'] != null) {
      if (widget.data['rating']['penalties']?.length > 0) {
        List penalties = widget.data['rating']['penalties'];
        for (Map penalty in penalties) {
          if (penalty['name'] == "Speeding") {
            speeding['Items'].add(penalty);
          }
          if (penalty['name'] == "Braking") {
            braking['Items'].add(penalty);
          }
          if (penalty['name'] == "Acceleration") {
            acceleration['Items'].add(penalty);
          }
          if (penalty['name'] == "Cornering") {
            comering['Items'].add(penalty);
          }
        }
      }
    }

    double start_latitude = widget.data['start']['lat'].toDouble();
    double start_longitude = widget.data['start']['lon'].toDouble();

    double end_latitude = widget.data['end']['lat'].toDouble();
    double end_longitude = widget.data['end']['lon'].toDouble();
    //
    var endtit = widget.data['end']["address"];
    var starttit = widget.data['start']["address"];

    start_currentPostion = LatLng(start_latitude, start_longitude);
    end_currentPostion = LatLng(end_latitude, end_longitude);

    await polylinePoints
        .getRouteBetweenCoordinates(
          'AIzaSyAPlkZn2pdSSIkdAISlFSkNr63Iz6SvUJM',
          PointLatLng(start_latitude, start_longitude), //Starting LATLANG
          PointLatLng(end_latitude, end_longitude), //End LATLANG
          travelMode: TravelMode.driving,
        )
        .then((value) {})
        .then((value) {
      addPolyLine();
    });

    setState(() {
      MarkerId markerId1 = MarkerId("1");
      MarkerId markerId2 = MarkerId("2");

      listMarkerIds.add(markerId1);
      listMarkerIds.add(markerId2);

      Marker marker1 = Marker(
        markerId: markerId1,
        position: LatLng(start_latitude, start_longitude),
        // ignore: deprecated_member_use
        icon:(Platform.isIOS)? BitmapDescriptor.fromAsset("images/map-pin-blue.png"):BitmapDescriptor.fromAsset("images/pin.png"),
        infoWindow: InfoWindow(title: 'TRIP Start', snippet: starttit),
      );

      Marker marker2 = Marker(
        markerId: markerId2,
        position: LatLng(end_latitude, end_longitude),
        // ignore: deprecated_member_use
        icon: (Platform.isIOS)? BitmapDescriptor.fromAsset("images/map-pin-blue.png"):BitmapDescriptor.fromAsset("images/pin.png"), // you can change the color of marker
        infoWindow: InfoWindow(title: 'TRIP END', snippet: endtit),
      );

      setmarkers[markerId1] =
          marker1; // I Just added here markers on the basis of marker id
      setmarkers[markerId2] = marker2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Route Location',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: loading
          ? Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center))
          : Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  polylines: Set<Polyline>.of(polylines.values),

                  initialCameraPosition: CameraPosition(
                    target: start_currentPostion,
                    zoom: 15,
                  ),
                  markers: Set.of(setmarkers.values), // YOUR MARKS IN MAP
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
                        child: Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: Column(
                              children: [
                                Container(
                                  color: Color(0xfff5f6fb),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Safe Driving Feature',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15,
                                          color: Color(0xff8f9ba8)),
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      speeding['Items'].length >
                                                              0
                                                          ? speeding['Items'][0]
                                                                  ['instances']
                                                              .toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize: 22,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: Color(0xffff8300),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            capitalize('Speeding'),
                                            style: TextStyle(
                                                fontFamily: 'PoppinsRegular',
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      braking['Items'].length >
                                                              0
                                                          ? braking['Items'][0]
                                                                  ['instances']
                                                              .toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize: 22,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            capitalize('Breaking'),
                                            style: TextStyle(
                                                fontFamily: 'PoppinsRegular',
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      acceleration['Items']
                                                                  .length >
                                                              0
                                                          ? acceleration['Items']
                                                                      [0]
                                                                  ['instances']
                                                              .toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize: 22,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: Colors.yellow,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            capitalize('Acceleration'),
                                            style: TextStyle(
                                                fontFamily: 'PoppinsRegular',
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Center(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      comering['Items'].length >
                                                              0
                                                          ? comering['Items'][0]
                                                                  ['instances']
                                                              .toString()
                                                          : '0',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'PoppinsRegular',
                                                          fontSize: 22,
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(200),
                                                ),
                                                color: Colors.lightBlueAccent,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            capitalize('Cornering'),
                                            style: TextStyle(
                                                fontFamily: 'PoppinsRegular',
                                                fontSize: 13,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // SizedBox(
                                //   height: MediaQuery.of(context).size.height * 0.01,
                                // ),
                                // Row(
                                //   children: [
                                //     SizedBox(
                                //       width:
                                //           MediaQuery.of(context).size.width * 0.02,
                                //     ),
                                //     SizedBox(
                                //       width:
                                //           MediaQuery.of(context).size.width * 0.02,
                                //     ),
                                //     Container(
                                //         child: Image.asset('images/Oval.png')),
                                //     SizedBox(
                                //       width:
                                //           MediaQuery.of(context).size.width * 0.02,
                                //     ),
                                //     Text(
                                //       'ASDAS',
                                //       style: TextStyle(
                                //           fontFamily: 'PoppinsRegular',
                                //           fontSize: 14,
                                //           color: Colors.black54),
                                //     )
                                //   ],
                                // )
                              ],
                            ))),
                      ),
                    ))
              ],
            ),
    );
  }
}
