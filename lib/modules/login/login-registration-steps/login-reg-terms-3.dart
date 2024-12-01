import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/app_bar/appp_bar_small.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/custom_button_style.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/values/app_constant.dart';
// import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_elevated_button.dart';
import 'package:get/get.dart';

class LoginRegTermsPage extends StatelessWidget {
  LoginRegTermsPage({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<LoginController>(builder: (loginController) {
        return SizedBox(
          height: Get.height - appBarHeight,
          child: Scaffold(
              appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(appBarHeight),
                  child: AppBarSmall(pageNumber: '3')),
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
                            Expanded(
                                child: Container(
                              padding: getPadding(
                                  left: 20, top: 24, right: 20, bottom: 24),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    reviewText(),
                                    termsAndServices(),
                                    privacyPolicy(),
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    accectTermsAndComditions(loginController)
                                  ]),
                            ))
                          ])))),
        );
      }),
    );
  }

  onTapArrowleft() {
    Get.back();
  }

  termsAndServices() {
    return Padding(
        padding: getPadding(top: 50),
        child: Text(
          "Terms of Service".tr,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ));
  }

  privacyPolicy() {
    return Padding(
        padding: getPadding(top: 41),
        child: Text(
          "Privacy Policy".tr,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ));
  }

  reviewText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Please review our terms".tr,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w500,
            height: 1.2575,
            color: Color(0xff000000),
          ),
        ),
        Container(
            width: getHorizontalSize(370),
            margin: getMargin(top: 10, right: 17),
            child: Text(
              "Thanks for joining Bunny! To start buying and selling, please agree to our Terms of Service and Privacy Policy."
                  .tr,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.2575,
                color: Color(0xff000000),
              ),
            )),
      ],
    );
  }

  accectTermsAndComditions(LoginController loginController) {
    return CustomElevatedButton(
        text: "Accept terms and continue".tr,
        onTap: () => {
              print("accept term and conditions"),
              loginController.acceptTermsAndCondition()
            },
        buttonStyle: CustomButtonStyles.fillPrimaryTL5.copyWith(
            fixedSize: MaterialStateProperty.all<Size>(
                Size(double.maxFinite, getVerticalSize(43)))),
        buttonTextStyle: theme.textTheme.titleMedium!);
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height); // Start from the bottom-left corner
    path.quadraticBezierTo(size.width / 2, size.height + 20, size.width,
        size.height); // Create a quadratic curve
    path.lineTo(size.width, 0); // Close the path
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; // We don't need to reclip since the path is fixed
  }
}
