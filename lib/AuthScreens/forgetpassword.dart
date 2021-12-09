
import 'package:IGI_Drive/AuthScreens/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:IGI_Drive/AuthScreens/Register.dart';
import 'package:IGI_Drive/AuthScreens/forgetpassword.dart';

import 'package:IGI_Drive/Screens/LoadingApiScreen.dart';
import 'package:IGI_Drive/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController userPassword = new TextEditingController();
  final TextEditingController userNumber = new TextEditingController();
  final TextEditingController userOTP = new TextEditingController();

  bool _passwordVisible = false;
  final _storage = FlutterSecureStorage();

  bool showNumber = true;
  bool showOTP = false;
  bool showPassword = false;

  String otpCode = "";
  String otptempCode = "";

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;

    Future<http.Response> _trySubmit() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      print('register1clicked');

      print(userPassword.text);
      print(userNumber.text);
      print(userOTP.text);

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
            'http://api.igiinsurance.com.pk:8888/drive_api/forget_password.php?number=${userNumber.text}';
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
          Navigator.pop(context);

          otpCode = data['sms otp'].toString();
           otptempCode = data['tem otp'].toString();

          print('check_token');
          print(data);
          Fluttertoast.showToast(
              msg: "We have send otp code on your number.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff01a8dd),
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            showNumber = false;
            showOTP = true;
          });

        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Phone number not found in or cms.",
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

    Future<http.Response> _trySubmit2() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      print('register1clicked');

      print(userPassword.text);
      print(userNumber.text);
      print(userOTP.text);

      if (isValid) {

        if(userOTP.text.trim().toString() == otpCode || userOTP.text.trim().toString() == otptempCode){
          print('work');
          Fluttertoast.showToast(
              msg: "Please enter your new password.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff01a8dd),
              textColor: Colors.white,
              fontSize: 16.0);
          setState(() {
            showNumber = false;
            showOTP = false;
            showPassword = true;

          });

        }


      } else {
        print('not valid');
      }
    }

    Future<http.Response> _trySubmit3() async {
      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();

      print('register1clicked');

      print(userPassword.text);
      print(userNumber.text);
      print(userOTP.text);

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
            'http://api.igiinsurance.com.pk:8888/drive_api/update_password.php?';
        print(url);
        http.Response res = await http.get(
          Uri.parse(url),
          headers: <String, String>{
            'token': 'c66026133e80d4960f0a5b7d418a4d08',
            'number': userNumber.text,
            'password': userPassword.text,
          },
        );
        var data = json.decode(res.body.toString());
        print(data);

        if (data['status'].toString() == "success") {
          Navigator.pop(context);

          print('check_token');
          print(data);
          Fluttertoast.showToast(
              msg: "Your password is changed.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff01a8dd),
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );

        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "Phone number not found in or cms.",
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

    return Scaffold(
      backgroundColor: Color(0xffF7F9F9),

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
          'Forget Password',
          style: TextStyle(fontFamily: 'PoppinsBold', color: Color(0xff01a8dd)),
        ),
      ),
      body: Container(
        height: Height * 1,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: Height * 0.1,
            ),
            Container(
              child: Icon(Icons.admin_panel_settings_sharp, color: Color(0xff01a8dd), size: 75,),
            ),
            SizedBox(
              height: Height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                child: Text(
                  'Recover your password',
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
            showNumber ? Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Height * 0.03,
                    ),
                    Container(
                      height: Height * 0.08,
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
                          hintText: "Enter Phone No",
                          labelStyle: new TextStyle(
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsRegular'),
                          labelText: 'Enter Phone No',
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
                      height: Height * 0.03,
                    ),
                  ],
                ),
              ),
            ) : Container(),
            showNumber ? Center(
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
                        'Send OTP',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsRegular',
                            color: Colors.white),
                      )),
                ),
              ),
            ) : Container(),
            showOTP ? Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Height * 0.03,
                    ),
                    Container(
                      height: Height * 0.08,
                      width: Width * 0.9,
                      child: TextFormField(
                        controller: userOTP,
                        validator: (value) {
                          if (value.isEmpty ||
                              value.length > 4 ||
                              value.length < 3) {
                            return 'Please enter a valid OTP';
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
                          hintText: "Enter OTP",
                          labelStyle: new TextStyle(
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsRegular'),
                          labelText: 'Enter OTP',
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
                      height: Height * 0.03,
                    ),
                  ],
                ),
              ),
            ) : Container(),
            showOTP ? Center(
              child: GestureDetector(
                onTap: () {
                  print('asda');
                  _trySubmit2();
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
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsRegular',
                            color: Colors.white),
                      )),
                ),
              ),
            ) : Container(),
            showPassword ? Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: Height * 0.03,
                    ),
                    Container(
                        width: Width * 0.9,
                        height: Height * 0.08,
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

                    SizedBox(
                      height: Height * 0.03,
                    ),
                  ],
                ),
              ),
            ) : Container(),
            showPassword ? Center(
              child: GestureDetector(
                onTap: () {
                  print('asda');
                  _trySubmit3();
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
                        'Submit',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsRegular',
                            color: Colors.white),
                      )),
                ),
              ),
            ) : Container(),
          ],
        ),
      ),

    );
  }
}
