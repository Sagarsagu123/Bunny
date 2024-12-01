import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class NumberLoginOtp extends StatefulWidget {
  const NumberLoginOtp({super.key});

  @override
  NumberLoginOtpState createState() => NumberLoginOtpState();
}

class NumberLoginOtpState extends State<NumberLoginOtp> {
  final LoginController landingPageController = Get.find<LoginController>();
  bool enable = true;
  late String msg;
  bool display = false;

  bool enableContinueButton = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: 400,
                    child: buildImage(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                    child: SizedBox(
                        child: Text(
                      "Verify your OTP",
                      style: SafeGoogleFont(
                        "Poppins",
                        color: const Color(0xFF868889),
                        fontSize: 30,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                    )),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: Text(
                      "We’ve sent an SMS with an activation",
                      style: SafeGoogleFont(
                        "Poppins",
                        color: const Color.fromRGBO(0, 0, 0, 0.70),
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        height: 1.25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          "code to your phone  ",
                          style: SafeGoogleFont(
                            color: const Color.fromRGBO(0, 0, 0, 0.70),
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                        Text(
                          landingPageController
                              .mobileNumberLoginController.text,
                          style: SafeGoogleFont(
                            color: const Color.fromRGBO(0, 0, 0, 0.70),
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pinCodeExample(),
                  display == true
                      ? Container(
                          width: getHorizontalSize(351),
                          margin: getMargin(left: 20, top: 36, right: 56),
                          child: Text(msg,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: const TextStyle(color: Colors.red)))
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: Row(
                      children: [
                        Text(
                          "I didn’t receive a code ",
                          style: SafeGoogleFont(
                            color: const Color.fromRGBO(0, 0, 0, 0.70),
                            'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.25,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            landingPageController.mobileNumberzOtp(
                                landingPageController
                                    .mobileNumberLoginController.text,
                                context);
                          },
                          child: Text(
                            "Resend",
                            style: SafeGoogleFont(
                              color: const Color(0xFFAF6CDA),
                              'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: SizedBox(
                      height: 56,
                      width: Get.width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            landingPageController.enableContinueButton == true
                                ? const Color(0xFFAF6CDA)
                                : const Color.fromARGB(255, 78, 77, 77),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Adjust the value for the desired corner radius
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (landingPageController.enableContinueButton ==
                              true) {
                            var jsonData =
                                await landingPageController.loginVerifyOtp(
                                    context,
                                    landingPageController
                                        .mobileNumberLoginController.text,
                                    landingPageController
                                        .entercodeLoginController.text,
                                    landingPageController
                                        .loginTokenController.text);

                            if (jsonData != null) {
                              if (jsonData['code'] == 400 ||
                                  jsonData['resp'] == -1) {
                                setState(() {
                                  landingPageController.errorMsg =
                                      jsonData['message'];
                                  msg = jsonData['message'];

                                  display = true;

                                  landingPageController.displayErrorMsg == true;
                                });
                              } else {
                                var authToken = jsonData['data']['token'];
                                Auth.setAuthCode(authToken);
                                Auth.setLoginDetail(true);
                                setState(() {
                                  display = false;

                                  landingPageController.entercodeLoginController
                                      .clear();

                                  landingPageController
                                      .mobileNumberLoginController
                                      .clear();
                                  Get.toNamed("/dashboard");
                                });
                              }
                            }
                          }
                        },
                        child: Text(
                          "Verify",
                          style: SafeGoogleFont(
                            "Poppins",
                            color: Colors.white,
                            fontSize: 23,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ), // Add your button text here
                      ),
                    ),
                  ),
                ],
              ),
              backArrow(context),
            ]),
          ),
        )),
      ),
    );
  }

  Positioned backArrow(BuildContext context) {
    return Positioned(
      top: 40,
      left: 20,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10), // Adjust padding as needed
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF1F1F5),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20, // Adjust icon size as needed
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/loginmain11.png', // Replace with your background image URL
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        // Image.asset(
        //   'assets/images/loginMainAvocado.png', // Replace with your overlay image URL
        //   width: 200.0,
        //   height: 220,
        //   fit: BoxFit.cover,
        // ),
      ],
    );
  }

  pinCodeExample() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PinCodeTextField(
          controller: landingPageController.entercodeLoginController,
          appContext: context,
          length: 6,
          onChanged: (value) {
            if (landingPageController.entercodeLoginController.text.length >=
                6) {
              setState(() {
                landingPageController.enableContinueButton = true;

                display = false;
              });
            } else {
              setState(() {
                landingPageController.enableContinueButton = false;

                display = false;
              });
            }
          },
          textStyle: const TextStyle(fontSize: 22),
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 40,
            fieldWidth: 30,
            activeFillColor: Colors.white,
            selectedColor: const Color(0xFFAF6CDA),
            inactiveColor: Colors.grey,
          ),
        ),
      ),
    );
  }
}
