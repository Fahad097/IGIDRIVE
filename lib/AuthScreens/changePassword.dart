import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController useroldPassword = new TextEditingController();
  final TextEditingController usernewPassword = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    proc() async {
      final _storage = FlutterSecureStorage();

      String passss = await _storage.read(key: "userPassword");
      String nmmm = await _storage.read(key: "userNumber");

      print('passss');
      print(passss);

      final isValid = _formKey.currentState.validate();
      FocusScope.of(context).unfocus();
      if (isValid) {
        if(useroldPassword.text.toString() == passss.toString()){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                    child: SpinKitWave(
                        color: Color(0xff01a8dd), type: SpinKitWaveType.center));
              });

          var url =
              'http://api.igiinsurance.com.pk:8888/drive_api/change_password.php?';
          print(url);
          http.Response res = await http.get(
            Uri.parse(url),
            headers: <String, String>{
              'token': 'c66026133e80d4960f0a5b7d418a4d08',
              'old_password': useroldPassword.text,
              'new_password':usernewPassword.text,
              'number': nmmm
            },
          );
          var data = json.decode(res.body.toString());
          print(data);

          if(data['status'] == "success"){
            Navigator.pop(context);

            await _storage.write(key: 'userPassword', value: usernewPassword.text.toString());

            Fluttertoast.showToast(
                msg: "Password changes successfully.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff01a8dd),
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pop(context);


          }
        }
        else{
          Fluttertoast.showToast(
              msg: "Old password not matched.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff01a8dd),
              textColor: Colors.white,
              fontSize: 16.0);
        }

      }
    }

    double statusBarHeight = MediaQuery.of(context).padding.top;
    double Height = MediaQuery.of(context).size.height;
    double Width = MediaQuery.of(context).size.width;
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
          'Change Password',
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
                  'Change your password',
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
                      height: Height * 0.08,
                      width: Width * 0.9,
                      child: TextFormField(
                        controller: useroldPassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an old password';
                          }
                          return null;
                        },
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
                          hintText: "Enter Old Password",
                          labelStyle: new TextStyle(
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsRegular'),
                          labelText: 'Enter Old Password',
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
                    SizedBox(height: 10,),
                    Container(
                      height: Height * 0.08,
                      width: Width * 0.9,
                      child: TextFormField(
                        controller: usernewPassword,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an new password';
                          }
                          return null;
                        },
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
                          hintText: "Enter New Password",
                          labelStyle: new TextStyle(
                              color: Color(0xff01a8dd),
                              fontFamily: 'PoppinsRegular'),
                          labelText: 'Enter New Password',
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
            ) ,

            Center(
              child: GestureDetector(
                onTap: () {
                  print('asda');
                  proc();
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
                        'Save',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PoppinsRegular',
                            color: Colors.white),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }
}
