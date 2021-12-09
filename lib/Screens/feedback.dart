import 'package:flutter/material.dart';

import 'SBR.dart';
import 'installationSurvey.dart';
import 'overall.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
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
          'FeedBack',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    SizedBox(width: width * 0.025,),
                    Container(
                      child: Icon(Icons.track_changes_outlined, color:  Color(0xff01a8dd),),

                    ),
                    SizedBox(width: 20,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InstallationSurvey()),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tracker Installation Survey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17, fontFamily: 'PoppinsRegular'),
                          ),
                          SizedBox(height: height * 0.007,),
                          Text(
                            'Feedback Questions',
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15,
                                color: Color(0xff8f9ba8)),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SbrScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20 ),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.025,),
                      Container(
                        child: Icon(Icons.phone_outlined, color:  Color(0xff01a8dd),),

                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security Briefing Call survey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17, fontFamily: 'PoppinsRegular'),
                          ),
                          SizedBox(height: height * 0.007,),
                          Text(
                            'Feedback Questions',
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15,
                                color: Color(0xff8f9ba8)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Overall()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, ),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.025,),
                      Container(
                        child: Icon(Icons.messenger_outline, color:  Color(0xff01a8dd),),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Overall Feedback',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 17, fontFamily: 'PoppinsRegular'),
                          ),
                          SizedBox(height: height * 0.007,),
                          Text(
                            'Questions',
                            style: TextStyle(
                                fontFamily: 'PoppinsRegular',
                                fontSize: 15,
                                color: Color(0xff8f9ba8)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
