import 'dart:convert';

import 'package:IGI_Drive/AuthScreens/Register.dart';
import 'package:IGI_Drive/AuthScreens/forgetpassword.dart';

import 'package:IGI_Drive/Screens/LoadingApiScreen.dart';
import 'package:IGI_Drive/homeScreen.dart';
import 'package:IGI_Drive/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController userPassword = new TextEditingController();
  final TextEditingController userNumber = new TextEditingController();
  bool _passwordVisible = false;
  final _storage = FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String token_id;
  bool remember = true;

  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
      token_id = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<http.Response> _trySubmit() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      print('register1clicked');

      print(userPassword.text);
      print(userNumber.text);

      if (isValid) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Center(
                  child: SpinKitWave(
                      color: Color(0xff01a8dd), type: SpinKitWaveType.center));
            });

        var map = new Map<String, dynamic>();

        var url =
            'http://api.igiinsurance.com.pk:8888/drive_api/login.php?';
        print(url);
        http.Response res = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'token': 'c66026133e80d4960f0a5b7d418a4d08',
            'number': userNumber.text,
            'password': userPassword.text
          },
        );
        var data = json.decode(res.body.toString());
        print(data);

        if (data['status'].toString() == "Success") {
          print(data['data'].length);
          if(data['data'].length == 1 ){
            print('check_token');
            print(token_id);
            print(data['data'][0]['id']);

            var url3 =
                'http://api.igiinsurance.com.pk:8888/drive_api/token_insert.php?id=${data['data'][0]['id']}&token=${token_id}';
            print(url);
            http.Response res = await http.get(
              Uri.parse(url3),
              headers: <String, String>{
                'token': 'c66026133e80d4960f0a5b7d418a4d08',
      
              },
            );
            var data33 = json.decode(res.body.toString());
            print(data33);
            await _storage.write(key: 'notiToken', value: token_id);
            await _storage.write(key: 'notiID', value: data['data'][0]['id']);
            await _storage.write(key: 'userName', value: data['data'][0]['name']);
            await _storage.write(
                key: 'userEmail', value: data['data'][0]['email']);

            print(data['data'][0]['imei_number']);
            await _storage.write(
                key: 'imei', value: data['data'][0]['imei_number']);
            await _storage.write(key: 'userNumber', value: userNumber.text);
            await _storage.write(key: 'userPassword', value: userPassword.text);
            await _storage.write(
                key: 'asset_id', value: data['data'][0]['asset_id']);
print('remember ${remember}');
                                            if(remember){
                                              print('saved');
                                              await _storage.write(
                                          key: 'checkLogin',
                                          value: 'LoginHuavaHa');

                                            }
            // await _storage.write(key: 'checkLogin', value: 'LoginHuavaHa');

            Navigator.pop(context);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
          }
          else{
            showModalBottomSheet(
                shape:
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft:
                      const Radius
                          .circular(
                          20.0),
                      topRight:
                      const Radius
                          .circular(
                          20.0)),
                ),
                isScrollControlled:
                true,
                context: context,
                builder: (BuildContext
                bc) {

                  return StatefulBuilder(
                      builder: (BuildContext
                      context,
                      StateSetter
                      setSsTate) {
                    return Container(
                      height: MediaQuery.of(
                          context)
                          .size
                          .height *
                          0.7,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Color(0xfff5f6fb),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                      'You can change vechile from settings.',
                                      style: TextStyle(
                                          fontFamily: 'PoppinsRegular',
                                          fontSize: 15,
                                          color: Color(0xff8f9ba8)),
                                    )),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.all(
                                  8.0),
                              child:
                              RichText(
                                text:
                                new TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style:
                                  new TextStyle(
                                    fontSize:
                                    16.0,
                                    color:
                                    Colors.black,
                                  ),
                                  children: <
                                      TextSpan>[
                                    new TextSpan(
                                        text: 'Select ',
                                        style: new TextStyle(fontSize: 18, fontFamily: 'PoppinsMedium')),
                                    new TextSpan(
                                        text: 'Vechile',
                                        style: TextStyle(fontSize: 18, fontFamily: 'PoppinsRegular', color: Color(0xff626567))),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              itemCount: data['data'].length,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 10, left: 15, right: 15),
                                  child: Container(
                                    child: GestureDetector(
                                      // onTap: widget.onPressed,
                                      onTap: () async {

                                        print('check_token');
                                        print(token_id);
                                        print(data['data'][index]['id']);

                                        var url3 =
                                            'http://api.igiinsurance.com.pk:8888/drive_api/token_insert.php?id=${data['data'][index]['id']}&token=${token_id}';
                                        print(url);
                                        http.Response res = await http.get(
                                          Uri.parse(url3),
                                          headers: <String, String>{
                                            'token': 'c66026133e80d4960f0a5b7d418a4d08'
                                          },
                                        );
                                        var data33 = json.decode(res.body.toString());
                                        print(data33);
                                        await _storage.write(key: 'notiToken', value: token_id);
                                        await _storage.write(key: 'notiID', value: data['data'][index]['id']);
                                        await _storage.write(key: 'userName', value: data['data'][index]['name']);
                                        await _storage.write(
                                            key: 'userEmail', value: data['data'][index]['email']);

                                        print(data['data'][index]['imei_number']);
                                        await _storage.write(
                                            key: 'imei', value: data['data'][index]['imei_number']);
                                        await _storage.write(key: 'userNumber', value: userNumber.text);
                                        await _storage.write(key: 'userPassword', value: userPassword.text);
                                        await _storage.write(
                                            key: 'asset_id', value: data['data'][index]['asset_id']);
                                            print('remember ${remember}');
                                            if(remember){
                                              print('saved');
                                              await _storage.write(
                                          key: 'checkLogin',
                                          value: 'LoginHuavaHa');

                                            }

                                        // await _storage.write(key: 'checkLogin', value: 'LoginHuavaHa');

                                        Navigator.pop(context);
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                            builder: (BuildContext context) => HomePage()));

                                      },
                                      child: Card(
                                        elevation: 1,
                                        margin: EdgeInsets.only(bottom: 15.0),
                                        shape: RoundedRectangleBorder(
                                            side: new BorderSide(
                                                color:  Color(0xff01a8dd), width: 1),
                                            borderRadius: BorderRadius.circular(12.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(data['data'][index]['vehicle_model'],style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'PoppinsRegular',
                                                  color: Color(0xff626567))),
                                              Text(data['data'][index]['register_number'],style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'PoppinsRegular',
                                                  color: Color(0xff626567)))
                                            ],
                                          ),
                                        ),
                                      )
                                    ),
                                  ),
                                );
                              },
                            )

                          ],
                        ),
                      ),
                    );});});
          }

        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Invalid Phone number or password.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff01a8dd),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        print('not valid');
      }
    }

    double statusBarHeight = MediaQuery.of(context).padding.top;
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xffF7F9F9),
      appBar: AppBar(
          centerTitle: true,

          backgroundColor: Color(0xff01a8dd),
           elevation: 1,
  title: Text(
            'Sign In',
            style: TextStyle(fontFamily: 'PoppinsBold'),
          ),
),

      body: SingleChildScrollView(
        child: Container(
          height: Height * 1,
          width: double.infinity,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/BG-01.jpg"),
          //     fit: BoxFit.fill,
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Height * 0.1,
              ),
              Container(
                child: Icon(Icons.login_outlined, color: Color(0xff01a8dd), size: 75,),
              ),
              SizedBox(
                height: Height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Container(
                  child: Text(
                    'Sign in to IGI Drive',
                    style: TextStyle(
                      fontFamily: 'PoppinsMedium',
                      fontSize: 30,
                      color: Color(0xff01a8dd),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Height * 0.02,
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Height * 0.03,
                      ),
                      Container(
                        height: 75,
                        width: Width * 0.9,
                        child: TextFormField(
                          controller: userNumber,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsRegular'),
                          decoration: new InputDecoration(
                            errorStyle: TextStyle(
                              color: Color(0xff01a8dd),
                            ),
                            border: new OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffbdbdbd), width: 1),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: new OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xffbdbdbd), width: 1),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: new TextStyle(
                                color: Color(0xffbdbdbd),
                                fontFamily: 'PoppinsRegular'),
                            hintText: "Phone number",
                            labelStyle: new TextStyle(
                                color: Color(0xff01a8dd),
                                fontFamily: 'PoppinsRegular'),
                            labelText: 'Phone number',
                            fillColor: Colors.white70,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff01a8dd), width: 1),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Height * 0.01,
                      ),
                      Container(
                          width: Width * 0.9,
                          height: 75,
                          child: TextFormField(
                            controller: userPassword,

                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Please enter a 6 digit password';
                              }
                              return null;
                            },
                            obscureText:
                                !_passwordVisible, //This will obscure text dynamically
                            style: TextStyle(
                                color: Color(0xff01a8dd),
                                fontFamily: 'PoppinsRegular'),
                            decoration: new InputDecoration(
                              errorStyle: TextStyle(
                                color: Color(0xff01a8dd),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xff01a8dd),
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              border: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.25),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(
                                  color: Color(0xffbdbdbd),
                                  fontFamily: 'PoppinsRegular'),
                              hintText: "Password",
                              labelText: "Password",
                              labelStyle: new TextStyle(
                                  color: Color(0xff01a8dd),
                                  fontFamily: 'PoppinsRegular'),
                              fillColor: Colors.white70,
                              enabledBorder: new OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xffbdbdbd), width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xff01a8dd), width: 1),
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                            ),
                          )),
                      
                      Container(
                        width: Width * 0.9,
                        child: Row(
                          children: [
                            Text(
                        'Remember Me',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Color(0xff7c7c7c),
                          fontFamily: 'PoppinsRegular',
                          fontSize: 14
                        ),
                          ),
                            Transform.scale(
                              scale: .7,
                              child: CupertinoSwitch(
                                  activeColor: Color(0xff01a8dd),
                                  value: remember,
                                  onChanged: (value) async {
                                    setState(() {
                                      remember = value;
                                    });

                                   
                                  },
                                ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
              
              Center(
                child: GestureDetector(
                  onTap: () {
                    print('asda');
                    _trySubmit();
                  },
                  child: Container(
                    height: Height * 0.07,
                    width: Width * 0.9,
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
                      'Login',
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
                height: Height * 0.02,
              ),
               GestureDetector(
                          onTap: () {
                            print('asda');
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgetPassword()),
                            );
                          },
                          child: Text(
                            'Forgot Password ?',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color(0xff7c7c7c),
                              fontFamily: 'PoppinsRegular',
                              fontSize: 14
                            ),
                          ),
                        ),
              
              SizedBox(
                height: Height * 0.02,
              ),Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        print('asda');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                RegisterScreen()));
                      },
                      child: RichText(
                          text: new TextSpan(
                        children: <TextSpan>[
                          new TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(
                              color: Color(0xff7c7c7c),
                              fontFamily: 'PoppinsRegular',
                            ),
                          ),
                          new TextSpan(
                            text: ' Signup',
                            style: TextStyle(
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsBold',
                            ),
                          ),
                        ],
                      )),
                    ),
                  )),
              SizedBox(
                height: Height * 0.06,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
