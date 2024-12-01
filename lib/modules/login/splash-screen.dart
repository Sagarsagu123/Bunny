import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 2500), () {
      Get.offAllNamed('/loginOptions');
    });

    double baseWidth = 428;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            height: 900 * fem,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0 * fem,
                  top: 0 * fem,
                  child: Align(
                    child: SizedBox(
                      width: 428.45 * fem,
                      height: 900 * fem,
                      child: Image.asset(
                        fit: BoxFit.fill,
                        'assets/images/splashNew.png',
                        width: 428.45 * fem,
                        height: 900 * fem,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
