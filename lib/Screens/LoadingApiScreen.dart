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

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  String ApiToken = "";
  bool eventDataLoaded = false;
  bool tripDataLoaded = false;
  var speeding = {'Items': []};
  var tripresponses = <Future<http.Response>>[];

  var responses = <Future<http.Response>>[];
  var acceleration = {'Items': []};
  var con = {'Items': []};
  var breaking = {'Items': []};
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers;
  bool loading = true;
  var currentPostion;
  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  bool showLoading = true;
  final storage = new FlutterSecureStorage();

  double b5;
  double c5;
  int d5;
  double e5;
  int f5;
  double g5;
  int h5;
  double i5;
  int j5;
  double k5;
  double l5;
  double m5;
  double n5;
  double o5;
  double p5;
  double q5;
  double r5;
  double s5;
  double t5;
  double u5;
  double v5;
  double w5;
  double x5;
  double y5;
  double z5;
  List<String> urlListEvent = [];
  List<String> urlListTrip = [];
  Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers = Set<Marker>();
    getNot();

    getToken();
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getImi2());
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  getToken() async {
    eventList.eventListData.clear();
    tripList.tripListData.clear();
    NottList.notListData.clear();
    final storage = new FlutterSecureStorage();

    String usernumber_ = await storage.read(key: "userNumber");
    String userpassword_ = await storage.read(key: "userPassword");
    //print('username ${usernumber_}');
    //print('username ${userpassword_}');

    var url = 'http://api.igiinsurance.com.pk:8888/drive_api/get_token_v2.php';
    ////print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'token': 'c66026133e80d4960f0a5b7d418a4d08',
        'number': usernumber_,
        'password': userpassword_
      },
    );
    var data = json.decode(res.body.toString());
    //print('data ya ha ${data}');
    if (data['status'].toString() == "success") {
      ApiToken = data['token'];
      // getImi();
      // getAllTrip();
checkDataLoaded();
    }
    if (data['status'].toString() == "Invalid Password") {
      final storage = new FlutterSecureStorage();

      await storage.write(key: 'checkLogin', value: 'NiHuava');

      storage.write(key: 'checkLogin', value: 'NiHuava');
      await storage.write(key: 'checkBio', value: 'nilagihueha');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      Fluttertoast.showToast(
          msg: "Password is expired.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xff01a8dd),
          textColor: Colors.white,
          fontSize: 16.0);
    }
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


  checkDataLoaded() async {
      print('start');
      print(tripList.tripListData.length);
      print(eventList.eventListData.length);
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
        //print(data);
        overallRating = data['over_all_rating'].toDouble();
        speedRating = data['over_speed_rating'].toDouble();
        breakRating = data['harsh_braking_rating'].toDouble();
        corneringRating = data['harsh_conering_rating'].toDouble();
        accelerationRating = data['harsh_accleration_rating'].toDouble();

        Timer(Duration(seconds: 1), () async {
                  Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));

          // setState(() {
          //   showLoading = false;
          // });
        });
      }

      // if (tripList.tripListData.length != 0) {
      //   ////print('Data Loaded Completed');
      //   //print('Data ha ');

      //   List itemList = tripList.tripListData;

      //   for (Map item in itemList) {
      //     Map rating = item['rating'];

      //     if (rating != null) {
      //       if (rating['penalties']?.length > 0) {
      //         //print('sss');
      //         List penalties = rating['penalties'];
      //         for (Map penalty in penalties) {
      //           if (penalty['name'].toString() == 'Speeding') {
      //             //print(item);
      //             speeding['Items'].add(item);
      //           }
      //           if (penalty['name'].toString() == 'Braking') {
      //             //print(item);
      //             breaking['Items'].add(item);
      //           }
      //           if (penalty['name'].toString() == 'Acceleration') {
      //             //print(item);
      //             acceleration['Items'].add(item);
      //           }
      //           if (penalty['name'].toString() == 'Cornering') {
      //             //print(item);
      //             con['Items'].add(item);
      //           }
      //         }
      //       }
      //     }
      //   }

      //   int eventSpeed = speeding['Items'].length;
      //   int eventBreaking = breaking['Items'].length;
      //   int eventAcceleration = acceleration['Items'].length;
      //   int eventCon = con['Items'].length;

      //   //print(eventSpeed);
      //   //print(eventBreaking);
      //   //print(eventAcceleration);
      //   //print(eventCon);
      //   var total = 0.0;
      //   b5;
      //   tripList.tripListData.forEach((i) {
      //     b5 = total += i['stats']['distance'];
      //   });
      //   //print(b5);

      //   var url =
      //       'http://api.igiinsurance.com.pk:8888/drive_api/dashboard.php?distance=${b5}&braking=${eventBreaking}&speeding=${eventSpeed}&accleration=${eventAcceleration}&conering=${eventCon}';
      //   //print(url);
      //   http.Response res = await http.get(
      //     Uri.parse(url),
      //     headers: <String, String>{
      //       'token': 'c66026133e80d4960f0a5b7d418a4d08'
      //     },
      //   );
      //   //print(res.body);

      //   //print(res.statusCode);
      //   var data = json.decode(res.body.toString());
      //   //print(data);
      //   if (data['status'].toString() == "success") {
      //     //print(data);
      //     overallRating = data['over_all_rating'].toDouble();
      //     speedRating = data['over_speed_rating'].toDouble();
      //     breakRating = data['harsh_braking_rating'].toDouble();
      //     corneringRating = data['harsh_conering_rating'].toDouble();
      //     accelerationRating = data['harsh_accleration_rating'].toDouble();

      //           Timer(Duration(seconds: 1), () async {
      //             setState(() {
      //       showLoading = false;
      //     });
      //           });

      //   }

      //   //
      //   // Navigator.of(context).pushReplacement(
      //   //     MaterialPageRoute(builder: (BuildContext context) => HomePage()));

      // }
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
         
          // leading: GestureDetector(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: Icon(Icons.arrow_back, color: Color(0xff01a8dd),)),
          centerTitle: true,

          backgroundColor: Colors.white,
          elevation: 1,
          title: Text(
            'IGI DRIVE',
            style:
                TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
          ),
        ),
        body: Center(
                child: SpinKitWave(
                    color: Color(0xff01a8dd), type: SpinKitWaveType.center)));
  }
}
