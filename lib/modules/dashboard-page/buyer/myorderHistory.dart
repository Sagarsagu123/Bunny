import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/eachOrderDetails.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OrderHistory> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> orderHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getOrderHistory();
  }

  Future getOrderHistory() async {
    var jsonData = await landingPageController.getOrderHistory();

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        orderHistory = jsonData['data']['orderArray'];
        isLoading = false;
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
                  isLoading == false
                      ? orderHistory.isNotEmpty
                          ? orderHistory1(orderHistory)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: SizedBox(
                                    child: Text("No order history found"),
                                  ),
                                ),
                              ],
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
              Get.offAllNamed('/dashboard');
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
                "Order History",
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

  Widget orderHistory1(List<dynamic> orderHistory) {
    return Column(
      children: orderHistory.map((item) {
        return mySteppe1(item);
      }).toList(),
    );
  }

  Widget mySteppe1(Map<String, dynamic> item) {
    var orderDate = item['orderDate'] ?? "";
    var orderAmount = item['orderAmount'];
    var orderId = item['orderId'];
    var orderStatus = item['order_status'];

    return GestureDetector(
      onTap: () => showOrderDetails(orderId),
      child: Card(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      orderStatus.toString(),
                      style: SafeGoogleFont(
                        "Poppins",
                        color: getStatusColor(orderStatus.toString()),
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ',
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          orderId.toString(),
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
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
                          'Order Amount: ',
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          orderAmount.toString(),
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
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
                          'orderDate: ',
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          orderDate,
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  getStatusColor(String status) {
    Color statusColor;

    switch (status) {
      case "Order Placed":
        statusColor = Colors.green;
        break;
      case "Order is Cancelled":
        statusColor = Colors.red;
        break;
      case "Order is preparing":
        statusColor = Colors.orange;
        break;
      case "Order Accepted":
        statusColor = Colors.blueAccent;
        break;
      case "Delivered":
        statusColor = Colors.greenAccent;
        break;
      case "Order is dispatched":
        statusColor = Colors.pinkAccent;
        break;
      default:
        statusColor = const Color(0xff868889);
    }

    return statusColor;
  }

  void showOrderDetails(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(orderId: orderId),
      ),
    );
  }
}
