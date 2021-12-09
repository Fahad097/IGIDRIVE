import 'dart:convert';

import 'package:IGI_Drive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class ZoneCrossingForm extends StatefulWidget {
  @override
  _ZoneCrossingFormState createState() => _ZoneCrossingFormState();
}

class _ZoneCrossingFormState extends State<ZoneCrossingForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController destination = new TextEditingController();
  final TextEditingController route = new TextEditingController();

  final TextEditingController toDate = new TextEditingController();
  final TextEditingController fromDate = new TextEditingController();

  DateTime apiToDate;
  DateTime apiFromDate;

  String vechilename = "";
  String usernumber_ = "";
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    getVechile();
  }

  _toDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xff01a8dd),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xff01a8dd),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        toDate.text = picked.toString();
      });
  }

  _FromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xff01a8dd),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xff01a8dd),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child,
        );
      },
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        fromDate.text = picked.toString();
      });
  }

  getVechile() async {
    final storage = new FlutterSecureStorage();

    String imi = await storage.read(key: "imei");
    print('showimi');
    print(imi);

    var url =
        'http://api.igiinsurance.com.pk:8888/drive_api/vehicle_select.php?imei=${imi}';
    print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center));
        });

    if (data['status'].toString() == "success") {
      print('donedanadone');

           usernumber_ = await storage.read(key: "userNumber");

      setState(() {
        vechilename = data['vehicle'].toString();
      });

      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _trySubmit() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      if (isValid) {
        print(destination.text);
        print(route.text);

        print(toDate.text);
        print(fromDate.text);

        print(vechilename);

        var url =
            'http://api.igiinsurance.com.pk:8888/drive_api/zone_crossing.php?vehicle=${vechilename}&route=${route.text}&designation=${destination.text}&from_date=${fromDate.text}&to_date=${toDate.text}';
        print(url);
        http.Response res = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'token': 'c66026133e80d4960f0a5b7d418a4d08'
          },
        );
        var data = json.decode(res.body.toString());
        print(data);
        print(data['status']);
        if (data['status'].toString() == "success") {
          print('ok');
          //  Navigator.pop(context);

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        }
      } else {
        print('not valid');
      }
    }

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
          'Zone Crossing',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.1,
                ),
                Image.asset(
                  'images/zone-crossing-screen-icon@3x.png',
                  height: height * 0.06,
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Container(
                  child: Text(
                    'Zone Crossing',
                    style: TextStyle(
                      fontFamily: 'PoppinsMedium',
                      color: Colors.grey[700],
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          vechilename,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          usernumber_,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Colors.grey[700],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              
                SizedBox(
                  height: height * 0.07,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text('Destination *',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xff01a8dd),
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: destination,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text('Route *',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xff01a8dd),
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: route,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text('To Date *',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xff01a8dd),
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: toDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          Icons.calendar_today_outlined,
                        ),
                        onPressed: () {
                          _toDate(context);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text('From Date *',
                          style: TextStyle(
                            fontFamily: 'PoppinsMedium',
                            color: Color(0xff01a8dd),
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.8,
                  child: TextFormField(
                    controller: fromDate,
                    readOnly: true,
                    decoration: InputDecoration(
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          Icons.calendar_today_outlined,
                        ),
                        onPressed: () {
                          _FromDate(context);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please fill this field.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      print('asda');
                      _trySubmit();
                    },
                    child: Container(
                      height: height * 0.07,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              const Color(0xff01a8dd),
                              const Color(0xff01a8dd),
                            ],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      child: Center(
                          child: Text(
                        'SUBMIT',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsRegular',
                            color: Colors.white),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
