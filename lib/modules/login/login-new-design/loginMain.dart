import 'package:flutter/material.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';

class LoginMain extends StatelessWidget {
  const LoginMain({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            body: Column(
          children: [
            Expanded(
                child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: Image.asset('assets/images/loginmain11.png',
                  fit: BoxFit.fitWidth),
            )),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  SizedBox(
                      height: 70,
                      child: Image.asset('assets/images/bunny_Logo11.png')),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 60,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFAF6CDA)),
                        ),
                        onPressed: () {
                          Get.toNamed('/emailLogin');
                        },
                        child: Text(
                          "Login in Email",
                          style: SafeGoogleFont("Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffFFF9FF)),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: Get.width,
                    height: 60,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFAF6CDA)),
                        ),
                        onPressed: () {
                          Get.toNamed('/numberLogin');
                        },
                        child: Text(
                          "Mobile Number",
                          style: SafeGoogleFont("Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        )),
      ),
    );
  }
}
