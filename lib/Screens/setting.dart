import 'dart:convert';

import 'package:IGI_Drive/Screens/pdfView.dart';
import 'package:IGI_Drive/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AuthScreens/changePassword.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with TickerProviderStateMixin {
  bool _switchValue = false;
  bool _switchValuenight = false;
  bool _switchValueexcessive = false;
  bool _switchValuenogogarea = false;
  bool _switchValuehigh = false;
  bool autoLogin = false;
  bool biometric = false;
  bool showC = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  String _dropDownValue;
  int sortindex;
  List<Map<String, dynamic>> send = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userName = new TextEditingController();
  final TextEditingController userNumber = new TextEditingController();
  bool _shoW = true;
  var items = [];
  @override
  void initState() {
    super.initState();

    getImi();
    getCheckLogin();
    _checkBiometrics();
    _getAvailableBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }


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

  

  getCheckLogin() async {
    final storage = new FlutterSecureStorage();

    String checkLogin = await storage.read(key: "checkLogin");
    String checkBio = await storage.read(key: "checkBio");

    print('checkLogin');
    print(checkLogin);
    if (checkLogin.toString() == "LoginHuavaHa") {
      setState(() {
        autoLogin = true;
      });
    } else {
      setState(() {
        autoLogin = false;
      });
    }

    if (checkBio.toString() == "lagihueha") {
      setState(() {
        biometric = true;
      });
    } else {
      setState(() {
        biometric = false;
      });
    }
  }

  changesImi(data, imei) async {
    print('change');
    print(data);

    final _storage = FlutterSecureStorage();

    await _storage.write(key: 'asset_id', value: data);
    await _storage.write(key: 'imei', value: imei);

    RestartWidget.restartApp(context);
  }

  final SortWidget = <Widget>[]; // Here we defined a list of widget!

  getImi() async {
    final storage = new FlutterSecureStorage();

    String userNumber = await storage.read(key: "userNumber");
    String userPassword = await storage.read(key: "userPassword");

    print('showimi');
    print(userNumber);
    print(userPassword);

    var map = new Map<String, dynamic>();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: SpinKitWave(
                  color: Color(0xff01a8dd), type: SpinKitWaveType.center));
        });

    var url =
        'http://api.igiinsurance.com.pk:8888/drive_api/login.php?number=${userNumber}&password=${userPassword}';
    print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);

    if (data['status'].toString() == "Success") {
      Navigator.pop(context);
      _shoW = true;
      if (data['data'][0]['ignition'].toString() == "1") {
        print('111');
        setState(() {
          _switchValue = true;
        });
      }
      if (data['data'][0]['SVR Night Activity'].toString() == "1") {
        setState(() {
          _switchValuenight = true;
        });
      }
      if (data['data'][0]['Excessive Idling'].toString() == "1") {
        setState(() {
          _switchValueexcessive = true;
        });
      }
      if (data['data'][0]['No Go Area'].toString() == "1") {
        setState(() {
          _switchValuenogogarea = true;
        });
      }
      if (data['data'][0]['High Risk Zone'].toString() == "1") {
        setState(() {
          _switchValuehigh = true;
        });
      }
      data['data'].forEach((row) {
        print(row['imei_number']);

        send.add({
          'imei': row['imei_number'],
          'model': row['vehicle_model'],
          'asset_id': row['asset_id'],
          'register_number': row['register_number'],
        });
        items.add(row['imei_number']);

        print(send);
      });
      for (int i = 0; i < send.length; i++) {
        SortWidget.add(
          GestureDetector(
            onTap: () {
              setState(() {
                // set current index!
                sortindex = i;
                print(sortindex);
                changesImi(send[i]['asset_id'], send[i]['imei']);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                height: 60,
                width: 200,
                decoration: BoxDecoration(
                    color: sortindex == i ? Color(0xff01a8dd) : Colors.white,
                    border: Border.all(
                        color: sortindex == i
                            ? Color(0xff01a8dd)
                            : Colors.grey[500]),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                  send[i]['model'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: sortindex == i ? Colors.white : Colors.grey[500],
                      fontFamily: 'PoppinsRegular'),
                ),
                Text(
                  send[i]['register_number'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13,
                      color: sortindex == i ? Colors.white : Colors.grey[500],
                      fontFamily: 'PoppinsRegular'),
                )

                      ],
                    )),
              ),
            ),
          ),
        );
      }
      setState(() {});
    } else {
      Navigator.pop(context);
      _shoW = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    double Height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xffFCFCFC),
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
          'Settings',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: Container(
        width: double.infinity,
        child: _shoW
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: Height * 0.02,
                    ),
                    RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 14.0,
                          color: Color(0xff01a8dd),
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: 'Select ',
                              style: new TextStyle(
                                  fontSize: 18, fontFamily: 'PoppinsBold')),
                          new TextSpan(
                              text: 'Vehicle',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'PoppinsMedium',
                              )),
                        ],
                      ),
                    ),
                    Column(children: SortWidget),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          height: Height * 0.065,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.departure_board_outlined,
                                      size: 30,
                                      color: Color(0xff01a8dd),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Ignition On/Off',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PoppinsMedium',
                                            color: Colors.grey))
                                  ],
                                ),
                                CupertinoSwitch(
                                  activeColor: Color(0xff01a8dd),
                                  value: _switchValue,
                                  onChanged: (value) async {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return Center(
                                              child: SpinKitWave(
                                                  color: Color(0xff01a8dd),
                                                  type:
                                                      SpinKitWaveType.center));
                                        });
                                    print(value);
                                    final storage = new FlutterSecureStorage();

                                    String imei =
                                        await storage.read(key: "imei");

                                    setState(() {
                                      _switchValue = value;
                                    });
                                    var url =
                                        'http://api.igiinsurance.com.pk:8888/drive_api/setting.php?imei_number=${imei}&ignition=${_switchValue ? '1' : '0'}&night_activity=${_switchValuenight ? '1' : '0'}&idling=0${_switchValueexcessive ? '1' : '0'}&no_go=${_switchValuenogogarea ? '1' : '0'}&high_risk=${_switchValuehigh ? '1' : '0'}';
                                    print(url);
                                    http.Response res = await http.get(
                                      Uri.parse(url),
                                      headers: <String, String>{
                                        'token':
                                            'c66026133e80d4960f0a5b7d418a4d08'
                                      },
                                    );
                                    var data = json.decode(res.body.toString());
                                    print(data);
                                    if (data['status'].toString() ==
                                        "scuucess") {
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg:
                                              "Your Ignition Notification ${_switchValue ? 'ON' : 'OFF'}.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Color(0xff01a8dd),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Navigator.pop(context);
                                      Fluttertoast.showToast(
                                          msg: "Something went wrong.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Color(0xff01a8dd),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          height: Height * 0.065,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.save_outlined,
                                      size: 30,
                                      color: Color(0xff01a8dd),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Auto Save',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PoppinsMedium',
                                            color: Colors.grey))
                                  ],
                                ),
                                CupertinoSwitch(
                                  value: autoLogin,
                                  activeColor: Color(0xff01a8dd),
                                  onChanged: (value) async {
                                    final _storage = new FlutterSecureStorage();

                                    if (value) {
                                      print('login on');
                                      await _storage.write(
                                          key: 'checkLogin',
                                          value: 'LoginHuavaHa');
                                      setState(() {
                                        autoLogin = true;
                                      });
                                    } else {
                                      print('login off');
                                      await _storage.write(
                                          key: 'checkLogin', value: 'NiHuava');
                                      setState(() {
                                        autoLogin = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        child: Container(
                          height: Height * 0.065,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.fingerprint_outlined,
                                      size: 30,
                                      color: Color(0xff01a8dd),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Finger / Face lock',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PoppinsMedium',
                                            color: Colors.grey))
                                  ],
                                ),
                                CupertinoSwitch(
                                  value: biometric,
                                  activeColor: Color(0xff01a8dd),
                                  onChanged: (value) async {
                                    if (value) {
                                      final _storage =
                                          new FlutterSecureStorage();

                                      bool authenticated = false;
                                      try {
                                        setState(() {
                                          _isAuthenticating = true;
                                          _authorized = 'Authenticating';
                                        });
                                        authenticated = await auth
                                            .authenticateWithBiometrics(
                                                localizedReason:
                                                    'Scan your fingerprint to authenticate',
                                                useErrorDialogs: true,
                                                stickyAuth: true);
                                        setState(() {
                                          _isAuthenticating = false;
                                          _authorized = 'Authenticating';
                                        });
                                      } on PlatformException catch (e) {
                                        print(e);
                                      }
                                      if (!mounted) return;

                                      final String message = authenticated
                                          ? 'Authorized'
                                          : 'Not Authorized';
                                      setState(() async {
                                        _authorized = message;
                                        print(_authorized);
                                        if (_authorized.toString() ==
                                            "Authorized") {
                                          await _storage.write(
                                              key: 'checkBio',
                                              value: 'lagihueha');
                                          setState(() {
                                            biometric = true;
                                          });
                                        }
                                      });
                                    } else {
                                      final _storage =
                                          new FlutterSecureStorage();

                                      await _storage.write(
                                          key: 'checkBio',
                                          value: 'nilagihueha');
                                      setState(() {
                                        biometric = false;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            height: Height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.lock_outline,
                                        size: 30,
                                        color: Color(0xff01a8dd),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('Change Passwrod',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: 'PoppinsMedium',
                                              color: Colors.grey))
                                    ],
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(23.0),
                                    topRight: const Radius.circular(23.0))),
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SingleChildScrollView(
                                  child: Container(
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.53,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 13,
                                                                bottom: 5),
                                                        child: Text('Name',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color: Color(0xff01a8dd),
                                                                fontFamily:
                                                                    'PoppinsBold')),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Width * 0.9,
                                                      child: TextFormField(
                                                        key: ValueKey('name'),
                                                        controller: userName,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter name';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {},
                                                        style: TextStyle(
                                                            color: Color(0xff01a8dd),
                                                            fontFamily:
                                                                'PoppinsRegular'),
                                                        decoration:
                                                            new InputDecoration(
                                                          enabledBorder:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(
                                                                        0xffbdbdbd),
                                                                    width: 1),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          border:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width:
                                                                        1.25),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          filled: true,
                                                          hintStyle: new TextStyle(
                                                              color: Color(
                                                                  0xffbdbdbd),
                                                              fontFamily:
                                                                  'PoppinsRegular'),
                                                          hintText:
                                                              "Name of contact person",
                                                          fillColor:
                                                              Colors.white70,
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: Height * 0.01,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 20,
                                                                left: 13,
                                                                bottom: 5),
                                                        child: Text(
                                                            'Emergency Number',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: TextStyle(
                                                              color: Color(0xff01a8dd),
                                                                fontFamily:
                                                                    'PoppinsBold')),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Width * 0.9,
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        key: ValueKey('number'),
                                                        controller: userNumber,
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return 'Please enter number';
                                                          }
                                                          return null;
                                                        },
                                                        onSaved: (value) {},
                                                        style: TextStyle(
                                                            color: Color(0xff01a8dd),
                                                            fontFamily:
                                                                'PoppinsRegular'),
                                                        decoration:
                                                            new InputDecoration(
                                                          enabledBorder:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Color(0xff01a8dd),
                                                                    width: 1),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          border:
                                                              new OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .grey,
                                                                    width:
                                                                        1.25),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                          filled: true,
                                                          hintStyle: new TextStyle(
                                                              color: Color(
                                                                  0xffbdbdbd),
                                                              fontFamily:
                                                                  'PoppinsRegular'),
                                                          hintText:
                                                              "Emergency phone number",
                                                          fillColor:
                                                              Colors.white70,
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide:
                                                                const BorderSide(
                                                                    color: Colors
                                                                        .black,
                                                                    width: 1),
                                                            borderRadius:
                                                                const BorderRadius
                                                                    .all(
                                                              const Radius
                                                                      .circular(
                                                                  10.0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Align(
                                                    //   alignment:
                                                    //   Alignment.centerLeft,
                                                    //   child: Padding(
                                                    //     padding:
                                                    //     const EdgeInsets
                                                    //         .only(
                                                    //         top: 20,
                                                    //         left: 13,
                                                    //         bottom: 5),
                                                    //     child: Text(
                                                    //         'Relation',
                                                    //         textAlign:
                                                    //         TextAlign.left,
                                                    //         style: TextStyle(
                                                    //             color: Color(0xff01a8dd),
                                                    //             fontFamily:
                                                    //             'PoppinsBold')),
                                                    //   ),
                                                    // ),
                                                    //
                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top: 5),
                                                    //   child: Center(
                                                    //     child: Container(
                                                    //       width: Width * 0.9,
                                                    //
                                                    //       child: DropdownButtonFormField(
                                                    //         items: <String>['Relation','Father', 'Brother', 'Mother', 'Sister', 'Wife'].map((String category) {
                                                    //           return new DropdownMenuItem(
                                                    //               value: category,
                                                    //               child: Text(category, style: TextStyle(
                                                    //                   color: Color(0xffbdbdbd),
                                                    //                   fontFamily:
                                                    //                   'UbuntuRegular'),)
                                                    //           );
                                                    //         }).toList(),
                                                    //         onChanged: (newValue) {
                                                    //           // do other stuff with _category
                                                    //         },
                                                    //         value: 'Relation',
                                                    //         decoration:
                                                    //         new InputDecoration(
                                                    //           enabledBorder:
                                                    //           new OutlineInputBorder(
                                                    //             borderSide:
                                                    //             const BorderSide(
                                                    //                 color: Color(0xff01a8dd),
                                                    //                 width: 1),
                                                    //             borderRadius:
                                                    //             const BorderRadius
                                                    //                 .all(
                                                    //               const Radius
                                                    //                   .circular(
                                                    //                   10.0),
                                                    //             ),
                                                    //           ),
                                                    //           border:
                                                    //           new OutlineInputBorder(
                                                    //             borderSide:
                                                    //             const BorderSide(
                                                    //                 color: Colors
                                                    //                     .grey,
                                                    //                 width:
                                                    //                 1.25),
                                                    //             borderRadius:
                                                    //             const BorderRadius
                                                    //                 .all(
                                                    //               const Radius
                                                    //                   .circular(
                                                    //                   10.0),
                                                    //             ),
                                                    //           ),
                                                    //           filled: true,
                                                    //           hintStyle: new TextStyle(
                                                    //               color: Color(
                                                    //                   0xffbdbdbd),
                                                    //               fontFamily:
                                                    //               'PoppinsRegular'),
                                                    //           hintText:
                                                    //           "Emergency phone number",
                                                    //           fillColor:
                                                    //           Colors.white70,
                                                    //           focusedBorder:
                                                    //           OutlineInputBorder(
                                                    //             borderSide:
                                                    //             const BorderSide(
                                                    //                 color: Colors
                                                    //                     .black,
                                                    //                 width: 1),
                                                    //             borderRadius:
                                                    //             const BorderRadius
                                                    //                 .all(
                                                    //               const Radius
                                                    //                   .circular(
                                                    //                   10.0),
                                                    //             ),
                                                    //           ),
                                                    //         ),                                                          ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      height: Height * 0.05,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final _storage =
                                                            FlutterSecureStorage();

                                                        String nmmm =
                                                            await _storage.read(
                                                                key:
                                                                    "userNumber");

                                                        final isValid = _formKey
                                                            .currentState
                                                            .validate();
                                                        if (isValid) {
                                                          print(userName.text
                                                              .toString());
                                                          print(userNumber.text
                                                              .toString());

                                                          showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Center(
                                                                    child: SpinKitWave(
                                                                        color: Color(
                                                                            0xff01a8dd),
                                                                        type: SpinKitWaveType
                                                                            .center));
                                                              });

                                                          var url =
                                                              'http://api.igiinsurance.com.pk:8888/drive_api/primary_contact.php?number=${nmmm}&e_name=${userName.text}&e_relation=unknow&e_number=${userNumber.text}';
                                                          print(url);
                                                          http.Response res =
                                                              await http.get(
                                                            Uri.parse(url),
                                                            headers: <String,
                                                                String>{
                                                              'token':
                                                                  'c66026133e80d4960f0a5b7d418a4d08'
                                                            },
                                                          );
                                                          var data = json
                                                              .decode(res.body
                                                                  .toString());
                                                          print(data);

                                                          if (data['status'] ==
                                                              "success") {
                                                            Navigator.pop(
                                                                context);

                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Emergency contact added.",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff01a8dd),
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Something wrong try again.",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff01a8dd),
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          }
                                                        }
                                                      },
                                                      child: Container(
                                                        height: Height * 0.07,
                                                        width: Width * 0.9,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color(0xff01a8dd),
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(10),
                                                              bottomLeft: Radius
                                                                  .circular(10),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Center(
                                                            child: Text(
                                                          'Add',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'PoppinsRegular',
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      )),
                                );
                              });
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            height: Height * 0.065,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.contact_page_outlined,
                                              size: 30,
                                              color: Color(0xff01a8dd),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Emergency contact',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'PoppinsMedium',
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios_outlined)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {

                                          _launchInBrowser("http://api.igiinsurance.com.pk:8888/drive_api/terms.pdf");

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => PdfView(
                        //           url:
                        //               "http://api.igiinsurance.com.pk:8888/drive_api/terms.pdf")),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            height: Height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Terms & Condition',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PoppinsMedium',
                                        color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
_launchInBrowser("http://api.igiinsurance.com.pk:8888/drive_api/privacy.pdf");

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => PdfView(
                        //           url:
                        //               "http://api.igiinsurance.com.pk:8888/drive_api/privacy.pdf")),
                        // );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: Container(
                            height: Height * 0.065,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text('Privacy Policy',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'PoppinsMedium',
                                        color: Colors.grey)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
