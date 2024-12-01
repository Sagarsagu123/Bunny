import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/cart/my-cart.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutBunny extends StatefulWidget {
  const AboutBunny({super.key});

  @override
  AboutBunnyState createState() => AboutBunnyState();
}

class AboutBunnyState extends State<AboutBunny> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBar(dashboardController, "About", context, true),
          body: SizedBox(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Bunny',
                        style: TextStyle(
                            fontSize: 35,
                            color: Color.fromARGB(255, 160, 59, 146),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      children: [
                        Text(
                          'Version: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '1.0.0+9',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Wrap(children: [
                      Text(
                        'Description: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Bunny is your go-to marketplace app for buying and selling a wide range of products and services. Whether you\'re looking for vintage treasures, handmade crafts, or freelance services, Bunny connects you with a vibrant community of buyers and sellers.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    const Text(
                      'Acknowledgments:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'List of any third-party libraries, resources, or contributions used in the app',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchURL(PRIVACYPOLICY);
                          },
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {
                            _launchURL(TERMAANDCONDITIONS);
                          },
                          child: const Text(
                            'Terms of Service',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Release Notes:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Brief summary of recent updates, improvements, and bug fixes',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Feedback:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      children: [
                        Text(
                          'We value your feedback! If you have any suggestions, questions, or concerns, please don\'t hesitate to contact us at ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'meetbunny.app@gmail.com.',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 50),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
