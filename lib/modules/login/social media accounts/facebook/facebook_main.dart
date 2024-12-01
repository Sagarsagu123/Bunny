// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/custom_button_style.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/custom_elevated_button.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

class FaceBookMain extends StatefulWidget {
  const FaceBookMain({Key? key}) : super(key: key);

  @override
  FaceBookState createState() => FaceBookState();
}

String prettyPrint(Map json) {
  JsonEncoder encoder = const JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

class FaceBookState extends State<FaceBookMain> {
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    // _checkIfIsLogged();
  }

  Future<void> _checkIfIsLogged() async {
    print("_checkIfIsLogged");
    final accessToken = await FacebookAuth.instance.accessToken;
    print("$accessToken");
    setState(() {
      _checking = false;
    });
    if (accessToken != null) {
      print("accessToken");
      print(accessToken);
      print("is Logged:::: ${prettyPrint(accessToken.toJson())}");
      final userData = await FacebookAuth.instance.getUserData();
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
      _accessToken = accessToken;
      setState(() {
        _userData = userData;
      });
    } else {
      print("null value");
    }
  }

  Future<void> _login(LoginController controller) async {
    final LoginResult result = await FacebookAuth.instance.login();
    // print("4444");
    // print(result.message);
    // print("${result.accessToken}");

    // if (result.status == LoginStatus.success) {
    //   print("##");
    //   _accessToken = result.accessToken;
    //   print(
    //     prettyPrint(_accessToken!.toJson()),
    //   );
    //   final userData = await FacebookAuth.instance.getUserData();
    //   // _userData = userData;
    //   setState(() {
    //     _userData = userData;
    //   });
    //   // ######################
    //   //  use facebook instance logout code here
    //   // call our API here .......
    //   // await FacebookAuth.instance.logOut();
    //   // _accessToken = null;
    //   // _userData = null;
    //   // setState(() {});
    //   print("FACEBOOK login");
    //   final userInfo = FacebookUserInfo(
    //       name: "Nandeesh",
    //       email: "nandeesh@clinconsent.com",
    //       facebookId: "625635039746892"
    //       // name: userData.name,
    //       // email: userData.email,
    //       // facebookId: user.facebook_id

    //       );

    //   controller.facebookLogin(userInfo);

    //   // ######################
    // } else {
    //   print(result.status);
    //   print(result.message);
    // }

    // setState(() {
    //   _checking = false;
    // });
    await FacebookAuth.instance.logOut();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return SizedBox(
        child: CustomElevatedButton(
          text: "Continue with Facebook".tr,
          margin: getMargin(
            left: 20,
            top: 8,
            right: 20,
          ),
          onTap: () async {
            // _login(controller);
          },
          buttonStyle: CustomButtonStyles.fillIndigo600.copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              fixedSize: MaterialStateProperty.all<Size>(Size(
                double.maxFinite,
                getVerticalSize(
                  43,
                ),
              ))),
          buttonTextStyle: SafeGoogleFont(
            'Poppins',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.5,
            letterSpacing: 0,
          ),
          leftIcon: Row(
            children: [
              Container(
                width: 30,
              ),
              const Icon(
                Icons.facebook_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8.0),
            ],
          ),
        ),
      );
    });
  }
}

class FacebookUserInfo {
  final String? name;
  final String email;
  final String facebookId;

  FacebookUserInfo(
      {required this.name, required this.email, required this.facebookId});
}
