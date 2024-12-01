import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/core/utils/validation_functions.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_image_view.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginSwitch extends StatefulWidget {
  const LoginSwitch({super.key});

  @override
  LoginSwitchNewState createState() => LoginSwitchNewState();
}

class LoginSwitchNewState extends State<LoginSwitch> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (controller) {
      return Scaffold(
          appBar: appBar(),
          body: SingleChildScrollView(
              child: SizedBox(
                  height: Get.height - appBarHeight,
                  child: Column(
                    children: [
                      controller.displayOnlyEmail != 'no'
                          ? emailSection(controller, context)
                          : Container(),
                      const SizedBox(
                        height: 10,
                      ),
                      controller.displayPasswordAndNextButton == 'email'
                          ? passwordFieldWithNextButton(controller)
                          : Container(),
                      (controller.displayOnlyotp != 'no' &&
                              controller.displayOnlyEmail != 'no')
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("or"),
                            )
                          : Container(),
                      (controller.displayOnlyotp != 'no' &&
                              controller.displayOnlyEmail != 'no')
                          ? otpSection(controller)
                          : Container(),
                      const SizedBox(height: 20),
                      controller.displayPasswordAndNextButton == 'otp'
                          ? displayFieldAfterSentOtp(controller)
                          : Container(),
                      controller.displayPasswordAndNextButton == 'otp'
                          ? verificationWithNextButton(controller)
                          : Container(),
                      const SizedBox(height: 20),
                      (controller.displayOnlyotp != 'no' &&
                              controller.displayOnlyEmail != 'no')
                          ? nextButton(controller)
                          : Container(),
                    ],
                  ))));
    });
  }

  emailSection(LoginController controller, BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                  padding: getPadding(left: 20, top: 19),
                  child: Text("Email address".tr,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.titleSmall)),
              CustomTextFormField(
                  controller: controller.emailLoginControllerN,
                  margin: getMargin(left: 20, top: 14, right: 20),
                  hintText: "Enter email address".tr,
                  textInputType: TextInputType.emailAddress,
                  alignment: Alignment.center,
                  onChanged: (value) {
                    controller.onEnteredEmail(
                        controller.emailLoginControllerN.text.trim());
                  },
                  validator: (value) {
                    if (value == null ||
                        (!isValidEmail(value, isRequired: true))) {
                      return "Please enter valid email";
                    }
                    return null;
                  }),
              controller.isEmailValid11
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(22, 5, 2, 5),
                      child: Text("Enter Correct Email Address",
                          style: TextStyle(fontSize: 10, color: Colors.red)),
                    )
                  : Container(),
            ],
          )
        ]);
  }

  otpSection(LoginController loginController) {
    return Column(
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
            controller: loginController.phonenumberLoginControllerN,
            margin: getMargin(left: 20, top: 14, right: 20),
            maxLength: 10,
            hintText: "Enter phone number".tr,
            textInputType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')),
            ],
            alignment: Alignment.center,
            onChanged: (value) {
              loginController.onEnteredPhoneNumber();
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
        loginController.loginSendOtpSuccessMsg != null
            ? Container(
                width: getHorizontalSize(351),
                margin: getMargin(left: 20, top: 36, right: 56),
                child: Text("${loginController.loginSendOtpSuccessMsg}",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.red)))
            : Container(),
      ],
    );
  }

  appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: Container(
        padding: getPadding(
          top: 2,
          bottom: 2,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgGroup76,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: CustomAppBar(
          height: getVerticalSize(
            52,
          ),
          centerTitle: true,
          title: AppbarImage(
            height: getVerticalSize(
              46,
            ),
            width: getHorizontalSize(
              120,
            ),
            svgPath: ImageConstant.imgBunnylogorgbfc,
          ),
          actions: const [
            // popUpMenu()
          ],
        ),
      ),
    );
  }

  nextButton(LoginController loginController) {
    bool disable = (loginController.emailLoginControllerN.text.isNotEmpty ||
            loginController.phonenumberLoginControllerN.text.isNotEmpty == true)
        ? true
        : false;
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(disable
          ? const Color(0xFFAF6CDA)
          : const Color(0xFFAF6CDA).withOpacity(0.45)),
    );
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () {
              disable ? loginController.onClickNextButton(context) : null;
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            )),
      ),
    );
  }

  passwordFieldWithNextButton(LoginController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: getPadding(left: 20, top: 21),
              child: Text("Enter your password".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleSmall)),
        ),
        CustomTextFormField(
            controller: controller.passworForEmailLoginControllerN,
            margin: getMargin(left: 20, top: 9, right: 20),
            contentPadding: getPadding(top: 4, bottom: 4),
            hintText: "Type a password".tr,
            textInputType: TextInputType.visiblePassword,
            alignment: Alignment.center,
            onChanged: (value) {
              controller.onEnteredPassword();
            },
            suffix: InkWell(
                onTap: () {
                  controller.isShowPassword1.value =
                      !controller.isShowPassword1.value;
                },
                child: Container(
                    margin: getMargin(left: 30, right: 6, bottom: 6),
                    child: CustomImageView(
                        svgPath: controller.isShowPassword1.value
                            ? ImageConstant.imgEye
                            : ImageConstant.imgEye))),
            suffixConstraints: BoxConstraints(maxHeight: getVerticalSize(31)),
            validator: (value) {
              if (value == null ||
                  (!isValidPassword(value, isRequired: true))) {
                return "Please enter valid password";
              }
              return null;
            },
            obscureText: controller.isShowPassword1.value,
            defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
            disabledBorderDecoration:
                TextFormFieldStyleHelper.underLinePrimary),
        nextButtonEmail(controller)
      ],
    );
  }

  nextButtonEmail(LoginController loginController) {
    bool enable = (loginController.phonenumberLoginControllerN.text != '' ||
            loginController.enableLoginButton)
        ? true
        : false;
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          loginController.enableLoginButton == true
              ? const Color(0xFFAF6CDA)
              : const Color(0xFFAF6CDA).withOpacity(0.45)),
    );
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () {
              enable ? loginController.loginWithEmail(context, 'bunny') : null;
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            )),
      ),
    );
  }

  verificationWithNextButton(LoginController loginController) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: getPadding(left: 20, top: 28),
              child: Text("Verification code".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleSmall)),
        ),
        CustomTextFormField(
            controller: loginController.entercodeLoginController,
            // enableInteractiveSelection: isFieldEnabled ,
            margin: getMargin(left: 20, top: 14, right: 20),
            hintText: "Enter code".tr,
            alignment: Alignment.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              loginController.onEnteringVerificaionCode();
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
        // loginController.loginSendOtpSuccessMsg != null
        //     ? Container(
        //         width: getHorizontalSize(351),
        //         margin: getMargin(left: 20, top: 36, right: 56),
        //         child: Text("${loginController.loginSendOtpSuccessMsg}",
        //             maxLines: 4,
        //             overflow: TextOverflow.ellipsis,
        //             textAlign: TextAlign.left,
        //             style: theme.textTheme.titleSmall))
        //     : Container(),
        nextButtonVerifyOtp(loginController),
      ],
    );
  }

  nextButtonVerifyOtp(LoginController loginController) {
    bool disable =
        (loginController.isloginVerificationCodeEnteredLogin) ? true : false;

    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(disable
          ? const Color(0xFFAF6CDA)
          : const Color(0xFFAF6CDA).withOpacity(0.45)),
    );
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () {
              disable
                  ? loginController.loginVerifyOtp(
                      context,
                      loginController.mobileNumberLoginController.text,
                      loginController.entercodeLoginController.text,
                      loginController.loginTokenController.text)
                  : null;
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                "Verify",
                style: TextStyle(color: Colors.white),
              ),
            )),
      ),
    );
  }

  popUpMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.menu),
      offset: const Offset(0, 40),
      iconSize: 20,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.toNamed('/splashScreen');
                },
                child: const Text("Logout")),
          ),
        ];
      },
    );
  }

  displayFieldAfterSentOtp(controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: getPadding(left: 20, top: 24),
              child: Text("Enter the verification code sent to".tr,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleSmall)),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: getPadding(left: 20, top: 14),
              child: Text(controller.phonenumberLoginControllerN.text,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.bodyLarge)),
        ),
      ],
    );
  }
}
