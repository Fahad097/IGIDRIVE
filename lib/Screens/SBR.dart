import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SbrScreen extends StatefulWidget {
  @override
  _SbrScreenState createState() => _SbrScreenState();
}

class _SbrScreenState extends State<SbrScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String rating1 = "";
    String rating2 = "";
    String rating3 = "";
    String rating4 = "";
    String rating5 = "";
    String rating6 = "";

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
                'Security Briefing Call Survey',
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
                  Row(
                    children: [
                      Text('1.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Text(
                        'Did the customer services officer Greet you well?',
                        style: TextStyle(
                            fontFamily: 'PoppinsRegular',
                            color: Colors.black,
                            fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('2.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          'Did the customer services officer handle you win professionalism?',
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
                      rating2 = rating.toInt().toString();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('3.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          'Did the customer services officer provide all the information which was asked by you?',
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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

                      rating3 = rating.toInt().toString();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('4.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          'How was your overall experience with the security briefing call?',
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
                      rating4 = rating.toInt().toString();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('5.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          'Was the customer service officer equipped with required knowledge?',
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
                      rating5 = rating.toInt().toString();
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('6.',
                          style: TextStyle(
                              fontFamily: 'PoppinsMedium',
                              color: Colors.black,
                              fontSize: 14)),
                      SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          'Was the customer services officer courteous during the call?',
                          style: TextStyle(
                              fontFamily: 'PoppinsRegular',
                              color: Colors.black,
                              fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
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
                      rating6 = rating.toInt().toString();
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
                  child: Text('What did you like  *',
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

                  if (rating1 == "" ||
                      rating2 == "" ||
                      rating3 == "" ||
                      rating4 == "" ||
                      rating5 == "" ||
                      rating6 == "") {
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
                        'http://api.igiinsurance.com.pk:8888/drive_api/feedback_sbc.php?email=${userEmail}&question_1=${rating1}&question_2=${rating2}&question_3=${rating3}&question_4=${rating4}&question_5=${rating5}&question_6=${rating6}&comments=${comments}';
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
