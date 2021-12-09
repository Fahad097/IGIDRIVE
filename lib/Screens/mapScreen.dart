import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers;
  bool loading = true;
  var currentPostion;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  String ApiToken = "";
Timer timer;

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>();

    getToken();
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getImi());

  }
@override
void dispose() {
  timer?.cancel();
  super.dispose();
}
  getToken() async {
    var url = 'http://api.igiinsurance.com.pk:8888/drive_api/get_token.php';
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    //print(data);
    if (data['status'].toString() == "success") {
      ApiToken = data['token'];
      getImi();
    }
  }
  getImi() async {
    print('run');
    final storage = new FlutterSecureStorage();

    String asset_id = await storage.read(key: "asset_id");
    //print('showimi');
    //print(asset_id);

    var map = new Map<String, dynamic>();

    var url =
        'https://api.eu1.kt1.io/fleet/v2/entities/assets/${asset_id}/location';
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'x-access-token': ApiToken},
    );
    var data = json.decode(res.body.toString());
    //print(data);

 if(data != null){
      if (data['origin']['id'].toString().length > 1) {
      //print(data["location"]["lon"]);
      //print(data["location"]["gc"]["rd"]);
      //print(data["location"]["gc"]["sb"]);

      var tit = data["location"]["gc"]["rd"];
      var snip = data["location"]["gc"]["sb"];

      //print(data["location"]['lon']);
      //print(data["location"]['lat']);
      double latitude = data["location"]['lat'].toDouble();
      double longitude = data["location"]['lon'].toDouble();

      //print(longitude);
      currentPostion = LatLng(latitude, longitude);
      //print(currentPostion);

      final Map<String, Marker> _markers = {};
      String url = 'http://maps.google.com/maps?q=${latitude},${longitude}';
      if (data["telemetry"]["ignition"] == 1 &&
          data["telemetry"]["moving"] == 1) {
        //print('gari chal rhe ha ');

        setState(() {
          final MarkerId markerId = MarkerId('1');

          // creating a new MARKER
          final Marker marker = Marker(
              markerId: markerId,
              // ignore: deprecated_member_use

              icon: Platform.isAndroid
                  // ignore: deprecated_member_use
                  ? BitmapDescriptor.fromAsset("images/map-pin-green@2x.png")
                  // ignore: deprecated_member_use
                  : BitmapDescriptor.fromAsset("images/map-pin-green.png"),
              position: currentPostion,
              infoWindow: InfoWindow(title: tit, snippet: snip),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return new Container(
                        height: 200.0,
                        color: Colors
                            .transparent, //could change this to Color(0xFF737373),
                        //so you don't have to change MaterialApp canvasColor
                        child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0))),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Color(0xfff5f6fb),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Car Status',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15,
                                          color: Color(0xff8f9ba8)),
                                    )),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Material(
                                            color: Color(
                                                0xff01a8dd), // button color
                                            child: InkWell(
                                              splashColor: Color(
                                                  0xff01a8dd), // inkwell color
                                              child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(
                                                    Icons
                                                        .directions_car_outlined,
                                                    color: Colors.white,
                                                    size: 23,
                                                  )),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Car Moving',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuBold'),
                                            ),
                                            Text(
                                              '    ${data["location"]["gc"]["sb"]}',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuRegular'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Share.share(
                                      'My Car Location\n ${url}',
                                      subject: 'My Car Location',
                                    );
                                    // launch(url);
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xff01a8dd),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Share',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'UbuntuRegular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )),
                                  ),
                                )
                              ],
                            )),
                      );
                    });
              });

          setState(() {
            // adding a new marker to map
            markers[markerId] = marker;
          });
          setState(() {
            loading = false;
          });
        });
      }
      if (data["telemetry"]["ignition"] == 0 &&
          data["telemetry"]["moving"] == 0) {
        //print('gari parked ha');

        setState(() {
          final MarkerId markerId = MarkerId('1');

          // creating a new MARKER
          final Marker marker = Marker(
              markerId: markerId,
              // ignore: deprecated_member_use
              icon: Platform.isAndroid
                  ? BitmapDescriptor.fromAsset("images/pin.png")
                  : BitmapDescriptor.fromAsset("images/map-pin-blue.png"),
              position: currentPostion,
              infoWindow: InfoWindow(title: tit, snippet: snip),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return new Container(
                        height: 200.0,
                        color: Colors
                            .transparent, //could change this to Color(0xFF737373),
                        //so you don't have to change MaterialApp canvasColor
                        child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0))),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Color(0xfff5f6fb),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Car Status',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15,
                                          color: Color(0xff8f9ba8)),
                                    )),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Material(
                                            color: Color(
                                                0xff01a8dd), // button color
                                            child: InkWell(
                                              splashColor: Color(
                                                  0xff01a8dd), // inkwell color
                                              child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(
                                                    Icons
                                                        .directions_car_outlined,
                                                    color: Colors.white,
                                                    size: 23,
                                                  )),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Parked Car',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuBold'),
                                            ),
                                            Text(
                                              '    ${data["location"]["gc"]["sb"]}',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuRegular'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Share.share(
                                      'My Car Location\n ${url}',
                                      subject: 'My Car Location',
                                    );
                                    // launch(url);
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xff01a8dd),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Share',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'UbuntuRegular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )),
                                  ),
                                )
                              ],
                            )),
                      );
                    });
              });

          setState(() {
            // adding a new marker to map
            markers[markerId] = marker;
          });
          setState(() {
            loading = false;
          });
        });
      }
      if (data["telemetry"]["ignition"] == 1 &&
          data["telemetry"]["moving"] == 0) {
        //print('gari ruke hue ha');
        setState(() {
          final MarkerId markerId = MarkerId('1');

          // creating a new MARKER
          final Marker marker = Marker(
              markerId: markerId,
              // ignore: deprecated_member_use

              // ignore: deprecated_member_use
              icon: Platform.isAndroid
                  ? BitmapDescriptor.fromAsset("images/map-pin-orange@2x.png")
                  : BitmapDescriptor.fromAsset("images/map-pin-orange.png"),
              position: currentPostion,
              infoWindow: InfoWindow(title: tit, snippet: snip),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) {
                      return new Container(
                        height: 200.0,
                        color: Colors
                            .transparent, //could change this to Color(0xFF737373),
                        //so you don't have to change MaterialApp canvasColor
                        child: new Container(
                            decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    topRight: const Radius.circular(10.0))),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: Color(0xfff5f6fb),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                        child: Text(
                                      'Car Status',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15,
                                          color: Color(0xff8f9ba8)),
                                    )),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: Material(
                                            color: Color(
                                                0xff01a8dd), // button color
                                            child: InkWell(
                                              splashColor: Color(
                                                  0xff01a8dd), // inkwell color
                                              child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child: Icon(
                                                    Icons
                                                        .directions_car_outlined,
                                                    color: Colors.white,
                                                    size: 23,
                                                  )),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Car Stop',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuBold'),
                                            ),
                                            Text(
                                              '    ${data["location"]["gc"]["sb"]}',
                                              style: TextStyle(
                                                  fontFamily: 'UbuntuRegular'),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Share.share(
                                      'My Car Location\n ${url}',
                                      subject: 'My Car Location',
                                    );
                                    // launch(url);
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Color(0xff01a8dd),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.share_outlined,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Share',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'UbuntuRegular',
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    )),
                                  ),
                                )
                              ],
                            )),
                      );
                    });
              });

          setState(() {
            // adding a new marker to map
            markers[markerId] = marker;
          });
          setState(() {
            loading = false;
          });
        });
      }
    }
 }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

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
            'My Car Location',
            style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
          ),
        ),
        body: loading == false
            ? GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target:
                        loading == false ? currentPostion : LatLng(1.0, 1.0),
                    zoom: 18,
                    tilt: 50),
                markers: Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
              )
            : Center(
                child: SpinKitWave(
                    color: Color(0xff01a8dd), type: SpinKitWaveType.center)));
  }
}
