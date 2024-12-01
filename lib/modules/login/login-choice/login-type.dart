import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/custom_button_style.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/custom_elevated_button.dart';
import 'package:flutter_demo/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore_for_file: must_be_immutable
class LoginChooseType extends StatefulWidget {
  const LoginChooseType({super.key});

  @override
  LoginChooseTypeState createState() => LoginChooseTypeState();
}

class LoginChooseTypeState extends State<LoginChooseType> {
  final LoginController loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    getUserNameFromSession1();
  }

  Future getUserNameFromSession1() async {
    await loginController.getUserNameFromSession();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return GetBuilder<LoginController>(builder: (loginController) {
      return SafeArea(
        child: Scaffold(
          appBar: appBar(),
          backgroundColor: theme.colorScheme.onPrimaryContainer.withOpacity(1),
          body: SingleChildScrollView(
            child: SizedBox(
              width: double.maxFinite,
              height: Get.height - appBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: getPadding(
                            left: 20,
                            top: 26,
                          ),
                          child: Text(
                            "Hi ${loginController.currentUserName.text}, are you a...",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      CustomElevatedButton(
                        onTap: () {
                          loginController.customerLoginType('buyer', context);
                        },
                        text: "Buyer",
                        margin: getMargin(
                          left: 20,
                          top: 32,
                          right: 20,
                        ),
                        buttonStyle: CustomButtonStyles.fillPrimaryTL5.copyWith(
                            fixedSize: MaterialStateProperty.all<Size>(Size(
                          double.maxFinite,
                          getVerticalSize(
                            43,
                          ),
                        ))),
                        buttonTextStyle: theme.textTheme.titleMedium!,
                      ),
                      CustomElevatedButton(
                        onTap: () {
                          loginController.customerLoginType('seller', context);
                        },
                        text: "Seller",
                        margin: getMargin(
                          left: 20,
                          top: 16,
                          right: 20,
                        ),
                        buttonStyle: CustomButtonStyles.fillPrimaryTL5.copyWith(
                            fixedSize: MaterialStateProperty.all<Size>(Size(
                          double.maxFinite,
                          getVerticalSize(
                            43,
                          ),
                        ))),
                        buttonTextStyle: theme.textTheme.titleMedium!,
                      ),
                      CustomElevatedButton(
                        onTap: () {
                          loginController.customerLoginType('both', context);
                        },
                        text: "Both",
                        margin: getMargin(
                          left: 20,
                          top: 16,
                          right: 20,
                        ),
                        buttonStyle: CustomButtonStyles.fillPrimaryTL5.copyWith(
                            fixedSize: MaterialStateProperty.all<Size>(Size(
                          double.maxFinite,
                          getVerticalSize(
                            43,
                          ),
                        ))),
                        buttonTextStyle: theme.textTheme.titleMedium!,
                      ),
                      Container(
                        height: getVerticalSize(
                          495,
                        ),
                        width: double.maxFinite,
                        margin: getMargin(
                          top: 85,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.customerTypeImage1,
                              height: getVerticalSize(
                                495,
                              ),
                              width: getHorizontalSize(
                                428,
                              ),
                              alignment: Alignment.center,
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.customerTypeImage2,
                              height: getVerticalSize(
                                328,
                              ),
                              width: getHorizontalSize(
                                428,
                              ),
                              alignment: Alignment.bottomCenter,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Container(
        padding: getPadding(
          top: 2,
          bottom: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
          image: DecorationImage(
            image: AssetImage(
              ImageConstant.imgGroup76,
            ),
            fit: BoxFit.fitWidth,
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
          actions: const [],
        ),
      ),
    );
  }
}

popUpMenu() {
  return PopupMenuButton(
    icon: const Icon(Icons.menu),
    offset: const Offset(0, 40),
    iconSize: 20,
    itemBuilder: (context) {
      return [
        const PopupMenuItem<int>(
          value: 0,
          child: Text("Profile"),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Text("Settings"),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: GestureDetector(
              onTap: () {
                Get.toNamed('/splashScreen');
              },
              child: const Text("Logout")),
        ),
      ];
    },
  );
}
