import 'package:IGI_Drive/Screens/pdfView.dart';
import 'package:IGI_Drive/ServiceForms/batteryForm.dart';
import 'package:IGI_Drive/ServiceForms/contactUs.dart';
import 'package:IGI_Drive/ServiceForms/removalForm.dart';
import 'package:IGI_Drive/ServiceForms/requestForm.dart';
import 'package:IGI_Drive/ServiceForms/servicereqForm.dart';
import 'package:IGI_Drive/ServiceForms/zoneCrossing.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceCenter extends StatefulWidget {
  @override
  _ServiceCenterState createState() => _ServiceCenterState();
}

class _ServiceCenterState extends State<ServiceCenter> {

    Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ZoneCrossingForm()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/zone-crossing-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Zone',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                        Text(
                          'Crossing',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RemovalForm()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/request-removal-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Request',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                        Text(
                          'for removal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BatteryForm()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/preinform-battery-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Pre-inform',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                        Text(
                          'battery-tamper',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestForm()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/request-for-updates-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Request',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                        Text(
                          'Updates',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ServiceRequestForm()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/other-services-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Other',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                        Text(
                          'Service Request',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {

                    _launchInBrowser("http://api.igiinsurance.com.pk:8888/drive_api/faqs.pdf");

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => PdfView(
                    //           url:
                    //           "http://api.igiinsurance.com.pk:8888/drive_api/faqs.pdf")),
                    // );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/request-removal-screen-icon@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'FAQ\'s',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   width: width * 0.4,
                //   height: height * 0.2,
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.1),
                //         spreadRadius: 3,
                //         blurRadius: 5,
                //         offset: Offset(0, 3), // changes position of shadow
                //       ),
                //     ],
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(10),
                //         topRight: Radius.circular(10),
                //         bottomLeft: Radius.circular(10),
                //         bottomRight: Radius.circular(10)),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         'images/Rewards-smoth@3x.png',
                //         height: height * 0.045,
                //       ),
                //       SizedBox(
                //         height: height * 0.01,
                //       ),
                //       Text(
                //         'Rate Us',
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 16, fontFamily: 'PoppinsRegular'),
                //       ),
                //     ],
                //   ),
                // ),
                
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactusSCreen()),
                    );
                  },
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/contact-us-icon-sc@3x.png',
                          height: height * 0.045,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          'Contact us',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontFamily: 'PoppinsRegular'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
