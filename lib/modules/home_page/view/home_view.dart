import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/login/splash-screen.dart';
import 'package:get/get.dart';

class HomePage extends GetView {
  HomePage({
    super.key,
  });

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          key: scaffoldKey,
          body: SizedBox(
              height: Get.height,
              width: Get.width,
              child: const SingleChildScrollView(child: SplashScreen())),
        ),
      ),
    );
  }
}
