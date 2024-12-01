import "package:flutter/material.dart";
import "package:flutter_demo/core/utils/image_constant.dart";
import "package:flutter_demo/core/utils/size_utils.dart";
import "package:flutter_demo/values/app_constant.dart";
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_subtitle.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import "package:get/get.dart";

class AppBarSmall extends StatelessWidget {
  const AppBarSmall({super.key, required this.pageNumber});

  final String pageNumber;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return appBar(pageNumber);
    });
  }

  Widget appBar(String pageNumber) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: Container(
          padding: getPadding(top: 2, bottom: 2),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImageConstant.imgGroup76),
                  fit: BoxFit.cover)),
          child: CustomAppBar(
              height: getVerticalSize(60),
              leadingWidth: 32,
              leading: AppbarImage(
                  height: getVerticalSize(15),
                  width: getHorizontalSize(7),
                  svgPath: ImageConstant.imgArrowleft,
                  margin: getMargin(left: 22, top: 15, bottom: 15),
                  onTap: () {
                    onTapArrowleft();
                  }),
              centerTitle: true,
              title: AppbarImage(
                  height: getVerticalSize(46),
                  width: getHorizontalSize(120),
                  svgPath: ImageConstant.imgBunnylogorgbfc),
              actions: [
                dislaySteps(pageNumber),
              ])),
    );
  }

  onTapArrowleft() {
    Get.back();
  }

  dislaySteps(pageNumber) {
    if (pageNumber == '4') {
      return Container();
    } else {
      return Center(
        child: AppbarSubtitle(
          text: "Step $pageNumber of 3".tr,
          margin: getMargin(right: 20),
        ),
      );
    }
  }
}
