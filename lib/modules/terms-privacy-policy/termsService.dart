import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsAndServices extends StatelessWidget {
  const TermsAndServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Bunny SMS Terms of Service'),
      ),
      body: const SizedBox(
        width: 388,
        height: 18,
        child: Text(
          'Bunny SMS Terms of Service',
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
