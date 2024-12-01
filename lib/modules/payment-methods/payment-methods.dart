// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/modules/dialog_utils.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:get/get.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<Payment> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();
  int selectedIndex =
      2; // Initialize with the index of the default method to STRIPE

  bool isChecked = false;
  bool useOnlywalletAmount = false;
  bool usingPartialwalletAmountFromCustomer = false;

  List<Widget> paymentMethodButtons = [];
  String buttonName = 'Pay';
  String? totalAmountForCheckout;
  String? partialWalletAmoutUsed;
  String? subTotalForCheckout;
  String? deliveryFeeForCheckout;
  String currencyType = "\$";
  @override
  void initState() {
    super.initState();
    fetchPaymentDetails();
    _getAuthCode();
  }

  Future? _getAuthCode() async {
    var totalAmount = await Auth.getTotalAmount();
    var subTotal = await Auth.getSubTotalAmount();
    var deliveryFee = await Auth.getDeliveryFee();
    var currencyCode = await Auth.getCurrencyCode();
    setState(() {
      totalAmountForCheckout = totalAmount;
      subTotalForCheckout = subTotal;
      deliveryFeeForCheckout = deliveryFee;
      currencyType = currencyCode ?? "\$";
    });
    return null;
  }

  Future useWallet(bool value) async {
    if (value == false) {
      setState(() {
        dashboardController.walletDetails = null;
        useOnlywalletAmount = false;
        usingPartialwalletAmountFromCustomer = false;
        selectedIndex = 2;
        buttonName = 'Pay';
      });
      await _getAuthCode();
    } else if (value == true) {
      var jsonData = await dashboardController.useWallet();
      if (jsonData != null && jsonData['code'] == 400) {
        setState(() {
          dashboardController.walletDetails = null;
        });

        await showCustomDialog("Error", jsonData['message'], context, true);
      } else {
        if (jsonData != null) {
          if (jsonData['code'] == 200 &&
              jsonData['message'] == "No need to pay") {
            setState(() {
              dashboardController.walletDetails = jsonData['data'];
              useOnlywalletAmount = true;
              // deliveryFeeForCheckout =
              //     jsonData['data']["used_wallet"].toString();
              // subTotalForCheckout = jsonData['data']["used_wallet"].toString();
              totalAmountForCheckout =
                  jsonData['data']["used_wallet"].toString();
              buttonName = "Place Order";
              currencyType = jsonData['data']["currency_code"].toString();
              selectedIndex = 0;
            });
          } else if (jsonData['code'] == 200 &&
              jsonData['message'] == "Select anyone of payment mode") {
            setState(() {
              dashboardController.walletDetails = null;
              useOnlywalletAmount = false;
              usingPartialwalletAmountFromCustomer = true;
              currencyType = jsonData['data']["currency_code"].toString();
              totalAmountForCheckout =
                  jsonData['data']["payable_amount"].toString();
              subTotalForCheckout =
                  jsonData['data']["payable_amount"].toString();
              partialWalletAmoutUsed =
                  jsonData['data']["used_wallet"].toString();
            });
          }
        } else {
          setState(() {
            dashboardController.walletDetails = null;
          });
        }
      }
    }
  }

  Future fetchPaymentDetails() async {
    var jsonData = await dashboardController.fetchPaymentDetails();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 700));
    } else {
      if (jsonData != null) {
        setState(() {
          dashboardController.paymentDetails =
              jsonData['data']['payment_methods'];
        });
      } else {
        setState(() {
          dashboardController.paymentDetails = null;
        });
      }
    }
  }

  void resetVariables() {
    selectedIndex = 1;
    isChecked = false;
    useOnlywalletAmount = false;
    usingPartialwalletAmountFromCustomer = false;
    paymentMethodButtons = [];
    buttonName = 'Pay';
    totalAmountForCheckout;
    partialWalletAmoutUsed;
    subTotalForCheckout;
    deliveryFeeForCheckout;
    currencyType = "\$";
    dashboardController.walletDetails = null;
    dashboardController.paymentDetails = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isCodEnabled = false;
    bool isStripeEnabled = false;
    String walletAmount = '';
    if (dashboardController.paymentDetails != null) {
      isCodEnabled = dashboardController.paymentDetails['cod'] == 1;
      isStripeEnabled = dashboardController.paymentDetails['stripe'] == 1;
      walletAmount = dashboardController.paymentDetails['wallet_amt'];
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBarCheckOut(dashboardController, context),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff868889),
                    ),
                  ),
                  const SizedBox(height: 15),
                  handlePaymentMethods(isCodEnabled, isStripeEnabled),
                  const Divider(),
                  handleWallet(walletAmount),
                  // handleApplyCoupon(),
                  const SizedBox(height: 10),
                  paymentSection(),
                  const SizedBox(height: 15),
                  confirmButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmButton() {
    return Column(
      children: [
        SizedBox(
          height: 45,
          width: double.infinity,
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
              ),
              onPressed: () async {
                if (selectedIndex == 0 && useOnlywalletAmount == true) {
                  var data = await dashboardController.checkoutAPI(
                      "wallet",
                      dashboardController.ordSelfPickup!,
                      "1",
                      totalAmountForCheckout!,
                      dashboardController.shId!);
                  if (data != null && data['code'] == 200) {
                    //
                    String result = await showCustomDialog(
                        "Success", data['message'], context, false);
                    if (result == "done") {
                      setState(() {
                        dashboardController.totalCartCount = '-1';
                        dashboardController.totalCartAmount = null;
                        Auth.setTotalCartCount('0');
                      });
                      resetVariables();
                      Get.offAllNamed('/dashboard');
                    }
                  } else {
                    await showCustomDialog(
                        "Error", data['message'], context, true);
                  }
                } else if (selectedIndex == 1) {
                  print("----Cod----");
                  var data = await dashboardController.checkoutAPI(
                      "cod",
                      dashboardController.ordSelfPickup!,
                      usingPartialwalletAmountFromCustomer == true ? "1" : "0",
                      totalAmountForCheckout!,
                      dashboardController.shId!);
                  if (data != null && data['code'] == 200) {
                    //
                    String result = await showCustomDialog(
                        "Success", data['message'], context, false);
                    if (result == "done") {
                      setState(() {
                        dashboardController.totalCartCount = '-1';
                        dashboardController.totalCartAmount = null;
                        Auth.setTotalCartCount('0');
                      });
                      resetVariables();
                      Get.offAllNamed('/dashboard');
                    }
                  } else {
                    await showCustomDialog(
                        "Error", data['message'], context, true);
                  }
                } else if (selectedIndex == 2 && useOnlywalletAmount == false) {
                  print("Stripe");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StripePayment(
                        amount: totalAmountForCheckout.toString(),
                        currency: "usd",
                        onPaymentResult: (String status) async {
                          // Handle payment result here
                          if (status == "succeeded") {
                            var json = await dashboardController.checkoutAPI(
                                "stripe",
                                dashboardController.ordSelfPickup!,
                                usingPartialwalletAmountFromCustomer == true
                                    ? "1"
                                    : "0",
                                totalAmountForCheckout!,
                                '');
                            print("stripe succeed");
                            print(json);
                            setState(() {
                              dashboardController.totalCartCount = '-1';
                              Auth.setTotalCartCount('0');
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("${json['message']}"),
                            ));

                            Get.offAllNamed('/dashboard');
                          } else if (status == "canceled") {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "Payment has been canceled , please try again"),
                            ));
                            Get.back();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Canceled , please try again"),
                            ));
                          }
                        },
                      ),
                    ),
                  );
                }
              },
              child: Text(
                buttonName == "Pay"
                    ? "$buttonName \$$totalAmountForCheckout"
                    : buttonName,
                style: SafeGoogleFont("Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white),
              )),
        ),
        const SizedBox(
          height: 5,
        ),
        partialWalletAmoutUsed != null
            ? Row(
                children: [
                  const Icon(
                    Icons.info,
                    size: 18,
                    color: Colors.orange,
                  ),
                  Text(
                    "Used wallet amount: $partialWalletAmoutUsed",
                    style: SafeGoogleFont(
                      "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            : Container(),
        useOnlywalletAmount == true
            ? Wrap(children: [
                Text("Note: ",
                    style: SafeGoogleFont(
                      "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.black,
                    )),
                Text(
                  "Only wallet amount will be used",
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: const Color.fromARGB(255, 170, 167, 166)),
                ),
              ])
            : Container(),
      ],
    );
  }

  Column handleWallet(String walletAmount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                  if (value == true) {
                    useWallet(true);
                  } else {
                    useWallet(false);
                  }
                },
              ),
              Row(
                children: [
                  const Text(
                    'Bunny Wallet: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff868889),
                    ),
                  ),
                  Text(
                    walletAmount,
                    style: const TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget handlePaymentMethods(isCodEnabled, isStripeEnabled) {
    List<Widget> paymentMethodTiles = [];
    if (dashboardController.paymentDetails != null) {
      dashboardController.paymentDetails.forEach((key, value) {
        // if (key == 'cod' && value == 1) {
        //   paymentMethodTiles.add(
        //     Column(
        //       children: [
        //         Container(
        //           decoration: BoxDecoration(
        //             border: Border.all(color: const Color(0xffECECEC)),
        //             borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        //           ),
        //           child: RadioListTile<int>(
        //             title: Row(
        //               children: [
        //                 Image.asset(
        //                   ImageConstant.codLogo,
        //                 ),
        //                 const SizedBox(
        //                   width: 10,
        //                 ),
        //                 Text('Cash on Delivery (COD)',
        //                     style: SafeGoogleFont("Poppins",
        //                         color: const Color(0xff868889),
        //                         fontWeight: FontWeight.w600,
        //                         fontSize: 14)),
        //               ],
        //             ),
        //             value: 1,
        //             groupValue: selectedIndex,
        //             onChanged: (value) {
        //               setState(() {
        //                 buttonName = "COD";
        //                 selectedIndex = value!;
        //               });
        //             },
        //             activeColor: const Color(0xffAF6CDA),
        //             controlAffinity: ListTileControlAffinity.trailing,
        //             tileColor: selectedIndex == 1
        //                 ? const Color(0xaf6cda33).withOpacity(0.2)
        //                 : null,
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 10,
        //         )
        //       ],
        //     ),
        //   );
        // }
        if (key == 'stripe' && value == 1) {
          paymentMethodTiles.add(
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffECECEC)),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              child: RadioListTile<int>(
                title: Row(
                  children: [
                    Image.asset(
                      ImageConstant.stripeLogo,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text('Stripe',
                        style: SafeGoogleFont("Poppins",
                            color: const Color(0xff646FDE),
                            letterSpacing: 0.05,
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Payment',
                        style: SafeGoogleFont("Poppins",
                            color: const Color(0xff868889),
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                  ],
                ),
                value: 2,
                groupValue: selectedIndex,
                onChanged: (value) {
                  setState(() {
                    buttonName = "Pay";
                    selectedIndex = value!;
                  });
                },
                activeColor: const Color(0xffAF6CDA),
                controlAffinity: ListTileControlAffinity.trailing,
                tileColor: selectedIndex == 2
                    ? const Color.fromARGB(172, 119, 121, 119).withOpacity(0.2)
                    : null,
              ),
            ),
          );
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...paymentMethodTiles,
      ],
    );
  }

  Widget handleApplyCoupon() {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Apply Coupon",
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xff868889)),
            )),
        const SizedBox(
          height: 15,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: 'Enter your coupon code',
            labelStyle: SafeGoogleFont("Poppins",
                fontSize: 12, color: const Color(0xff868889)),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget paymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "About Order",
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: const Color(0xff868889)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Subtotal",
                style: SafeGoogleFont("Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xff868889)),
              ),
              Wrap(children: [
                Text(
                  currencyType,
                  style: SafeGoogleFont("Poppins",
                      fontSize: 16,
                      color: const Color.fromARGB(255, 109, 108, 108)),
                ),
                Text(
                  subTotalForCheckout ?? "",
                  style: SafeGoogleFont("Poppins",
                      fontSize: 16, color: const Color(0xff959595)),
                ),
              ]),
            ],
          ),
        ),
        paymentRow(
            "Shipment charges", "$currencyType$deliveryFeeForCheckout" ?? ""),
        const Divider(
          thickness: 5,
          indent: 10,
          endIndent: 10,
          color: Color(0xffF3F3F3),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "TOTAL",
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xff868889)),
            ),
            Wrap(children: [
              Text(
                currencyType,
                style: SafeGoogleFont("Poppins",
                    fontSize: 16,
                    color: const Color.fromARGB(255, 109, 108, 108)),
              ),
              Text(
                totalAmountForCheckout ?? "",
                style: SafeGoogleFont("Poppins",
                    fontSize: 16, color: const Color(0xff959595)),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Widget paymentRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color(0xff959595)),
          ),
          Text(
            value,
            style: SafeGoogleFont("Poppins",
                fontSize: 16, color: const Color(0xff959595)),
          ),
        ],
      ),
    );
  }

  appBarCheckOut(
      DashboardController dashboardController, BuildContext context) {
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
            child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(Icons.arrow_back_ios)),
          ),
          centerTitle: true,
          title: Text(
            'Payments Method',
            style: SafeGoogleFont("Poppins",
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xff868889)),
          ),
        ),
      ),
    );
  }
}

class StripePayment extends StatefulWidget {
  final String amount;
  final String currency;
  final Function(String) onPaymentResult;
  const StripePayment({
    super.key,
    required this.amount,
    required this.onPaymentResult,
    required this.currency,
  });

  @override
  StripePaymentState createState() => StripePaymentState();
}

class StripePaymentState extends State<StripePayment> {
  Map<String, dynamic>? paymentIntent;
  bool loadingIcon = false;
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<dynamic> customerDefaultShipAddress = [];
  var status = '';
  @override
  void initState() {
    super.initState();

    _getDeliveryAddress();

    _initializeStripe();
    String amount = widget.amount;
    print("Payable Amount");
    print(amount);
    String currency = widget.currency;
    createPaymentIntentBunny(amount, currency);
  }

  Future<void> _initializeStripe() async {
    // Test key
    Stripe.publishableKey =
        "pk_test_51OZPEFC7Xr5eJlSN4B4X8ODBHGOakXqTQl1rjmZhtN1NRqw1GRsogjvVVgSzAJsN7mydIdof9fNppGgIy5YvClMv00r6Pv9zgx";

    // Production key
    // Stripe.publishableKey =
    //     "pk_live_51OZPEFC7Xr5eJlSNdtOC0HesD2hOdBejqpUo5eTmdxGbpcSgFTs2MYKtxhqOkDqFSq2xxn4KDfJbK2H7VRegaO2h00UCJ4HON1";

    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';
  }

  Future callingStripeStatus() async {
    var jsonData = await dashboardController.stripePaymentStatus();
    if (jsonData['code'] == 200) {
      setState(() {
        status = jsonData['data']['status'];
      });
    }
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

  Future createPaymentIntentBunny(amount, currency) async {
    var jsonData =
        await dashboardController.createPaymentIntentBunny(amount, currency);
    if (jsonData != null && jsonData['code'] == 400 ||
        jsonData['code'] == 500) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(jsonData['message'].toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss dialog
                },
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    } else {
      if (customerDefaultShipAddress.isNotEmpty) {
        await callInitPaymentFromBunny(jsonData['data']['resp_data']);
      } else {
        return;
      }
    }
  }

  Future callInitPaymentFromBunny(List paymentIntentArray) async {
    var id = '';
    var clientSecret = '';
    var cusFname = '';
    var cusLname = '';
    var email = '';
    var shPhone1 = '';
    var shCity = '';
    var shCountry = '';
    var shLocation = '';
    var shLocation1 = '';
    var shZipcode = '';
    var shState = '';
    for (var paymentIntent in paymentIntentArray) {
      id = paymentIntent['id'];
      clientSecret = paymentIntent['client_secret'];
    }
    if (customerDefaultShipAddress.isNotEmpty) {
      for (var cusData in customerDefaultShipAddress) {
        cusFname = cusData['sh_cus_fname'].toString();
        cusLname = cusData['sh_cus_lname'].toString();
        email = cusData['sh_cus_email'].toString();
        shPhone1 = cusData['sh_phone1'].toString();
        shCity = cusData['sh_city'].toString();
        shCountry = cusData['sh_country'].toString();
        shLocation = cusData['sh_location'].toString();
        shLocation1 = cusData['sh_location1'].toString();
        shZipcode = cusData['sh_zipcode'].toString();
        shState = cusData['sh_state'].toString();
      }
    }

    //STEP 2:
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                customFlow: false,
                customerId: id.toString(),
                billingDetails: BillingDetails(
                    name: '$cusFname $cusLname}',
                    email: email.toString(),
                    phone: shPhone1.toString(),
                    address: Address(
                      city: shCity.toString(),
                      country: shCountry.toString(),
                      line1: shLocation.toString(),
                      line2: shLocation1.toString(),
                      postalCode: shZipcode.toString(),
                      state: shState.toString() ?? "NA",
                    )),
                paymentIntentClientSecret: clientSecret,
                style: ThemeMode.dark,
                googlePay: const PaymentSheetGooglePay(
                  merchantCountryCode: 'US',
                  testEnv: true,
                ),
                merchantDisplayName: 'Bunny'))
        .then((value) {});

    //STEP 3: Display Payment sheet
    displayPaymentSheetForBunny();
  }

  Future<void> displayPaymentSheetForBunny() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      setState(() {
        loadingIcon = true;
      });

      while (loadingIcon == true) {
        await callingStripeStatus();
        if (status == "succeeded") {
          await Future.delayed(const Duration(seconds: 4));
          setState(() {
            loadingIcon = false;
          });
          widget.onPaymentResult("succeeded");
          break;
        } else if (status == "canceled") {
          setState(() {
            loadingIcon = false;
          });
          widget.onPaymentResult("canceled");
          return;
        } else if (status == "preparing" || status == "requires_action") {
          print("preparing status");
          await Future.delayed(const Duration(seconds: 5));
          continue;
        } else {
          setState(() {
            loadingIcon = false;
          });
          print("Unexpected status: $status");
          return;
        }
      }
    } on Exception catch (e) {
      setState(() {
        loadingIcon = false;
      });
      print(e);
      if (e is StripeException) {
      } else {}
    }
  }

  showBackDialog(String value) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SizedBox(
            height: 150,
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Wait until your payment is done'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  loadingIcon = false;
                });
              },
              child: const Text('should remove'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Stripe',
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: const Color(0xff808089)),
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 127, 163, 224),
                  Colors.white,
                ],
              ),
            ),
            child: loadingIcon == true
                ? const Center(
                    child: SizedBox(child: CircularProgressIndicator()),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
