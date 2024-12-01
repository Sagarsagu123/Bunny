import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Wallet> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedPaymentMethod;
  List<dynamic> walletOrderInfo = [];

  String walletInfo = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getMyWallet();
  }

  Future getMyWallet() async {
    var jsonData = await landingPageController.getMyWallet();

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        walletOrderInfo = jsonData['data']['used_details'];
        isLoading = false;
        walletInfo = jsonData['data']['available_balance'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex0 = 0;

    final List<String> pageKeys = [
      '/dashboard',
      dashboardController.isStoreCreated == true
          ? '/storeDashboardIndividual?storeId=${dashboardController.customerStoreId}'
          : '/storeRegistrationPage',
      '/favourites',
      '/myCart',
      '/userProfile',
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar11(dashboardController),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              child: Image.asset(
                                'assets/images/walletimg.png',
                                width: 40,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Available Amount ',
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 15,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Last updated today ',
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 10,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$$walletInfo',
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 16,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 65, // 65% width
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(right: 8.0),
                  //           child: SizedBox(
                  //             height: 50, // Adjust height as needed
                  //             child: TextFormField(
                  //               controller:
                  //                   dashboardController.amountController,
                  //               decoration: InputDecoration(
                  //                 labelText: 'Recharge Wallet amount',
                  //                 labelStyle: SafeGoogleFont(
                  //                   "Poppins",
                  //                   color: const Color(0xFF868889),
                  //                   fontSize: 12,
                  //                   fontStyle: FontStyle.normal,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //                 border: const OutlineInputBorder(),
                  //               ),
                  //               keyboardType: TextInputType.number,
                  //               validator: (value) {
                  //                 if (value!.isEmpty) {
                  //                   return 'Please enter amount';
                  //                 }
                  //                 return null;
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         flex: 35, // 35% width
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(left: 8.0),
                  //           child: SizedBox(
                  //             height: 50, // Adjust height as needed
                  //             child: ElevatedButton(
                  //               style: ButtonStyle(
                  //                 backgroundColor: MaterialStateProperty.all(
                  //                     const Color(0xFFAF6CDA)),
                  //                 shape: MaterialStateProperty.all<
                  //                     RoundedRectangleBorder>(
                  //                   RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(8.0),
                  //                   ),
                  //                 ),
                  //               ),
                  //               onPressed: () {},
                  //               child: const Padding(
                  //                 padding: EdgeInsets.all(3.0),
                  //                 child: Text(
                  //                   'Recharge via Stripe ',
                  //                   style: TextStyle(
                  //                     color: Colors.white,
                  //                     fontSize: 10,
                  //                     fontStyle: FontStyle.normal,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Wallet History",
                      style: SafeGoogleFont(
                        "Poppins",
                        color: const Color(0xFF868889),
                        fontSize: 21,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  isLoading == false
                      ? walletOrderInfo.isNotEmpty
                          ? walletinfo111(walletOrderInfo)
                          : Container(
                              child: const Text("No Wallet details found"),
                            )
                      : const SpinKitCircle(
                          color: Color(0xffAF6CDA),
                          size: 50,
                        )
                ],
              ),
            ),
          ),
          bottomNavigationBar:
              bottomNavigationItems(currentIndex0, context, pageKeys),
        ),
      ),
    );
  }

  BottomNavigationBar bottomNavigationItems(
      int currentIndex0, BuildContext context, List<String> pageKeys) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xffAF6CDA),
      unselectedItemColor: const Color(0xff808089),
      currentIndex: currentIndex0,
      onTap: (index) {
        setState(() {
          currentIndex0 = index;
        });
        Get.toNamed(pageKeys[index]);
      },
      items: [
        BottomNavigationBarItem(
          label: 'Home',
          icon: InkWell(
              onTap: () {
                Get.toNamed('/dashboard');
              },
              child: const Icon(Icons.home_filled)),
        ),
        BottomNavigationBarItem(
          label: dashboardController.isStoreCreated == true
              ? 'My Store'
              : 'Create Store',
          icon: InkWell(
            onTap: () {
              dashboardController
                  .clearControllerFromDashBoardAndNavigateTostore(
                      context, dashboardController.isStoreCreated);
            },
            child: const Icon(Icons.storefront_outlined),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Favorites',
          icon: InkWell(
              onTap: () {
                Get.toNamed('/favourites');
              },
              child: const Icon(Icons.favorite_outline)),
        ),
        BottomNavigationBarItem(
          label: 'Cart',
          icon: InkWell(
              onTap: () {
                Get.toNamed('/myCart');
              },
              child: Stack(children: [
                const Icon(Icons.shopping_cart),
                (dashboardController.totalCartCount != '-1' &&
                        dashboardController.totalCartCount != '0')
                    ? Positioned(
                        right: 0,
                        top: 1,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            dashboardController.totalCartCount,
                            style: SafeGoogleFont(
                              "Poppins",
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ])),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: InkWell(
              onTap: () {
                Get.toNamed('/userProfile');
              },
              child: const Icon(Icons.person)
              // Image.asset(
              //   'assets/images/profile.png',
              //   height: 23,
              // ),
              ),
        ),
      ],
    );
  }

  appBar11(DashboardController dashboardController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 15),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 10, bottom: 10, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            65,
          ),
          leadingWidth: 30,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xffAF6CDA),
              size: 32,
            ),
          ),
          centerTitle: true,
          title: Align(
              alignment: Alignment.center,
              child: Text(
                "My Wallet",
                style: SafeGoogleFont("Poppins",
                    color: const Color(0xFF868889),
                    fontSize: 25,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis),
              )),
        ),
      ),
    );
  }

  Widget walletinfo111(List<dynamic> walletOrderInfo) {
    return Column(
      children: walletOrderInfo.map((item) {
        return mySteppe1(item);
      }).toList(),
    );
  }

  Widget mySteppe1(Map<String, dynamic> item) {
    var orderDate = item['order_date'];
    var orderAmount = item['order_amount'];
    var type = item['type'];
    var ordId = item['ord_id'];
    var status = (type == '1') ? 'Credited' : 'Debited';
    return Card(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Image.asset(
                      'assets/images/walletimg.png',
                      width: 40,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Transaction Amount: ",
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '\$$orderAmount',
                              style: SafeGoogleFont(
                                "Poppins",
                                color: type == "1"
                                    ? Colors.green
                                    : const Color(0xFFFF0000),
                                fontSize: 10,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Transaction ID: ',
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 12,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ordId,
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 10,
                                overflow: TextOverflow.ellipsis,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: type == "1" ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Transaction Date & Time",
                    style: SafeGoogleFont(
                      "Poppins",
                      color: const Color(0xFF868889),
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      orderDate,
                      style: SafeGoogleFont(
                        "Poppins",
                        color: const Color(0xFF868889),
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: type == "1" ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Transaction Amount",
                    style: SafeGoogleFont(
                      "Poppins",
                      color: const Color(0xFF868889),
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$$orderAmount'
                        .toString(), // Ensure orderAmount is converted to a string
                    style: SafeGoogleFont(
                      "Poppins",
                      color: const Color(0xFF868889),
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: type == "1" ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Transaction Status",
                    style: SafeGoogleFont(
                      "Poppins",
                      color: const Color(0xFF868889),
                      fontSize: 12,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        status,
                        style: SafeGoogleFont(
                          color: type == "1" ? Colors.green : Colors.red,
                          'Poppins',
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
    );
  }
}
