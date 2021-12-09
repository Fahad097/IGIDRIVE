import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsMapScreen extends StatefulWidget {
  final data;
  const EventDetailsMapScreen({Key key, @required this.data}) : super(key: key);

  @override
  _EventDetailsMapScreenState createState() => _EventDetailsMapScreenState();
}

class _EventDetailsMapScreenState extends State<EventDetailsMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers;
  bool loading = true;
  String eventTypeset = "";
  var currentPostion;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void initState() {
    super.initState();
    _markers = Set<Marker>();

    getImi();
  }

  getImi() async {
    print(widget.data['eventType']);
    if(widget.data['eventType'] == "start"){
      eventTypeset = "Over Speeding";
    }
    else
    if(widget.data['eventType'] == "harsh_brake"){
      eventTypeset = "Harsh Breaking";
    }
    else
    if(widget.data['eventType'] == "harsh_accel"){
      eventTypeset = "Harsh Acceleration";
    }    else
    if(widget.data['eventType'] == "harsh_corner"){
      eventTypeset = "Harsh Corner";
    }
    else{
       eventTypeset = widget.data['eventType'];
    }


    print(widget.data);
    print(widget.data['details']['telemetry']['location']['lon']);
    print(widget.data['details']['telemetry']['location']['lat']);

    var tit = widget.data['details']['telemetry']["location"]["gc"]["rd"];
    var snip = widget.data['details']['telemetry']["location"]["gc"]["sb"];

    double latitude =
        widget.data['details']['telemetry']['location']['lat'].toDouble();
    double longitude =
        widget.data['details']['telemetry']['location']['lon'].toDouble();

    print(longitude);

    currentPostion = LatLng(latitude, longitude);
    print(currentPostion);

    final Map<String, Marker> _markers = {};

    setState(() {
      final MarkerId markerId = MarkerId('1');

      // creating a new MARKER
      final Marker marker = Marker(
        markerId: markerId,
        // ignore: deprecated_member_use
        // icon: BitmapDescriptor.fromAsset("images/Oval Copy 7@2x.png"),
        // ignore: deprecated_member_use
        icon: BitmapDescriptor.fromAsset("images/Oval-Copy-7@3x.png"),

        position: currentPostion,
        // infoWindow: InfoWindow(title: tit, snippet: snip),
          onTap: (){
            widget.data['eventType'].toString() == "start" ? showModalBottomSheet(
                context: context,
                builder: (builder){
                  String a = widget.data['details']['telemetry']['telemetry']['overspeed'].toString();
                  List<String> parts = a.split(">");
                  return new Container(
                    height: 200.0,
                    color: Colors.transparent, //could change this to Color(0xFF737373),
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
                                      'Event Details',
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
                                        color:
                                        Color(0xff01a8dd), // button color
                                        child: InkWell(
                                          splashColor: Color(
                                              0xff01a8dd), // inkwell color
                                          child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Icon(
                                                Icons.directions_car_outlined,
                                                color: Colors.white,
                                                size: 23,
                                              )),
                                          onTap: () {},
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),

                                    Column(
                                      children: [
                                        Text('Time', style: TextStyle(fontFamily: 'UbuntuBold'),),
                                        Text('    9:02 AM', style: TextStyle(fontFamily: 'UbuntuRegular'),)
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),

                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Color(0xff01a8dd))

                                        ),
                                      child:Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          children: [
                                            Text('Speed Limit', style: TextStyle(fontFamily: 'UbuntuBold'),),
                                            Text(parts[1], style: TextStyle(fontFamily: 'UbuntuRegular'),),
                                          ],
                                        ),
                                      )
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Color(0xff01a8dd))

                                        ),
                                        child:Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: [
                                              Text('Your Speed', style: TextStyle(fontFamily: 'UbuntuBold'),),
                                              Text(parts[0], style: TextStyle(fontFamily: 'UbuntuRegular'),),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            )

                          ],
                        )),
                  );
                }
            ) : null;
          }
      );

      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
      });
      loading = false;
    });
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
            'Event Location',
            style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
          ),
        ),        body: loading == false
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                        target: loading == false
                            ? currentPostion
                            : LatLng(1.0, 1.0),
                        zoom: 18,
                        tilt: 50),
                    markers:
                        Set<Marker>.of(markers.values), // YOUR MARKS IN MAP
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 15.0),
                          child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.25,
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
                                        'EVENT SUMMARY',
                                        style: TextStyle(
                                            fontFamily: 'PoppinsRegular',
                                            fontSize: 15,
                                            color: Color(0xff8f9ba8)),
                                      )),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.08,
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "01",
                                              style: TextStyle(
                                                  fontFamily: 'PoppinsRegular',
                                                  fontSize: 22,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
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
                                    capitalize(eventTypeset),
                                    style: TextStyle(
                                        fontFamily: 'PoppinsRegular',
                                        fontSize: 16,
                                        color: Colors.black54),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Container(
                                          child:
                                              Image.asset('images/Oval.png')),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Flexible(
                                        child: Text(
                                          widget.data['details']['telemetry']
                                              ['location']['address'],
                                          style: TextStyle(
                                              fontFamily: 'PoppinsRegular',
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ))),
                        ),
                      ))
                ],
              )
            : Center(
                child: SpinKitWave(
                    color: Color(0xff01a8dd), type: SpinKitWaveType.center)));
  }
}