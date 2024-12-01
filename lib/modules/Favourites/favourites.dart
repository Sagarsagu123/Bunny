import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/cart/my-cart.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<dynamic> customerFavProducts = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    fetchFavouriteProducts();
  }

  Future fetchFavouriteProducts() async {
    var jsonData = await dashboardController.fetchFavouriteProducts();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      setState(() {
        customerFavProducts = [];
        isLoading = false;
      });
    } else {
      setState(() {
        customerFavProducts = jsonData['data']['product_wish_list'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex0 = 2;

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
            appBar: appBar(dashboardController, "Favorites", context, true),
            body: isLoading == false
                ? SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customerFavProducts.isNotEmpty
                            ? Expanded(
                                child: SizedBox(
                                  child: ListView.builder(
                                    itemCount: customerFavProducts.length,
                                    itemBuilder: (context, index) {
                                      final item = customerFavProducts[index];
                                      var productId = item['product_id'];
                                      var storeId = item['restaurant_id'];
                                      var mainCategoryId = item['pro_mc_id'];
                                      var categoryName = item['pro_mc_name'];
                                      var subCategoryId = item['pro_sc_id'];
                                      var productName = item['product_title'];
                                      var productImage = item['product_image'];
                                      var chPrice = item['ch_price'];
                                      var choiceName = item['choice_name'];

                                      return Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 231, 229, 231),
                                                width: 1.5),
                                            color: const Color(0xffffffff),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                '/productDetail',
                                                parameters: {
                                                  'main_category_id':
                                                      mainCategoryId.toString(),
                                                  'categoryName':
                                                      categoryName.toString(),
                                                  'sub_category_id':
                                                      subCategoryId.toString(),
                                                  'productId':
                                                      productId.toString(),
                                                  'storeId': storeId.toString(),
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 80,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.fitHeight,
                                                      imageUrl: productImage,
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      productName!,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xff868889)),
                                                    ),
                                                    Text(
                                                      "Quantity: $choiceName",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xff585858)),
                                                    ),
                                                    Text(
                                                      "Price: \$$chPrice",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color: Color(
                                                              0xff585858)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                "You haven't marked any favorites yet.",
                                style: SafeGoogleFont("Poppins", fontSize: 14),
                              )),
                      ],
                    ),
                  )
                : const Center(
                    child: SpinKitCircle(
                      color: Color(0xffAF6CDA),
                      size: 50,
                    ),
                  ),
            bottomNavigationBar:
                bottomNavigationItems(currentIndex0, context, pageKeys),
          ),
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
            child: const Icon(Icons.home_filled),
          ),
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
            child: const Icon(Icons.favorite_outline),
          ),
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
            ]),
          ),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: InkWell(
            onTap: () {
              Get.toNamed('/userProfile');
            },
            child: const Icon(Icons.person),
          ),
        ),
      ],
    );
  }
}
