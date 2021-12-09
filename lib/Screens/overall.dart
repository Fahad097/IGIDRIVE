import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Overall extends StatefulWidget {
  @override
  _OverallState createState() => _OverallState();
}

class _OverallState extends State<Overall> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String rating1 = "";
    String rating2 = "";
    String rating3 = "";
    String rating4 = "";
    String comments = "";

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
          'Customer Feedback',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Rate your Experience',
                style: TextStyle(
                    fontFamily: 'PoppinsMedium',
                    color: Colors.black,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Tell us how was your experience with our mobile app',
                    style: TextStyle(
                        fontFamily: 'PoppinsRegular',
                        color: Colors.blueGrey,
                        fontSize: 14, ),
                  ),
                  SizedBox(
                    height: 13,
                  ),
                  RatingBar.builder(
                    initialRating: 1,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 7.0),
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return Icon(
                            Icons.sentiment_very_dissatisfied,
                            color: Colors.amber,
                          );
                        case 1:
                          return Icon(
                            Icons.sentiment_dissatisfied,
                            color: Colors.amber,
                          );
                        case 2:
                          return Icon(
                            Icons.sentiment_neutral,
                            color: Colors.amber,
                          );
                        case 3:
                          return Icon(
                            Icons.sentiment_satisfied,
                            color: Colors.amber,
                          );
                        case 4:
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.amber,
                          );
                      }
                    },
                    onRatingUpdate: (rating) {
                      print(rating);
                      rating1 = rating.toInt().toString();
                    },
                  )
                ],
              ),
            ),

            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text('Comments *',
                      style: TextStyle(
                        fontFamily: 'PoppinsMedium',
                        color: Color(0xff01a8dd),
                        fontSize: 18,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: width * 0.8,
              child: TextFormField(
                  onChanged: (value) {
                    comments = value;
                  },
                  decoration: new InputDecoration(hintText: "Response")),
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: GestureDetector(
                onTap: () async {
                  final storage = new FlutterSecureStorage();

                  String userEmail = await storage.read(key: "userEmail");
                  print(userEmail);
                  print('asda');
                  print('rating1 ${rating1}');
                  print('rating2 ${rating2}');
                  print('rating3 ${rating3}');
                  print('rating4 ${rating4}');

                  if (rating1 == "") {
                    Fluttertoast.showToast(
                        msg: "Please select rating.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Color(0xff01a8dd),
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    var url =
                        'http://api.igiinsurance.com.pk:8888/drive_api/feedback_installation.php?email=${userEmail}&question_1=${rating1}&question_2=${rating2}&question_3=${rating3}&question_4=${rating4}&comments=${comments}';
                    print(url);
                    http.Response res = await http.get(
                      Uri.parse(url),
                      headers: <String, String>{
                        'token': 'c66026133e80d4960f0a5b7d418a4d08'
                      },
                    );
                    var data = json.decode(res.body.toString());
                    print(data);
                    if (data['status'].toString() == "success") {
                      Fluttertoast.showToast(
                          msg: "Thanks for your time.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Color(0xff01a8dd),
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context);
                    }
                  }
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
         SizedBox(
              height: 15,
            ),
         
          ],
        ),
      ),
    );
  }
}
