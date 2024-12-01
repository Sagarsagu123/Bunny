import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/modules/login/social%20media%20accounts/facebook/facebook_main.dart';
import 'package:flutter_demo/modules/login/social%20media%20accounts/google/google_sign_in_login.dart';
import 'package:flutter_demo/theme/custom_button_style.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginOptionsScreen extends StatefulWidget {
  const LoginOptionsScreen({super.key});
  @override
  LoginOptionsScreendState createState() => LoginOptionsScreendState();
}

class LoginOptionsScreendState extends State<LoginOptionsScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final LoginController landingPageController = Get.find<LoginController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  void initState() {
    super.initState();

    clearAuthAtLoginPage();
  }

  Future<void> clearAuthAtLoginPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    landingPageController.loadingPageGoogle = false;
    setState(() {
      landingPageController.loadingPageGoogle = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          body: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Get.width > 600 ? 600 : 500,
              height: Get.height,
              // buttonTextStyle: theme.textTheme.titleMedium!,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.topRight, children: [
                      Container(
                        height: 300,
                        width: Get.width,
                        padding: getPadding(all: 10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    ImageConstant.loginOptionImageNew),
                                fit: BoxFit.fitWidth)),
                      ),
                    ]),
                    CustomElevatedButton(
                      text: "Continue with Apple".tr,
                      onTap: () {
                        // Get.toNamed('/userLocation');
                      },
                      margin: getMargin(left: 20, top: 54, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)),
                      buttonStyle: CustomButtonStyles.fillBlack900.copyWith(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          Size(
                            double.maxFinite,
                            getVerticalSize(43),
                          ),
                        ),
                      ),
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
                          Image.asset(
                            'assets/images/appleicon.png',
                            height: 16.52,
                            width: 20,
                          ),
                          const SizedBox(width: 8.0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    const GoogleSignIn(),
                    const SizedBox(height: 5),
                    const FaceBookMain(),
                    const SizedBox(height: 5),
                    Text(
                      "Or".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: SafeGoogleFont("Poppins",
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff868889)),
                    ),
                    CustomElevatedButton(
                      text: "Sign up with email + SMS".tr,
                      onTap: () {
                        Get.toNamed('/loginReg-otp');
                      },
                      margin: getMargin(
                        left: 20,
                        top: 8,
                        right: 20,
                      ),
                      buttonStyle: CustomButtonStyles.fillPrimaryTL5.copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                    ),
                    Padding(
                      padding: getPadding(
                        top: 38,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          landingPageController.onClickLogIn();
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account?".tr,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  color: const Color(0xff868889),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                  letterSpacing: 0,
                                ),
                              ),
                              TextSpan(
                                text: " Log in".tr,
                                style: SafeGoogleFont(
                                  'Poppins',
                                  color: const Color(0xFFAF6CDA),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          child: InkWell(
                        onDoubleTap: () {
                          [
                            dashboardController.clearController(),
                            landingPageController.loginWithEmail(
                                context, 'nandeesh')
                          ];
                        },
                        child: const Text("Version: 1.1.0+1",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 94, 92, 92),
                            )),
                      )),
                    ),
                    Container(
                      height: 60,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
