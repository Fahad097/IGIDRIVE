import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:IGI_Drive/AuthScreens/Login.dart';
import 'package:IGI_Drive/Screens/LoadingApiScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Screens/DashboardScreen.dart';
import 'drawerScreen.dart';
import 'homeScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
  ));
  runApp(RestartWidget(
    child: MaterialApp(
        debugShowCheckedModeBanner: false,

      home: Splash(),
      theme: ThemeData(
        primaryColor: Color(0xff01a8dd),
        accentColor: Color(0xff01a8dd),
      ),
    ),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
   versionCheck();
    print('change');
    uninstallcheck();

  }

  uninstallcheck() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs);
    print(prefs.getBool('first_run'));

if (prefs.getBool('first_run') ?? true) {
  FlutterSecureStorage storage = FlutterSecureStorage();

  await storage.deleteAll();

  prefs.setBool('first_run', false);
}
  }


versionCheck() async{


    var url = 'http://api.igiinsurance.com.pk:8888/drive_api/app_version.php';
    //print(url);
    http.Response res = await http.get(
      Uri.parse(url),
      headers: <String, String>{'token': 'c66026133e80d4960f0a5b7d418a4d08'},
    );
    var data = json.decode(res.body.toString());
    print(data);
    if (data['link'].toString() == "Version 2.0") {
nextStart();

    }
    else{
        showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: Text("Update",
                      style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 22,color: Color(0xff01a8dd)),),
    content: Text("App update available.",
                      style: TextStyle(fontFamily: 'PoppinsRegular', fontSize: 20,color: Color(0xff01a8dd)),),
    actions: [
      FlatButton(
    child: Text("Skip",
                      style: TextStyle(fontFamily: 'PoppinsRegular', fontSize: 20,color: Color(0xff01a8dd)),),
    onPressed: () {
      Navigator.pop(context);
nextStart();
     },
  ),
        FlatButton(
    child: Text("Update",
                      style: TextStyle(fontFamily: 'PoppinsRegular', fontSize: 20,color: Color(0xff01a8dd)),),
    onPressed: () { 
      Navigator.pop(context);
      if (Platform.isAndroid) {
        launch("https://play.google.com/store/apps/details?id=com.drive.igi");        
} else if (Platform.isIOS) {
        launch("https://apps.apple.com/pk/app/igi-drive/id1574977883");        
}


    },
  ),
    ],
    
  );
    },
  );
    }

}


nextStart(){
      Timer(Duration(seconds: 3), () async {
      final storage = new FlutterSecureStorage();

      String checkLogin = await storage.read(key: "checkLogin");
      print('checkLogin');
      print(checkLogin);
      String checkBio = await storage.read(key: "checkBio");
      print(checkBio);

      if (checkLogin == "LoginHuavaHa") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomePage()));
      }
      else if(checkBio == "lagihueha"){

        bool authenticated = false;
        try {
          setState(() {
            _isAuthenticating = true;
            _authorized = 'Authenticating';
          });
          authenticated = await auth.authenticateWithBiometrics(
              localizedReason: 'Scan your fingerprint to authenticate',
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

        final String message = authenticated ? 'Authorized' : 'Not Authorized';
        setState(() async {
          _authorized = message;
          print(_authorized);
          if(_authorized.toString() == "Authorized"){
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
          }
        });
      }
      else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      }
    });

}
  void firebaseCloudMessaging_Listeners() {
    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
        _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      String _homeScreenText;
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    double stackWidth = MediaQuery.of(context).size.width;
    double stackHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/sidebg.png"), fit: BoxFit.contain),
          ),
          child: Center(
            child: Container(
                width: stackWidth * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/logo@3x.png'),
                  ],
                )),
          )),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [DrawerScreen(), HomeScreen()],
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
