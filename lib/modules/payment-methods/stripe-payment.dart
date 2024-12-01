import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class StripePayment1 extends StatefulWidget {
  final String amount;
  final Function(bool) onPaymentResult;
  const StripePayment1({
    super.key,
    required this.amount,
    required this.onPaymentResult,
  });

  @override
  StripePaymentState createState() => StripePaymentState();
}

class StripePaymentState extends State<StripePayment1> {
  String clientId = "pk_test_NeODEgdtsqSMsBpnR9aF5vcv";
  String secretId = "sk_test_QnXntlX92CW3Xb6NfUPRMkbj";
  Map<String, dynamic>? paymentIntent;
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<dynamic> customerDefaultShipAddress = [];
  @override
  void initState() {
    super.initState();

    _getDeliveryAddress();
    _initializeStripe();
  }

  Future _getDeliveryAddress() async {
    var jsonData = await dashboardController.getDeliveryAddress();

    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData != null && jsonData['data'] != null) {
        setState(() {
          customerDefaultShipAddress = jsonData['data']['shipping_address']
              .where((address) => address['sh_default_addr'] == true)
              .toList();
        });
      } else {
        setState(() {
          customerDefaultShipAddress = [];
        });
      }
    }
  }

  Future<void> _initializeStripe() async {
    // Fetch your publishable key from a secure location (e.g., backend server)
    // final publishableKey = await fetchPublishableKey();

    // Initialize Stripe with your publishable key
    Stripe.publishableKey = "pk_test_NeODEgdtsqSMsBpnR9aF5vcv";
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
  }

  Future<void> presentPayment(
    String finalAmount,
  ) async {
    if (customerDefaultShipAddress.isEmpty) {
      print(
          'Customer default shipping address is empty. Cannot proceed with payment.');
      return;
    }

    await stripeMakePayment(
        finalAmount, customerDefaultShipAddress, widget.onPaymentResult);
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle elevatedButtonStyle1 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 163, 62, 221)));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBarCheckOut(context),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueAccent,
                  Color.fromARGB(255, 140, 76, 151),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Do payment uing stripe",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 25),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: elevatedButtonStyle1,
                    onPressed: () async {
                      var finalAmount = widget.amount;
                      double number = double.parse(finalAmount);
                      int integerNumber = number.toInt();
                      await presentPayment(integerNumber.toString());
                    },
                    child: const Text(
                      'Make Payment',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.white,
                          fontSize: 16),
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

appBarCheckOut(BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(appBarHeight),
    child: Container(
      color: Colors.white,
      child: CustomAppBar(
        height: getVerticalSize(
          80,
        ),
        leadingWidth: 40,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 8, 15),
          child: InkWell(
              onTap: () {
                Get.toNamed('/payment');
              },
              child: const Icon(Icons.arrow_back_ios)),
        ),
        centerTitle: true,
        title: Text(
          'Stripe',
          style: SafeGoogleFont("Poppins",
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: const Color(0xff868889)),
        ),
      ),
    ),
  );
}

Future<void> stripeMakePayment(String finalAmount,
    List<dynamic> customerDefaultShipAddress, onPaymentResult) async {
  try {
    var paymentIntent = await createPaymentIntent(finalAmount, 'INR');
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                billingDetails: BillingDetails(
                    name:
                        '${customerDefaultShipAddress[0]['sh_cus_fname']} ${customerDefaultShipAddress[0]['sh_cus_lname']}',
                    email: customerDefaultShipAddress[0]['sh_cus_email'],
                    phone: customerDefaultShipAddress[0]['sh_phone1'],
                    address: Address(
                      city: customerDefaultShipAddress[0]['sh_city'].toString(),
                      country: customerDefaultShipAddress[0]['sh_country']
                          .toString(),
                      line1: customerDefaultShipAddress[0]['sh_location']
                          .toString(),
                      line2: customerDefaultShipAddress[0]['sh_location1']
                          .toString(),
                      postalCode: customerDefaultShipAddress[0]['sh_zipcode']
                          .toString(),
                      state:
                          customerDefaultShipAddress[0]['sh_state'].toString(),
                    )),
                paymentIntentClientSecret: paymentIntent![
                    'client_secret'], //Gotten from payment intent
                style: ThemeMode.dark,
                merchantDisplayName: 'Bunny'))
        .then((value) {});

    //STEP 3: Display Payment sheet
    displayPaymentSheet(onPaymentResult);
  } catch (e) {
    print(e.toString());
  }
}

Future<void> displayPaymentSheet(onPaymentResult) async {
  try {
    print("####  Display Sheet  ####");
    var val = await Stripe.instance.presentPaymentSheet();
    print(val);
    Get.snackbar(
      'Success',
      "Payment succesfully completed",
    );

    onPaymentResult(true); // Payment successful
  } on Exception catch (e) {
    onPaymentResult(false);
    if (e is StripeException) {
    } else {
      // Fluttertoast.showToast(msg: 'Unforeseen error: $e');
    }
  }
}

//create Payment
createPaymentIntent(String amount, String currency) async {
  try {
    //Request body
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
    };
    // var token =
    //     "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vc2hvcC1idW5ueS5jb20vYXBpL3VzZXJfbG9naW4iLCJpYXQiOjE3MDAyMDA5MjEsIm5iZiI6MTcwMDIwMDkyMSwianRpIjoiSEIyUndGMXFCazlSZUkyTyIsInN1YiI6MzAyLCJwcnYiOiI4N2UwYWYxZWY5ZmQxNTgxMmZkZWM5NzE1M2ExNGUwYjA0NzU0NmFhIn0.2Xo6A147X90-vv0m7IpL5CcjkzO6192-3grDV9392Mc";

    var token1 = "Bearer sk_test_QnXntlX92CW3Xb6NfUPRMkbj";
    //Make post request to Stripe
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': token1,
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
    );
    print("##########");
    print(response.body);
    return jsonDecode(response.body);
  } catch (err) {
    throw Exception(err.toString());
  }
}

//calculate Amount
calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  return calculatedAmount.toString();
}
