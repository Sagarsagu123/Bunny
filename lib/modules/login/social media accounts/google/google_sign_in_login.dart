// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/modules/login/social%20media%20accounts/google/GoogleSignInApi.dart';
import 'package:flutter_demo/theme/custom_button_style.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/custom_elevated_button.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({
    super.key,
  });

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return CustomElevatedButton(
        text: "Continue with Google",
        margin: getMargin(
          left: 20,
          top: 8,
          right: 20,
        ),
        onTap: () async {
          googleSignIn(controller);
        },
        buttonStyle: CustomButtonStyles.fillBluegray50.copyWith(
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
          color: const Color(0xff868889),
          fontSize: 16,
          fontWeight: FontWeight.w500,
          height: 1.5,
          letterSpacing: 0,
        ),
        leftIcon: Row(
          children: [
            Container(
              width: 10,
            ),
            Image.asset(
              'assets/images/Google_icon.png',
              height: 20,
              width: 20,
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      );
    });
  }

  Future googleSignIn(LoginController controller) async {
    final user = await GoogleSignInApi.login();

    controller.loadingPageGoogle = true;
    if (user == null) {
      if (kDebugMode) {
        print("Failed to Sign in ");
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to Sign in')));
    } else {
      final userInfo = UserInfo(
          displayName: user.displayName,
          photoUrl: user.photoUrl,
          email: user.email,
          id: user.id);

      controller.googleLogin(context, userInfo);
    }
  }
}

class UserInfo {
  final String? displayName;
  final String? photoUrl;
  final String email;
  final String id;

  UserInfo(
      {required this.displayName,
      required this.photoUrl,
      required this.email,
      required this.id});
}
