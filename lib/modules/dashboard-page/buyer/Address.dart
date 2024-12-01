import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/location/customGoogleMap.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Address> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedPaymentMethod;
  List<dynamic> customerShipAddress = [];

  int defaultIndex = 0;
  String selectedShId = "";
  String selectedDate = '';
  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    getAddress();
  }

  Future getAddress() async {
    var jsonData = await landingPageController.getAddress();

    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData != null && jsonData['data'] != null) {
        setState(() {
          isLoading = false;
          customerShipAddress = jsonData['data']['shipping_address'];
        });
      } else {
        setState(() {
          isLoading = false;
          customerShipAddress = [];
        });
      }
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
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar11(dashboardController),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Delivery Address List",
                      style: SafeGoogleFont(
                        color: const Color(0xFF868889),
                        'Poppins',
                        fontSize: 22,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  isLoading == false
                      ? listOfDeliveryAddress22(customerShipAddress)
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

  appBar11(DashboardController dashboardController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 5),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 10, bottom: 10, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            50,
          ),
          leadingWidth: 32,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xffAF6CDA),
              size: 32,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Align(
              alignment: Alignment.center,
              child: Text(
                "My Address",
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
            child: Image.asset(
              'assets/images/profile.png',
              height: 23,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getIconForLabel(String? label, {double size = 24.0}) {
    switch (label) {
      case 'HOME':
        return Image.asset(
          'assets/images/home_address.png',
          height: 23,
        );
      case 'WORK':
        return Image.asset(
          'assets/images/work.png',
          height: 23,
        );
      default:
        return Image.asset(
          'assets/images/others.png',
          height: 23,
        );
    }
  }

  Widget listOfDeliveryAddress22(List<dynamic> customerShipAddress) {
    if (customerShipAddress.isNotEmpty) {
      return Column(
        children: [
          // List of existing addresses
          ...customerShipAddress.asMap().entries.map((entry) {
            final index = entry.key;
            final address = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                child: Column(
                  children: [
                    // First Row: Shipping label and Checkbox
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getIconForLabel(address['sh_label'], size: 36.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: Get.width / 1.7,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the radius as needed
                                    ),
                                    child: address['sh_default_addr']
                                        ? Padding(
                                            padding: const EdgeInsets.all(
                                                4.0), // Adjust padding as needed
                                            child: Text(
                                              'Default',
                                              style: SafeGoogleFont(
                                                "Poppins",
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        : const SizedBox(), // Render SizedBox if address['sh_default_addr'] is false
                                  ),
                                  Text(
                                    '${address['sh_location1']},',
                                    style: SafeGoogleFont(
                                      "Poppins",
                                      color: const Color(0xFF868889),
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${address['sh_location']}',
                                    style: SafeGoogleFont(
                                      "Poppins",
                                      color: const Color(0xFF868889),
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${address['sh_zipcode']},',
                                    style: SafeGoogleFont(
                                      "Poppins",
                                      color: const Color(0xFF868889),
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xff868889),
                              size: 20,
                            ),
                            onPressed: () {
                              Map<String, dynamic> customerAddress =
                                  customerShipAddress[index];
                              Get.to(() => SizedBox(
                                    child: CustomGoogleMap(
                                      isEdit: true,
                                      setDefault:
                                          address['sh_default_addr'] == true
                                              ? true
                                              : false,
                                      routeTo: "",
                                      routeFrom: '',
                                      customerAddress: customerAddress,
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                // width: Get.width / 1.7,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFAF6CDA)),
                  ),
                  onPressed: () {
                    Get.to(() => const SizedBox(
                          child: CustomGoogleMap(
                            isEdit: true,
                            setDefault: false,
                            routeTo: "",
                            routeFrom: '',
                            customerAddress: {},
                          ),
                        ));
                  },
                  child: Text(
                    "Add New Address",
                    style: SafeGoogleFont("Poppins", color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 500, child: Text("No Address available")),
      ],
    );
  }
}
