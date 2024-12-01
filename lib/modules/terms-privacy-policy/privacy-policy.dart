import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Bunny Privacy Policy'),
      ),
      body: const SizedBox(
        width: 388,
        height: 18,
        child: Text(
          'Bunny Privacy Policy',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            letterSpacing: -0.15,
          ),
        ),
      ),
    );
  }

  onTapArrowleft() {
    Get.back();
  }
}
