import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

class LoginRegVerification extends StatefulWidget {
  const LoginRegVerification({super.key});

  @override
  State<LoginRegVerification> createState() => _LoginRegVerificationState();
}

class _LoginRegVerificationState extends State<LoginRegVerification> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBar11(),
          body: SingleChildScrollView(
            child: SizedBox(
                height: Get.height,
                child: Form(
                    key: _formKey,
                    child: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        verificationOptions(
                                            context, loginController),
                                        nextButton(context, loginController),
                                        resendCode(context, loginController),
                                        pageTermsAndPrivacy(),
                                      ]))
                            ])))),
          ),
        ),
      ),
    );
  }

  termsAndServices() {
    return Padding(
      padding: getPadding(left: 18, top: 16),
      child: SizedBox(
        width: Get.width,
        child: Text(
          'Bunny SMS Terms of Service',
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
    );
  }

  privacyPolicy() {
    return Padding(
      padding: getPadding(left: 18, top: 16),
      child: SizedBox(
        width: Get.width,
        child: InkWell(
          onTap: () {},
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

  verificationOptions(BuildContext context, LoginController loginController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(),
            child: Text(
              'Verification Code',
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  "We have sent the code verification to",
                  style: SafeGoogleFont(
                    color: const Color(0xFF838383),
                    'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.15,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "your number  ",
                      style: SafeGoogleFont(
                        color: const Color(0xFF838383),
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.15,
                      ),
                    ),
                    Text(
                      "${loginController.selectedCountryCode} ${loginController.phonenumberController.text}",
                      style: SafeGoogleFont(
                        color: const Color(0xFF191D31),
                        'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(),
            child: Text(
              'Verification Code',
              style: SafeGoogleFont(
                color: const Color(0xFF868889),
                'Poppins',
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        CustomTextFormField(
            controller: loginController.entercodeController,
            margin: getMargin(left: 20, top: 14, right: 20),
            hintText: "Enter code".tr,
            alignment: Alignment.center,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              loginController.verificationCodeEntered();
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Enter OTP';
              }
              return null;
            },
            defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            disabledBorderDecoration:
                TextFormFieldStyleHelper.underLinePrimary),
        loginController.displayErr == true
            ? Container(
                width: getHorizontalSize(351),
                margin: getMargin(left: 20, top: 36, right: 56),
                child: Text(loginController.errMsg,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.red)))
            : Container(),
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

  resendCode(BuildContext context, LoginController loginController) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Text(
            "Didn’t get a text? ",
            style: SafeGoogleFont(
              color: const Color(0xFF838383),
              'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.15,
            ),
          ),
          InkWell(
            onTap: () {
              loginController.sendOtp(
                  context,
                  loginController.phonenumberController.text,
                  loginController.selectedCountryCode);
            },
            child: Text(
              " Resend code",
              style: SafeGoogleFont(
                color: const Color(0xFFAF6CDA),
                'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  nextButton(BuildContext context, LoginController loginController) {
    bool disable = (loginController.isVerificationCodeEntered == true ||
            loginController.phonenumberController.text.isNotEmpty)
        ? true
        : false;

    ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: (loginController.disableSubmit == false
          ? const Color(0xFFAF6CDA)
          : const Color(0xFFAF6CDA).withOpacity(0.45)), // Set button color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                width: 364,
                height: 67,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ElevatedButton(
                  style: elevatedButtonStyle,
                  onPressed: () {
                    setState(() {
                      loginController.disableSubmit == false
                          ? loginController.verifyOtp(
                              context, loginController.selectedCountryCode)
                          : null;
                      disable == false;
                    });
                  },
                  child: Text(
                    'Submit',
                    style: SafeGoogleFont(
                      color: Colors.white, // Set text color to white
                      'Poppins',
                      fontSize: 24,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      height: 0.75,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
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
          leading: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
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
}
