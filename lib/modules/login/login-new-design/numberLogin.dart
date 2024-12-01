import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';

class NumberLogin extends StatefulWidget {
  const NumberLogin({super.key});

  @override
  NumberLoginState createState() => NumberLoginState();
}

class NumberLoginState extends State<NumberLogin> {
  final LoginController landingPageController = Get.find<LoginController>();
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: buildImage()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
                            child: SizedBox(
                                child: Text(
                              "Mobile Number",
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 28,
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
                              "Please confirm your country code and phone number.",
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
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 30, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1, // Takes 20% of available space
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Image.asset(
                                      'assets/images/americaflag.png', // Replace with the actual path to the American flag image
                                      fit: BoxFit.fill,
                                      width: 20, // Adjust the width as needed
                                      height: 30, // Adjust the height as needed
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  flex: 8,
                                  child: SizedBox(
                                    height: 30,
                                    child: TextFormField(
                                      controller: landingPageController
                                          .mobileNumberLoginController,
                                      keyboardType: TextInputType.phone,
                                      style: SafeGoogleFont(
                                        color: const Color(0xFF868889),
                                        'Poppins',
                                        fontSize: 12,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your phone number',

                                        contentPadding: EdgeInsets.all(
                                            10), // Add proper content padding here
                                      ),
                                      onChanged: (value) {
                                        if (landingPageController
                                                .mobileNumberLoginController
                                                .text
                                                .isNotEmpty &&
                                            landingPageController
                                                    .mobileNumberLoginController
                                                    .text
                                                    .length <=
                                                10) {
                                          setState(() {
                                            landingPageController
                                                .enableContinueButton = true;
                                            landingPageController
                                                .displayErrorMsg = false;
                                          });
                                        } else {
                                          setState(() {
                                            landingPageController
                                                .displayErrorMsg = false;
                                            landingPageController
                                                .enableContinueButton = false;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          landingPageController.displayErrorMsg == true
                              ? Container(
                                  width: getHorizontalSize(351),
                                  margin:
                                      getMargin(left: 20, top: 36, right: 56),
                                  child: Text(landingPageController.errorMsg,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style:
                                          const TextStyle(color: Colors.red)))
                              : Container(),
                          // Padding(
                          //   padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment
                          //         .spaceBetween, // Align children to the start and end of the row
                          //     children: [
                          //       Text(
                          //         "Sync Contacts",
                          //         style: SafeGoogleFont(
                          //           "Inter",
                          //           color: const Color.fromRGBO(0, 0, 0, 0.70),
                          //           fontSize: 16,
                          //           fontStyle: FontStyle.normal,
                          //           fontWeight: FontWeight.w400,
                          //           height: 1.25,
                          //         ),
                          //       ),
                          //       const MyToggleSwitch(),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          nextButton(context, landingPageController),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              backArrow(context),
            ]),
          ),
        )),
      ),
    );
  }

  nextButton(BuildContext context, LoginController landingPageController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
      child: SizedBox(
        height: 50,
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
            if (landingPageController.enableContinueButton == true) {
              var jsonData = await landingPageController.mobileNumberzOtp(
                  landingPageController.mobileNumberLoginController.text,
                  context);

              if (jsonData != null) {
                if (jsonData['code'] == 400 || jsonData['resp'] == -1) {
                  setState(() {
                    landingPageController.errorMsg = jsonData['message'];
                    landingPageController.loginSendOtpSuccessMsgnew =
                        jsonData['message'];
                    landingPageController.displayErrorMsg = true;
                  });
                } else {
                  setState(() {
                    landingPageController.loginTokenController.text =
                        jsonData['data']['token'];

                    landingPageController.displayErrorMsg = false;
                  });

                  Get.toNamed("/numberLoginOtp");
                }
              }
            }
            //   // Handle back button tap here
          },
          child: Text(
            "Continue",
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
    );
  }

  Positioned backArrow(BuildContext context) {
    return Positioned(
      top: 30,
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
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          'assets/images/loginmain11.png', // Replace with your background image URL
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ],
    );
  }
}

class MyToggleSwitch extends StatefulWidget {
  const MyToggleSwitch({super.key});

  @override
  MyToggleSwitchState createState() => MyToggleSwitchState();
}

class MyToggleSwitchState extends State<MyToggleSwitch> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
        });
      },
      activeColor: const Color(0xFFAF6CDA),
      // Use the color #AF6CDA
    );
  }
}
