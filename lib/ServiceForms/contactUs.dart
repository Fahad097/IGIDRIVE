import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactusSCreen extends StatefulWidget {
  @override
  _ContactusSCreenState createState() => _ContactusSCreenState();
}

class _ContactusSCreenState extends State<ContactusSCreen> {
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
          'Contact Us',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),      body: Column(
        children: [
          GestureDetector(
            onTap: () async{
              final storage = new FlutterSecureStorage();

              String imi = await storage.read(key: "imei");
              String email = await storage.read(key: "imei");
              String userNumber = await storage.read(key: "userNumber");
              String userName = await storage.read(key: "userName");

              final Uri _emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'contactus.igidrive@igi.com.pk',
                  query: 'subject=IGIDRIVE - ${userName} - ${userNumber}'

              );
              launch(_emailLaunchUri.toString());

            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      SizedBox(width: width * 0.025,),
                      Container(
                        child: Image.asset(
                          'images/contact-us-icon-sc@3x.png',
                          height: height * 0.03,
                        ),
                      ),
                      SizedBox(width: 20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'contactus.igidrive@igi.com.pk',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15, fontFamily: 'PoppinsRegular'),
                          ),
                          SizedBox(height: height * 0.007,),
                          Text(
                            'General queries & Complaints',
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
          ],
      ),
    );
  }
}
