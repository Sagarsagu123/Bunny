import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class IndividualStorePage extends StatefulWidget {
  const IndividualStorePage({super.key});

  @override
  State<IndividualStorePage> createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<IndividualStorePage> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _storeId = '';
  String _name = '';
  bool isLoading = true;
  String errorMsg = '';
  bool isError = false;
  bool storeHasNewMessage = false;
  List<dynamic> restaurantInfo = [];
  List<Map<String, dynamic>> orders = [
    {
      'id': "1",
      'orderType': 'New Order',
      'type': 'new_order',
      'count': 0,
      'icon': Icons.add_shopping_cart,
      'imagePath': 'assets/images/newOrder1.png',
      'backgroundColor': const Color(0xffEEF7FE),
      'fontColor': const Color(0xff415EB6),
    },
    {
      'id': "2",
      'orderType': 'Processing Order',
      'type': 'process_order',
      'count': 0,
      'imagePath': 'assets/images/acceptedOrder.png',
      'icon': Icons.check_circle,
      'backgroundColor': const Color(0xffFFFBEC),
      'fontColor': const Color(0xffFFB110),
    },
    {
      'id': "3",
      'orderType': 'Completed Order',
      'type': 'delivered_order',
      'count': 0,
      'imagePath': 'assets/images/deliveryOrder.png',
      'icon': Icons.done,
      'backgroundColor': const Color(0xffFEEEEE),
      'fontColor': const Color(0xffAC4040),
    },
    {
      'id': "4",
      'orderType': 'Returned Order',
      'type': 'return_orders',
      'count': 0,
      'imagePath': 'assets/images/returnedOrder.png',
      'icon': Icons.cancel,
      'backgroundColor': const Color(0xffF0FFFF),
      'fontColor': const Color(0xff23B0B0),
    },
    {
      'id': "5",
      'orderType': 'Total Order',
      'type': 'total_orders',
      'count': 0,
      'imagePath': 'assets/images/deliveryOrder.png',
      'icon': Icons.cancel,
      'backgroundColor': const Color.fromARGB(255, 220, 231, 231),
      'fontColor': const Color(0xff355806),
    },
  ];

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('storeId')) {
      if (parameters['storeId'] != null) {
        getstoreproducts(parameters['storeId']);
        getMerchantAuthCode(parameters['storeId']);
      }
      print("store dashboard");
      print(parameters['storeId']);
    }
  }

  Future getstoreproducts(String storeId) async {
    var jsonData = await dashboardController.getstoreproducts(storeId);
    if (jsonData != null && jsonData['code'] == 400) {
      setState(() {
        errorMsg = jsonData['message'];
        isError = true;
        restaurantInfo = [];
      });
    } else if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        restaurantInfo = jsonData['data']['restaurant_info'];
        _name = jsonData['data']['restaurant_info'][0]['restaurant_name']
            .toString();
        _storeId =
            jsonData['data']['restaurant_info'][0]['restaurant_id'].toString();
      });
    }
  }

  Future getMerchantAuthCode(String storeId) async {
    bool val = await dashboardController.getMerchantAuthCode(storeId);
    if (val == true) {
      var jsonData = await dashboardController.merchantAuthCode();

      if (jsonData != null && jsonData['data'] != null) {
        setState(() {
          for (var order in orders) {
            order['count'] = jsonData['data'][order['type']] ??
                0; // Set count to 0 if data is not available
          }
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex0 = 1;

    final List<String> pageKeys = [
      '/dashboard',
      dashboardController.isStoreCreated == true
          ? '/storeDashboardIndividual?storeId=${dashboardController.customerStoreId}'
          : '/storeRegistrationPage',
      '/favourites',
      '/myCart',
      '/userProfile',
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          Get.toNamed('/dashboard');
          return;
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Scaffold(
            key: _scaffoldKey,
            appBar: isError == true ? appBar11() : null,
            body: RefreshIndicator(
              color: Colors.white,
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await getMerchantAuthCode(_storeId);
                return Future<void>.delayed(const Duration(seconds: 1));
              },
              child: individualRender(context),
            ),
            bottomNavigationBar: bottomNavigationItems(
                currentIndex0, context, pageKeys, dashboardController),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView individualRender(BuildContext context) {
    return SingleChildScrollView(
      child: isError == true
          ? SizedBox(
              height: Get.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      errorMsg,
                      style:
                          const TextStyle(fontFamily: "Poppins", fontSize: 20),
                    ),
                  ],
                ),
              ),
            )
          : isLoading == false
              ? Stack(children: [
                  SizedBox(
                    child: Column(
                      children: [
                        SizedBox(
                            width: Get.width,
                            height: 200,
                            child: buildStoreBannerImage(restaurantInfo[0]
                                    ['restaurant_banner'][0]
                                .toString())),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            5,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 9,
                                    child: Container(
                                      height: 65,
                                      padding: const EdgeInsets.all(8),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          _name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: SafeGoogleFont("Poppins",
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff868889),
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          '/storeRegistrationPage',
                                          parameters: {
                                            'storeId': _storeId,
                                            'type': 'edit'
                                          },
                                        );
                                      },
                                      child: const SizedBox(
                                        height: 60,
                                        child: Icon(
                                          Icons.edit_outlined,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          '/sellerChat',
                                          parameters: {'storeId': _storeId},
                                        );

                                        // showDialog(
                                        //   context: context,
                                        //   barrierDismissible: true,
                                        //   builder: (BuildContext context) {
                                        //     return const Dialog(
                                        //       backgroundColor: Colors.white,
                                        //       child: SizedBox(
                                        //         height: 200,
                                        //         child: Center(
                                        //           child: Column(
                                        //             mainAxisAlignment:
                                        //                 MainAxisAlignment
                                        //                     .center,
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .center,
                                        //             children: [
                                        //               Text(
                                        //                 "This is in Beta version",
                                        //                 style: TextStyle(
                                        //                     fontSize: 18,
                                        //                     color: Colors.red,
                                        //                     fontWeight:
                                        //                         FontWeight
                                        //                             .w500),
                                        //               ),
                                        //               SizedBox(
                                        //                 height: 5,
                                        //               ),
                                        //               Text(
                                        //                   "You may experience some error",
                                        //                   style: TextStyle(
                                        //                       fontSize: 16,
                                        //                       color: Colors.red,
                                        //                       fontWeight:
                                        //                           FontWeight
                                        //                               .w400)),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        // );
                                      },
                                      child: dashboardController
                                              .buyerHasNewMessage
                                          ? SizedBox(
                                              // height: 60,
                                              child: Center(
                                                child: Stack(
                                                  children: [
                                                    const Icon(
                                                      Icons.chat_outlined,
                                                      size: 32,
                                                    ),
                                                    Positioned(
                                                      top: 0,
                                                      right: 0,
                                                      child: Container(
                                                        width: 14,
                                                        height: 14,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 60,
                                              child: Icon(
                                                Icons.chat_outlined,
                                                size: 29,
                                              ),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  // // Expanded(
                                  //   flex: 1,
                                  //   child: InkWell(
                                  //     onTap: () {},
                                  //     child: const SizedBox(
                                  //       height: 60,
                                  //       child: Icon(
                                  //         Icons.settings_outlined,
                                  //         size: 29,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: Get.width * 0.4,
                                    child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0), // Adjust the radius as needed
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFFAF6CDA)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(
                                          '/viewProducts',
                                          parameters: {'storeId': _storeId},
                                        );
                                      },
                                      icon: Container(),
                                      label: const Text('View Product'),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.07,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    width: Get.width * 0.4,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15.0), // Adjust the radius as needed
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFFAF6CDA)),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                      ),
                                      onPressed: () {
                                        Get.toNamed(
                                          '/addProduct',
                                          parameters: {
                                            'storeId': _storeId,
                                          },
                                        );
                                      },
                                      child: const Text('Add Product'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              StaticGrid(
                                columnMainAxisAlignment:
                                    MainAxisAlignment.center,
                                columnCrossAxisAlignment:
                                    CrossAxisAlignment.center,
                                rowMainAxisAlignment: MainAxisAlignment.start,
                                rowCrossAxisAlignment:
                                    CrossAxisAlignment.center,
                                gap: 10,
                                columnCount: 2,
                                children: orders.map((item) {
                                  var orderType = item['orderType'];
                                  var count = item['count'];
                                  // var icon = item['icon'];
                                  var backgroundColor = item['backgroundColor'];
                                  var fontColor = item['fontColor'];
                                  var path = item['imagePath'];
                                  var type = item['type'];
                                  return GestureDetector(
                                    onTap: () {
                                      if (type == "new_order" ||
                                          type == "process_order") {
                                        Get.toNamed('/orderManagement',
                                            arguments: {'type': type});
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: backgroundColor,
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                                  255, 209, 207, 209)
                                              .withOpacity(.3),
                                          width: 1,
                                        ),
                                      ),
                                      height: 130,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // Icon(icon, size: 45, color: fontColor),
                                                Image.asset(
                                                  path,
                                                  height: 45,
                                                ),
                                                Text(
                                                  '$count',
                                                  style: SafeGoogleFont(
                                                    "Poppins",
                                                    color: fontColor,
                                                    fontSize: 16,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              orderType,
                                              style: SafeGoogleFont(
                                                "Poppins",
                                                letterSpacing: 0.4,
                                                color: fontColor,
                                                fontSize: 16,
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  backArrow(context),
                  userImage(context, dashboardController.currentUserImage),
                ])
              : SizedBox(
                  height: Get.height,
                  child: const Center(
                    child: SpinKitCircle(
                      color: Color(0xffAF6CDA),
                      // size: 50,
                    ),
                  ),
                ),
    );
  }

  BottomNavigationBar bottomNavigationItems(
      int currentIndex0,
      BuildContext context,
      List<String> pageKeys,
      DashboardController dashboardController) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
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
            child: Stack(children: [
              const Icon(Icons.storefront_outlined),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dashboardController.buyerHasNewMessage
                        ? Colors.red
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ]),
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
              child: const Icon(Icons.person)),
        ),
      ],
    );
  }

  appBar11() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 25),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 12, bottom: 8, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            55,
          ),
          leadingWidth: 32,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Align(
            alignment: Alignment.center,
            child: AppbarImage(
                height: getVerticalSize(
                  65,
                ),
                width: getHorizontalSize(
                  160,
                ),
                imagePath: ImageConstant.imgBunnylogorgbfc),
          ),
        ),
      ),
    );
  }

  Widget buildStoreBannerImage(imageUrl) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            image: imageUrl!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrl!), fit: BoxFit.fill)
                : null,
          ),
          child: imageUrl!.isEmpty
              ? const Icon(Icons.account_circle,
                  size: 100, color: Colors.grey) // Placeholder icon
              : null,
        ),
      ],
    );
  }

  Positioned userImage(BuildContext context, imageUrl) {
    return Positioned(
      top: 160,
      left: 24,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 280,
                        height: 280,
                      ),
                    ),
                  ),
                );
              },
            );
          },
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          customBorder: const CircleBorder(),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffF1F1F5),
            ),
            child: Center(
              child: ClipOval(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 161, 151, 218),
                    image: imageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!), fit: BoxFit.fill)
                        : null,
                  ),
                  child: imageUrl!.isEmpty
                      ? const Icon(Icons.account_circle,
                          size: 100, color: Colors.grey) // Placeholder icon
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned backArrow(BuildContext context) {
    return Positioned(
      top: 35,
      left: 20,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF1F1F5),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
