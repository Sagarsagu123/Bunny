import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';

class LoginRegUserDetailsPage extends StatefulWidget {
  const LoginRegUserDetailsPage({super.key});

  @override
  LoginRegUserDetailsPageState createState() => LoginRegUserDetailsPageState();
}

class LoginRegUserDetailsPageState extends State<LoginRegUserDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController controller = Get.find<LoginController>();

  bool _obscureText = true;
  bool _obscureText1 = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _togglePasswordVisibility1() {
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBar11(),
          backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: double.maxFinite,
                // height: Get.height - appBarHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    displayFirstName(controller),
                    displayLastName(controller),
                    emailAddress(controller),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Container(
                            width: Get.width,
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Create a password',
                              style: SafeGoogleFont(
                                  color: const Color(0xFF868889),
                                  'Poppins',
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.15),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: TextFormField(
                            controller: controller.passwordController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              hintText: "Type password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                              // Your onChanged logic here
                            },
                          ),
                        ),

                        controller.ispassword
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(22, 5, 2, 5),
                                child: Text("Criteria doesnt match",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: theme.textTheme.titleSmall),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Container(
                            width: Get.width,
                            decoration: const BoxDecoration(),
                            child: Text(
                              'Confirm password',
                              style: SafeGoogleFont(
                                  color: const Color(0xFF868889),
                                  'Poppins',
                                  fontSize: 15,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.15),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: TextFormField(
                            controller: controller.passwordoneController,
                            obscureText: _obscureText1,
                            decoration: InputDecoration(
                              hintText: "Retype a password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText1
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFFAF6CDA),
                                ),
                                onPressed: _togglePasswordVisibility1,
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
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            autofocus: false,
                            onChanged: (value) {
                              controller.confirmPassword();
                            },
                            onEditingComplete: () {
                              controller.updateUserInfo(context);
                            },
                          ),
                        ),
                        // after password matched
                        controller.isCpassword
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                    padding: getPadding(top: 9, right: 20),
                                    child: Text(
                                      "Passwords Match ".tr,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                    )))
                            : Container(),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    nextButton(controller, context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  nextButton(LoginController loginController, BuildContext context) {
    bool disable = (loginController.isCpassword &&
                !loginController.isEmailValid1 &&
                !loginController.isDisplayF ||
            !loginController.isDisplayL)
        ? true
        : true;

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
            onPressed: () async {
              if (disable) {
                await loginController.updateUserInfo(context);
              }
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

  displayFirstName(LoginController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: SizedBox(
            width: Get.width,
            // decoration: const BoxDecoration(),
            child: Text(
              'First name',
              style: SafeGoogleFont(
                  color: const Color(0xFF868889),
                  'Poppins',
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15),
            ),
          ),
        ),
        CustomTextFormField(
          controller: controller.displayFirstNameController,
          margin: getMargin(left: 20, top: 14, right: 20),
          hintText: "5-20 characters".tr,
          focusNode: controller.focusNodeDisplayFirstname,
          textInputAction: TextInputAction.next,
          autofocus: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z 0-9_]')),
          ],
          alignment: Alignment.center,
          onChanged: (value) {
            controller.displayF();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter first name';
            }
            return null;
          },
        ),
        controller.isDisplayF
            ? const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "     First Name cannot be Empty",
                  style: TextStyle(color: Colors.red),
                ),
              )
            : Container(),
      ],
    );
  }

  displayLastName(LoginController controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(),
            child: Text(
              'Last name',
              style: SafeGoogleFont(
                  color: const Color(0xFF868889),
                  'Poppins',
                  fontSize: 15,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15),
            ),
          ),
        ),
        CustomTextFormField(
          controller: controller.displayLastNameController,
          margin: getMargin(left: 20, top: 14, right: 20),
          hintText: "5-20 characters".tr,
          focusNode: controller.focusNodeDisplayLastname,
          textInputAction: TextInputAction.next,
          autofocus: false,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z 0-9_]')),
          ],
          alignment: Alignment.center,
          onChanged: (value) {
            controller.displayL();
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter last name';
            }
            return null;
          },
        ),
        controller.isDisplayL
            ? const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "     Last Name cannot be Empty",
                  style: TextStyle(color: Colors.red),
                ),
              )
            : Container(),
      ],
    );
  }
}

appBar11() {
  return PreferredSize(
    preferredSize: const Size.fromHeight(appBarHeight + 30),
    child: Container(
      color: Colors.white,
      padding: getPadding(top: 10, bottom: 10, left: 20, right: 20),
      child: CustomAppBar(
        height: getVerticalSize(
          70,
        ),
        leadingWidth: 32,
        leading: InkWell(
            onTap: () {
              // Get.toNamed(
              //   '/displayMoreProducts',
              //   parameters: {
              //     'main_category_id': dashboardController.categoryName!,
              //     'categoryName': dashboardController.selectedCategoryId!,
              //   },
              // );
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

emailAddress(LoginController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
        child: Container(
          width: Get.width,
          decoration: const BoxDecoration(),
          child: Text(
            'Email',
            style: SafeGoogleFont(
                color: const Color(0xFF868889),
                'Poppins',
                fontSize: 15,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.15),
          ),
        ),
      ),
      CustomTextFormField(
        controller: controller.emailController,
        focusNode: controller.focusNodeReenterPassword,
        margin: getMargin(left: 20, top: 14, right: 20),
        hintText: "Type your email".tr,
        textInputAction: TextInputAction.next,
        alignment: Alignment.center,
        autofocus: false,
        onChanged: (value) {
          controller.emailValidation();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter email ';
          }
          return null;
        },
        defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        disabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
      ),
      controller.isEmailValid1
          ? Padding(
              padding: const EdgeInsets.fromLTRB(22, 5, 2, 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter Correct Email Address",
                  style: theme.textTheme.titleSmall,
                ),
              ),
            )
          : Container(),
    ],
  );
}
