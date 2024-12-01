import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/core/utils/validation_functions.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
// import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginRegOTP extends StatefulWidget {
  const LoginRegOTP({super.key});

  @override
  State<LoginRegOTP> createState() => _LoginRegOTPState();
}

class _LoginRegOTPState extends State<LoginRegOTP> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: GetBuilder<LoginController>(builder: (loginController) {
      return SafeArea(
        child: SizedBox(
            height: Get.height,
            child: Scaffold(
                appBar: appBar11(),
                resizeToAvoidBottomInset: false,
                backgroundColor:
                    theme.colorScheme.onPrimaryContainer.withOpacity(1),
                body: Form(
                    key: _formKey,
                    child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Container(
                                width: Get.width,
                                // height: 29.971,
                                constraints: BoxConstraints(
                                  maxWidth: Get.width,
                                  // maxHeight: 29.971,
                                ),
                                decoration: const BoxDecoration(),
                                child: Text(
                                  'Enter Your Mobile Number',
                                  style: SafeGoogleFont(
                                    color: const Color(0xFF868889),
                                    'Poppins',
                                    fontSize: 26,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w600,
                                    height: 1.11538,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                              child: Container(
                                width: Get.width,
                                decoration: const BoxDecoration(),
                                child: Text(
                                  'Mobile Number',
                                  style: SafeGoogleFont(
                                    color: const Color(0xFF868889),
                                    'Poppins',
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 129, 128, 128)),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: Colors.white,
                                      ),
                                      child: DropdownButton<String>(
                                        value:
                                            loginController.selectedCountryCode,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            loginController
                                                    .selectedCountryCode =
                                                newValue!;
                                          });
                                        },
                                        items: <String>[
                                          '+1',
                                          '+91',
                                          '+44',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 141, 138, 138)),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Expanded(
                                    flex: 13,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: loginController
                                              .phonenumberController,
                                          keyboardType: TextInputType.phone,
                                          style: SafeGoogleFont(
                                            color: const Color(0xFF868889),
                                            'Poppins',
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                            height: 1.93,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // Allow only numeric input
                                            LengthLimitingTextInputFormatter(
                                                10), // Limit length to 10 digits
                                          ],
                                          decoration: const InputDecoration(
                                            hintText: 'Enter your phone number',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                          ),
                                          onChanged: (value) {
                                            loginController
                                                .phoneNumberEntered();
                                          },
                                          validator: (value) {
                                            // Basic phone number validation
                                            if (value!.isEmpty) {
                                              return 'Please enter a phone number';
                                            } else if (value.length != 10) {
                                              return 'Invalid phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loginController.sendOtpSuccessMsg != null
                                ? Container(
                                    width: getHorizontalSize(351),
                                    margin:
                                        getMargin(left: 20, top: 36, right: 56),
                                    child: Text(
                                        "${loginController.sendOtpSuccessMsg}",
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style:
                                            const TextStyle(color: Colors.red)))
                                : Container(),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Container(
                                width: Get.width,
                                decoration: BoxDecoration(
                                  // color: const Color(0xFF838383),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "By continuing,you will receive a verification",
                                      style: SafeGoogleFont(
                                        color: const Color(0xFF838383),
                                        'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.15,
                                      ),
                                    ),
                                    Text(
                                      "code via text message.",
                                      style: SafeGoogleFont(
                                        color: const Color(0xFF838383),
                                        'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Message and data rates may apply.",
                                      style: SafeGoogleFont(
                                        color: const Color(0xFF838383),
                                        'Poppins',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: -0.15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pageTermsAndPrivacy(),
                            nextButton(context, loginController),
                          ],
                        ))))),
      );
    }));
  }

  appBar11() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 30),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 10, bottom: 10, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            68,
          ),
          leadingWidth: 32,
          leading: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              onDoubleTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Align(
            alignment: Alignment.center,
            child: AppbarImage(
                height: getVerticalSize(
                  65,
                ),
                width: getHorizontalSize(
                  160,
                ),
                imagePath: ImageConstant.imgBunnylogorgbfc),
          ),
        ),
      ),
    );
  }

  termsAndServices() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return webViewAlertDialog(TERMAANDCONDITIONS, false);
          },
        );
      },
      child: Padding(
        padding: getPadding(left: 20, top: 16),
        child: SizedBox(
          width: Get.width,
          child: Text(
            'Bunny SMS Terms of Service',
            style: SafeGoogleFont(
              color: const Color.fromARGB(
                  255, 102, 101, 101), // #838383 in hexadecimal
              'Poppins',
              fontSize: 15.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.15,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  webViewAlertDialog(String url, bool val) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AlertDialog(
        insetPadding: const EdgeInsets.all(5),
        backgroundColor: Colors.white,
        actionsPadding: const EdgeInsets.all(2),
        contentPadding: const EdgeInsets.all(2),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              val == true ? 'Privacy policy' : "Terms and Conditions",
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFAF6CDA),
                  fontSize: 22),
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            height: Get.height - 20,
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: SafeGoogleFont("Poppins",
                    color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  privacyPolicy() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return webViewAlertDialog(PRIVACYPOLICY, true);
          },
        );
      },
      child: Padding(
        padding: getPadding(left: 20, top: 16),
        child: SizedBox(
          width: Get.width,
          child: Text(
            'Bunny Privacy Policy',
            style: SafeGoogleFont(
              color: const Color(0xFF838383), // #838383 in hexadecimal
              'Poppins',
              fontSize: 15.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.15,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  otpLogin(LoginController loginController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: getPadding(left: 20, top: 26),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text("Enter phone number".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleSmall),
            )),
        CustomTextFormField(
            controller: loginController.phonenumberController,
            margin: getMargin(left: 20, top: 14, right: 20),
            maxLength: 10,
            hintText: "Type phone number".tr,
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            alignment: Alignment.center,
            onChanged: (value) {
              loginController.phoneNumberEntered();
            },
            validator: (value) {
              if (!isValidPhone(value)) {
                return "Please enter valid phone number";
              }
              return null;
            },
            defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            disabledBorderDecoration:
                TextFormFieldStyleHelper.underLinePrimary),
        loginController.sendOtpSuccessMsg != null
            ? Container(
                width: getHorizontalSize(351),
                margin: getMargin(left: 20, top: 36, right: 56),
                child: Text("${loginController.sendOtpSuccessMsg}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.red)))
            : Container(),
        Container(
            width: getHorizontalSize(351),
            margin: getMargin(left: 20, top: 36, right: 56),
            child: Text(
                "By continuing, you will receive a verification code via text message.\n\nMessage and data rates may apply. "
                    .tr,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: theme.textTheme.titleSmall)),
      ],
    );
  }

  pageTermsAndPrivacy() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        termsAndServices(),
        privacyPolicy(),
      ],
    );
  }

  nextButton(
    BuildContext context,
    LoginController loginController,
  ) {
    bool disable = (loginController.isPhonenumberEntered &&
            loginController.phonenumberController.text.isNotEmpty)
        ? true
        : false;

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  disable
                      ? loginController.sendOtp(
                          loginController.phonenumberController.text,
                          loginController.selectedCountryCode,
                          context)
                      : null;
                }

                // Handle back button tap here
              },
              splashColor: Colors.transparent, // To disable splash effect
              highlightColor: Colors.transparent, // To disable highlight effect
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: disable
                      ? const Color(0xFFAF6CDA)
                      : const Color(0xFFAF6CDA).withOpacity(0.45),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showCustomDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Option 1'),
              onTap: () {
                setState(() {
                  selectedValue = 'Option 1';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Option 2'),
              onTap: () {
                setState(() {
                  selectedValue = 'Option 2';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Option 3'),
              onTap: () {
                setState(() {
                  selectedValue = 'Option 3';
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class Country {
  final String code;
  final String flag;

  Country({required this.code, required this.flag});
}
