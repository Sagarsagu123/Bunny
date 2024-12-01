import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/core/utils/validation_functions.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  EmailLoginState createState() => EmailLoginState();
}

class EmailLoginState extends State<EmailLogin> {
  final LoginController landingPageController = Get.find<LoginController>();
  bool isChecked = false;
  bool isShowPassword1New = false;

  bool _obscureText = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool enable =
        (landingPageController.emailLoginControllerN.text != '') ? true : true;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            body: SingleChildScrollView(
          child: SizedBox(
            height: Get.height,
            child: Stack(children: [
              Column(
                children: [
                  Expanded(
                      child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: buildImage(),
                  )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 10, 30, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SizedBox(
                                child: Text(
                              "Email Address",
                              style: SafeGoogleFont("Poppins",
                                  fontSize: 28,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                  letterSpacing: -0.3,
                                  color: const Color(0xff868889)),
                            )),
                          ),
                        ),
                        inputFieldsSection(landingPageController, context),
                        SizedBox(
                          width: Get.width,
                          height: 45,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        enable == true
                                            ? const Color(0xFFAF6CDA)
                                            : const Color(0xFFAF6CDA)
                                                .withOpacity(.3)),
                              ),
                              onPressed: () async {
                                if (enable == true) {
                                  bool val = await landingPageController
                                      .loginWithEmail(context, 'bunny');
                                  if (val == true) {
                                    setState(() {
                                      landingPageController.displayErrorMsg =
                                          true;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                "LOG IN",
                                style: SafeGoogleFont("Poppins",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        forgotPassword(landingPageController),
                        const SizedBox(
                          height: 15,
                        )
                      ],
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
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF1F1F5),
            ),
            child: const Padding(
              padding: EdgeInsets.all(6.0),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/loginmain11.png',
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ],
    );
  }

  inputFieldsSection(LoginController controller, BuildContext context) {
    return Column(
      children: [
        emailSection(controller, context),
        passwordField(controller),
        rememberMeSection(controller),
      ],
    );
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
              Padding(
                  padding: getPadding(left: 20, top: 19),
                  child: Text(
                    "Email address",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: SafeGoogleFont("Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff868889)),
                  )),
              CustomTextFormField(
                  controller: controller.emailLoginControllerN,
                  margin: getMargin(left: 20, top: 5, right: 20, bottom: 5),
                  hintText: "Enter email address".tr,
                  textInputType: TextInputType.emailAddress,
                  alignment: Alignment.center,
                  onChanged: (value) {
                    setState(() {
                      controller.displayErrorMsg = false;
                    });
                  },
                  validator: (value) {
                    if (value == null ||
                        (!isValidEmail(value, isRequired: true))) {
                      return "Please enter email";
                    }
                    return null;
                  }),
              const SizedBox(
                height: 5,
              ),
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

  passwordField(LoginController controller) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: getPadding(left: 20, top: 10),
              child: Text(
                "Enter your password",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: SafeGoogleFont("Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff868889)),
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: TextFormField(
            controller: controller.passworForEmailLoginControllerN,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: "Type your password",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: const Color(0xFFAF6CDA),
                ),
                onPressed: _togglePasswordVisibility,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFF868889),
                ), // Change color here
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFAF6CDA),
                ), // Change color here
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            onChanged: (value) {
              controller.onEnteredPassword();
              setState(() {
                controller.displayErrorMsg = false;
              });
              // Your onChanged logic here
            },
          ),
        ),
        controller.displayErrorMsg == true
            ? Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 2, 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(controller.errorMsg,
                      style: const TextStyle(fontSize: 12, color: Colors.red)),
                ),
              )
            : Container(),
        // CustomTextFormField(
        //     controller: controller.passworForEmailLoginControllerN,
        //     margin: getMargin(left: 20, top: 9, right: 20, bottom: 10),
        //     contentPadding: getPadding(top: 4, bottom: 4),
        //     hintText: "Type your password",
        //     textInputType: TextInputType.visiblePassword,
        //     alignment: Alignment.center,
        //     onChanged: (value) {
        //       controller.onEnteredPassword();
        //       setState(() {
        //         controller.displayErrorMsg = false;
        //       });
        //     },
        //     suffix: InkWell(
        //         onTap: () {
        //           isShowPassword1New = !isShowPassword1New;
        //         },
        //         child: isShowPassword1New
        //             ? Image.asset(ImageConstant.eyeOpen)
        //             : Image.asset(ImageConstant.eyeClose)),
        //     suffixConstraints: BoxConstraints(maxHeight: getVerticalSize(31)),
        //     validator: (value) {
        //       if (value == null ||
        //           (!isValidPassword(value, isRequired: true))) {
        //         return "Please enter valid password";
        //       }
        //       return null;
        //     },
        //     obscureText: !isShowPassword1New,
        //     defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        //     enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        //     focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        //     disabledBorderDecoration:
        //         TextFormFieldStyleHelper.underLinePrimary),
        // const SizedBox(height: 5),
        // controller.displayErrorMsg == true
        //     ? Padding(
        //         padding: const EdgeInsets.fromLTRB(22, 0, 2, 5),
        //         child: Align(
        //           alignment: Alignment.topLeft,
        //           child: Text(controller.errorMsg,
        //               style: const TextStyle(fontSize: 12, color: Colors.red)),
        //         ),
        //       )
        //     : Container()
      ],
    );
  }

  rememberMeSection(LoginController controller) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return const Color(0xFFAF6CDA);
    }

    return Padding(
      padding: getPadding(left: 20),
      child: Row(children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "Remember me ?",
          style: SafeGoogleFont("Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xff868889)),
        )
      ]),
    );
  }

  forgotPassword(LoginController controller) {
    return Align(
      alignment: Alignment.topRight,
      child: InkWell(
        onTap: () {
          Get.toNamed('/forgotPassword');
        },
        child: Text(
          "Forgot Password?",
          style: SafeGoogleFont("Poppins",
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xff868889)),
        ),
      ),
    );
  }
}
