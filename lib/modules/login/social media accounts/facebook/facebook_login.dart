// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FaceBookLogin extends StatefulWidget {
  const FaceBookLogin({Key? key}) : super(key: key);

  @override
  FaceBookLoginState createState() => FaceBookLoginState();
}

String prettyPrint(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class FaceBookLoginState extends State<FaceBookLogin> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    final accessToken = await FacebookAuth.instance.accessToken;
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      // now you can call to  FacebookAuth.instance.getUserData();
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    }
  }

  Future<void> _login() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile

    // print("#$result#");
    // loginBehavior is only supported for Android devices, for ios it will be ignored
    // final result = await FacebookAuth.instance.login(
    //   permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link'],
    //   loginBehavior: LoginBehavior
    //       .DIALOG_ONLY, // (only android) show an authentication dialog instead of redirecting to facebook app
    // );

    if (result.status == LoginStatus.success) {
      // print("##");
      _accessToken = result.accessToken;
      print(
        prettyPrint(_accessToken!.toJson()),
      );
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _userData = userData;

      //  use facebook instance logout code here
    } else {
      print(result.status);
      print(result.message);
    }

    setState(() {
      _checking = false;
    });
  }

  Future<void> _logOut() async {
    await FacebookAuth.instance.logOut();
    _accessToken = null;
    _userData = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(_checking);
    return MaterialApp(
      home: Scaffold(
        body: _checking
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 70,
                      ),
                      Text(
                        _userData != null
                            ? prettyPrint(_userData!)
                            : "NO    LOGGEDd",
                      ),
                      const SizedBox(height: 20),
                      _accessToken != null
                          ? Text(
                              prettyPrint(_accessToken!.toJson()),
                            )
                          : Container(),
                      const SizedBox(height: 20),
                      CupertinoButton(
                        color: const Color.fromARGB(255, 159, 101, 182),
                        onPressed: _userData != null ? _logOut : _login,
                        child: Text(
                          _userData != null ? "LOGOUT" : "LOGIN",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
