import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:get/get.dart';

class StoreDashboardAll extends StatefulWidget {
  const StoreDashboardAll({super.key});

  @override
  State<StoreDashboardAll> createState() => _StoreDashboardState();
}

class _StoreDashboardState extends State<StoreDashboardAll> {
  List<dynamic> _storeList = [];
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getStoreCategoryList();
  }

  Future _getStoreCategoryList() async {
    dashboardController.selectedcategoryTypes = "All";
    var jsonData = await dashboardController.getCategoriesListForStore();
    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        dashboardController.categogyTypes =
            jsonData['data']['category_Details'];
      });
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
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            key: _scaffoldKey,
            body: RefreshIndicator(
              color: Colors.white,
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await dashboardController.fetchData();
                return Future<void>.delayed(const Duration(seconds: 1));
              },
              child: Builder(builder: (context) {
                _storeList = dashboardController.dataList;
                if (dashboardController.dataList.isEmpty) {
                  return const Center(child: Text("No store available"));
                } else {
                  return Stack(fit: StackFit.expand, children: [
                    SingleChildScrollView(
                      child: dashboardController.dataList.isNotEmpty
                          ? Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 45),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 200, child: buildImage()),
                                    Center(
                                        child: Text(
                                      "Start Selling With",
                                      style: SafeGoogleFont("Poppins",
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xff868889)),
                                    )),
                                    Center(
                                      child: Image.asset(
                                        height: 70,
                                        width: 180,
                                        ImageConstant
                                            .imgBunnylogorgbfc, // Replace with your background image URL
                                        fit: BoxFit.fitWidth,
                                        alignment: Alignment
                                            .centerRight, // Align the image to the right (horizontal reverse)
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 233,
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color.fromARGB(
                                                        255, 237, 236, 238)),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFFAF6CDA)),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15.0), // Adjust the radius as needed
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.toNamed(
                                              '/storeRegistrationPage',
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            size: 28,
                                          ),
                                          label: Text(
                                            "Create Store",
                                            style: SafeGoogleFont(
                                              color: Colors.white,
                                              'Poppins',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                        child: Text(
                                      "Are you a...?",
                                      style: SafeGoogleFont("Poppins",
                                          fontSize: 23,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff868889)),
                                    )),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Center(
                                      child: SizedBox(
                                          width: Get.width / 1.7,
                                          child: buildDropdown(
                                              dashboardController)),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    _storeList.isNotEmpty
                                        ? StaticGrid(
                                            columnMainAxisAlignment:
                                                MainAxisAlignment.center,
                                            rowMainAxisAlignment:
                                                MainAxisAlignment.start,
                                            columnCrossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            rowCrossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            columnCount: 1,
                                            children: List.generate(
                                                _storeList.length, (index) {
                                              Map<String, dynamic> store =
                                                  _storeList[index];

                                              String name =
                                                  store['st_store_name'];

                                              String storeId =
                                                  store['id'].toString();
                                              final random = Random();
                                              final r = 200 +
                                                  random.nextInt(
                                                      56); // Red channel (200-255)
                                              final g = 200 +
                                                  random.nextInt(
                                                      56); // Green channel (200-255)
                                              final b = 200 +
                                                  random.nextInt(
                                                      56); // Blue channel (200-255)
                                              // final color =
                                              //     Color.fromRGBO(r, g, b, 1);
                                              if (dashboardController
                                                          .selectedcategoryTypesID !=
                                                      null &&
                                                  (dashboardController
                                                              .selectedcategoryTypesID !=
                                                          0 &&
                                                      store['st_category'] !=
                                                          dashboardController
                                                              .selectedcategoryTypesID)) {
                                                return const SizedBox.shrink();
                                              }

                                              return GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    '/storeDashboardIndividual',
                                                    parameters: {
                                                      'storeId': storeId
                                                    },
                                                  );
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        border: Border.all(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              217, 217, 218),
                                                          width: 1.0,
                                                        ),
                                                        // color: color,
                                                        color: const Color
                                                                .fromARGB(173,
                                                                195, 197, 193)
                                                            .withOpacity(.15)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 8,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5),
                                                              child: Text(
                                                                softWrap: false,
                                                                maxLines: 2,
                                                                name.trim(),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                showDeleteConfirmationDialog(
                                                                    context,
                                                                    storeId);
                                                              },
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .do_not_disturb_alt_outlined,
                                                                  size: 25,
                                                                  color: Color(
                                                                      0xff000000),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                          )
                                        : const Text("No store"),
                                  ],
                                ),
                              ),
                            )
                          : const Center(
                              child: Text('No Store in the dashboard'),
                            ),
                    ),
                    // Positioned(
                    //   bottom: 0,
                    //   left: 0,
                    //   child: Image.asset(
                    //     'assets/images/storeBottomLeft.png',
                    //     fit: BoxFit.cover,
                    //     color: const Color.fromRGBO(255, 255, 255, 0.6),
                    //     colorBlendMode: BlendMode.modulate,
                    //   ),
                    // ),
                    // Positioned(
                    //   bottom: 0,
                    //   right: 0,
                    //   child: Image.asset(
                    //     'assets/images/storeBottomRight.png',
                    //     fit: BoxFit.cover,
                    //     color: const Color.fromRGBO(255, 255, 255, 0.6),
                    //     colorBlendMode: BlendMode.modulate,
                    //   ),
                    // ),
                    backArrow(context),
                  ]);
                }
              }),
            ),
            bottomNavigationBar: bottomNavigationItems(
                currentIndex0, context, pageKeys, dashboardController),
          ),
        ),
      );
    });
  }

  void showDeleteConfirmationDialog(BuildContext context, String storeId) {
    ButtonStyle elevatedButtonStyle = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 181, 176, 184)));
    ButtonStyle elevatedButtonStyle1 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xffAF6CDA)));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(0),
          title: Center(
            child: Text(
              "Disable",
              style: SafeGoogleFont("Poppins",
                  fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
          content: Text(
            "Do you want to Disable the store?",
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: const Color(0xff868889)),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: SafeGoogleFont("Poppins",
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 76, 76, 77)),
              ),
            ),
            ElevatedButton(
              style: elevatedButtonStyle1,
              onPressed: () async {
                bool val =
                    await dashboardController.disableStore(context, storeId);
                if (val == true) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Yes",
                style: SafeGoogleFont("Poppins",
                    fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildImage() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FractionallySizedBox(
          widthFactor: 1.5,
          child: Image.asset(
            'assets/images/sss.png',
            // fit: BoxFit.fill,
            alignment: Alignment.centerRight,
          ),
        ),
      ],
    );
  }

  Positioned backArrow(BuildContext context) {
    return Positioned(
      top: 30,
      left: 25,
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
            color: Color.fromARGB(255, 192, 152, 187),
          ),
          child: const Center(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 22,
            ),
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
            child: const Icon(
              Icons.storefront_outlined,
            ),
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

  Widget buildDropdown(DashboardController dashboardController) {
    List<DropdownMenuItem<String>> dropdownItems = [];

    // Add the "All" option
    dropdownItems.add(
      const DropdownMenuItem(
        value: 'All',
        child: Text('All'),
      ),
    );

    for (var category in dashboardController.categogyTypes) {
      dropdownItems.add(
        DropdownMenuItem(
          value: category['category_name'].toString(),
          child: SizedBox(
            width: 150,
            child: Text(category['category_name']),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: dashboardController.categogyTypes.isNotEmpty
          ? DropdownButtonFormField<String>(
              isExpanded: true,
              value: dashboardController.selectedcategoryTypes,
              items: dropdownItems,
              onChanged: (String? newValue) {
                var selectedCategoryType;
                if (newValue != "All") {
                  selectedCategoryType =
                      dashboardController.categogyTypes.firstWhere(
                    (category) =>
                        category['category_name'].toString() == newValue,
                  );
                }

                setState(() {
                  dashboardController.selectedcategoryTypes =
                      newValue.toString();
                  dashboardController.selectedcategoryTypesID =
                      newValue == 'All'
                          ? 0
                          : selectedCategoryType['category_id'];
                });
              },
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0xffAF6CDA)))
          : const Text("No dropdown found"),
    );
  }
}
