import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/core/utils/validation_functions.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final LoginController landingPageController = Get.find<LoginController>();
  bool enable = true;

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
                children: [
                  Expanded(
                      child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: buildImage(),
                  )),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        SizedBox(
                            height: 70,
                            child: Text(
                              "Forgot your password?",
                              style: SafeGoogleFont("Poppins",
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff868889)),
                            )),
                        emailSection(landingPageController, context),
                        SizedBox(
                          width: Get.width,
                          height: 65,
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
                                      .forgotPassword();
                                  if (val == true) {
                                    setState(() {
                                      landingPageController.displayErrorMsg =
                                          true;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                "Send",
                                style: SafeGoogleFont("Poppins",
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
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
        Image.asset(
          'assets/images/loginMainCarrot.png',
          width: 100.0,
          height: 200,
          fit: BoxFit.cover,
        ),
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
                    "Enter email address",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: SafeGoogleFont("Poppins",
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff868889)),
                  )),
              CustomTextFormField(
                  controller: controller.forgotPasswordController,
                  margin: getMargin(left: 20, top: 14, right: 20, bottom: 5),
                  hintText: "",
                  textInputType: TextInputType.emailAddress,
                  alignment: Alignment.center,
                  onChanged: (value) {
                    setState(() {
                      landingPageController.displayErrorMsg = false;
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
              const SizedBox(height: 5),
              controller.displayErrorMsg == true
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(22, 0, 2, 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(controller.errorMsg,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red)),
                      ),
                    )
                  : Container()
            ],
          )
        ]);
  }
}
