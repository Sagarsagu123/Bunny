import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: Get.height,
        child: Scaffold(
          appBar: appBar11(dashboardController, "Help", context, true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to the Help Center!',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'If you have any questions or issues, please refer to the following information:',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '1. How to Use Our App:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Learn how to navigate and use our application effectively.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2. Frequently Asked Questions:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Q: How do I change my profile picture?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'A: You can change your profile picture by going to the Profile section and selecting "Edit Profile." From there, you can upload a new picture.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  // Additional FAQs
                  const SizedBox(height: 20),
                  // const Text(
                  //   'Q: How do I reset my password?',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // const Text(
                  //   'A: To reset your password, go to the login screen and tap on "Forgot Password." Follow the instructions sent to your email to reset your password.',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //   ),
                  // ),
                  // const SizedBox(height: 20),
                  const Text(
                    'Q: How do I update the app?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'A: You can update the app from the App Store (iOS) or Play Store (Android) by navigating to the app page and tapping on the "Update" button.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Contact Support options (unchanged)
                  ListTile(
                    leading: Image.asset(
                      'assets/images/phone.png',
                      width: 24,
                      height: 24,
                    ),
                    title: const Text('Contact Support'),
                    subtitle: const Text('+1-276-616-1600'),
                    onTap: () {
                      launchURL("tel:+12766161600");
                    },
                  ),
                  ListTile(
                    leading: Image.asset(
                      'assets/images/whatsapp.png',
                      width: 26,
                      height: 26,
                    ),
                    title: const Text('WhatsApp Support'),
                    subtitle: const Text('+1-276-616-1600'),
                    onTap: () async {
                      String whatsappUrl = "whatsapp://send?phone=+12766161600";
                      bool isWhatsAppInstalled = await canLaunch(whatsappUrl);
                      if (isWhatsAppInstalled) {
                        await launch(whatsappUrl);
                      } else {
                        Get.snackbar('Error',
                            "WhatsApp is not installed on this device.",
                            snackPosition: SnackPosition.bottom,
                            duration: const Duration(milliseconds: 2200));

                        throw 'WhatsApp is not installed on this device.';
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.facebook_outlined,
                      color: Color.fromARGB(255, 42, 40, 156),
                      size: 25,
                    ),
                    title: const Text('Facebook Support'),
                    subtitle: const Text('@MeetBunny'),
                    onTap: () {
                      // Open Facebook page here

                      launchURL("https://www.facebook.com/yourpagename");
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  appBar11(DashboardController dashboardController, String title,
      BuildContext context, bool val) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 5),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 10, bottom: 2, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            50,
          ),
          leadingWidth: 32,
          leading: InkWell(
              onTap: () {
                Get.offAllNamed('/dashboard');
              },
              child: const Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              title,
              style: SafeGoogleFont(
                "Poppins",
                fontWeight: FontWeight.w500,
                color: const Color(0xff808089),
                fontSize: 20,
              ),
            ),
          ),
          actions: [
            // CircleAvatar(
            //   backgroundImage: AssetImage('assets/images/Mask.png'),
            // )
            val == true
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage(dashboardController.currentUserImage),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
