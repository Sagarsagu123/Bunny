import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/dashboard-page/dashbord_search.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/custom_text_style.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LoginController landingPageController = Get.find<LoginController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  List<dynamic> dashboardCategories1 = [];
  List<dynamic> dashboardCategories2 = [];
  List mainCategories = [];
  bool? displayStoreData;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getAllCategoriesFromBackEnd();
    // listSharedPreferencesKeys();
    _getAuthCode();
  }

  Future _getAuthCode() async {
    var totalCartCount = await Auth.gettotalCartCount();
    var totalCartAmount = await Auth.gettotalCartAmount();
    if (totalCartCount != null) {
      setState(() {
        dashboardController.totalCartCount = totalCartCount.toString();
        dashboardController.totalCartAmount = totalCartAmount;
      });
    }
    return null;
  }

  void listSharedPreferencesKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeysAndValues = prefs.getKeys().map((key) {
      return MapEntry(key, prefs.get(key));
    });

    for (var entry in allKeysAndValues) {
      print('${entry.key}: ${entry.value}');
    }
  }

  Future getAllCategoriesFromBackEnd() async {
    List<Map<String, dynamic>> satisfiedChoices = [];
    List<Map<String, dynamic>> unsatisfiedChoices = [];
    var jsonData = await landingPageController.getMainCategoriesList();
    if (jsonData != null && jsonData['data'] != []) {
      setState(() {
        mainCategories = jsonData['data']['category_Details'];
        dashboardController.buyerHasNewMessage =
            jsonData['data']["buyer_has_new_message"];
        dashboardController.sellerHasNewMessage =
            jsonData['data']["seller_has_new_message"];
      });

      for (var eachItem in mainCategories) {
        if (eachItem["isSelected"] == true) {
          satisfiedChoices.add(eachItem);
        } else {
          unsatisfiedChoices.add(eachItem);
        }
      }

      displayStoreData =
          jsonData['data']['storeAvailable'] == 'false' ? false : true;
      bool valueFromBackEnd =
          jsonData['data']['hasStore'] == 'false' ? false : true;
      String customerStoreId = jsonData['data']['customerStoreId'].toString();
      List<dynamic> cusData = jsonData['data']['cusData'];
      String userAvatar = jsonData['data']['user_avatar'];
      String currentUserName;
      String currentUserEmail;

      if (displayStoreData == true) {
        Future.delayed(const Duration(seconds: 3));
        for (var cusData1 in cusData) {
          currentUserName = cusData1['cus_fname'];

          currentUserEmail = cusData1['cus_email'];

          setState(() {
            dashboardController.isStoreCreated = valueFromBackEnd;
            dashboardController.currentUserName = currentUserName;
            dashboardController.currentUserImage = userAvatar;
            dashboardController.currentUserEmail = currentUserEmail;
            dashboardCategories1 = satisfiedChoices;
            dashboardCategories2 = unsatisfiedChoices;
            isLoading = false;
            dashboardController.customerStoreId = customerStoreId.toString();
          });
        }
      }
    } else {
      Future.delayed(const Duration(seconds: 2));
      setState(() {
        isLoading = false;
      });
    }
  }

  onBackButton(didPop) {
    if (didPop) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
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
        child: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            onBackButton(didPop);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: appBarDashboard(landingPageController, dashboardController),
            drawer: drawerDashboard(context, dashboardController),
            body: RefreshIndicator(
                color: Colors.white,
                edgeOffset: 10.0,
                displacement: 40.0,
                backgroundColor: const Color(0xffAF6CDA),
                strokeWidth: 3.0,
                onRefresh: () async {
                  await getAllCategoriesFromBackEnd();
                  return Future<void>.delayed(const Duration(seconds: 1));
                },
                child: _getPageWidget(pageKeys[currentIndex0])),
            bottomNavigationBar:
                bottomNavigationItems(currentIndex0, context, pageKeys),
          ),
        ),
      ),
    );
  }

  Future<bool> showBackDialog() async {
    return await showDialog(
      context: context,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          title: const Text('Confirm Exit'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Get.offAllNamed('/loginOptions');
                Navigator.of(context)
                    .pop(true); // Dismiss dialog with result true
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
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
            child: Stack(children: [
              const Icon(Icons.storefront_outlined),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dashboardController.sellerHasNewMessage
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

  notSelectedProducts(
      List<dynamic> dashboardCategories2, BoxDecoration decorationStyle) {
    return dashboardCategories2.isNotEmpty
        ? Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Available categories can be selected in Category Board",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: StaticGrid(
                  gap: 10,
                  columnCount: 3,
                  padding: const EdgeInsets.all(10),
                  children: dashboardCategories2.map((item) {
                    var name = item['category_name'];
                    var imageName = item['category_image'];
                    var mainId = item['category_id'].toString();
                    return Builder(
                      builder: (context) {
                        return SizedBox(
                          width: 100,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                '/displayMoreProducts',
                                parameters: {
                                  'main_category_id': mainId,
                                  'categoryName': name,
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: const Color(0xffD8D8D8),
                                  width: 1.0,
                                ),
                                color: const Color(0xffffffff),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 85,
                                    child: CachedNetworkImage(
                                      imageUrl: imageName!,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: SizedBox(
                                      height: 40,
                                      child: Text(
                                        name,
                                        style: SafeGoogleFont("Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff868889),
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          )
        : Center(child: Container());
  }

  appBarDashboard(LoginController landingPageController,
      DashboardController dashboardController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(140),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Image.asset(
                ImageConstant.imgBunnylogorgbfc,
                width: 160,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Color(0xffAF6CDA),
                      size: 35,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 15, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF3F3F3),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: TextFormField(
                          readOnly: true,
                          onTap: (() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SearchDashboard()),
                            );
                            FocusScope.of(context)
                                .unfocus(); // Unfocus the text field
                          }),
                          style: const TextStyle(fontSize: 12.0),
                          decoration: InputDecoration(
                            hintStyle: CustomTextStyles.titleSmallDMSansGray500,
                            prefixIcon: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Icon(
                                    Icons.search,
                                    size: 20,
                                    color: Color(0xffAF6CDA),
                                  ),
                                ),
                                Center(child: Text('Search...')),
                              ],
                            ),
                            suffixIcon: const Icon(
                              Icons.filter_list_outlined,
                              size: 22,
                            ),
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0),
                  //   child: IconButton(
                  //     icon: const Icon(
                  //       Icons.pin_drop_outlined,
                  //       color: Color(0xffAF6CDA),
                  //       size: 32,
                  //     ),
                  //     onPressed: () {
                  //       // Get.toNamed('/orderManagement');
                  //       // Get.toNamed('/customerProductInterests',
                  //       //     arguments: {'fromDashboard': 'false'});
                  //       // Get.to(() => const SizedBox(
                  //       //       child: CustomGoogleMap(
                  //       //         isEdit: false,
                  //       //       ),
                  //       //     ));
                  //     },
                  //   ),
                  // ),
                  GestureDetector(
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
                                  dashboardController.currentUserImage,
                                  width: 280,
                                  height: 280,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 198, 197, 202),
                          image:
                              (dashboardController.currentUserImage.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          dashboardController.currentUserImage),
                                      fit: BoxFit.fill)
                                  : null),
                        ),
                        child: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  productCategoriesWithSubCategoriesNew(List selectedCategories) {
    return eachArrayNew(selectedCategories);
  }

  Widget _buildGrabOfferSection() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            20,
          ),
          child: SizedBox(
            height: 150,
            width: Get.width,
            child: Image.asset(
              ImageConstant.offerImage,
              alignment: Alignment.center,
            ),
          ),
        ));
  }

  selectedProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          child: Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              "Categories",
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF868889)),
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dashboardCategories1.length,
            itemBuilder: (context, index) {
              final name = dashboardCategories1[index]['category_name'];
              final imageItem = dashboardCategories1[index]['category_image'];
              final mainId =
                  dashboardCategories1[index]['category_id'].toString();
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/displayMoreProducts',
                      parameters: {
                        'main_category_id': mainId,
                        'categoryName': name,
                      },
                    );
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(imageItem),
                        foregroundColor: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color.fromARGB(255, 217, 217, 218),
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 133, 134, 134)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  eachArrayNew(List selectedCategories) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Column(
        children: selectedCategories.map((
          category,
        ) {
          String? categoryName = category['category_name'];
          List<dynamic> eachSubCategory = category['sub_categories'];
          String? mainId = category['category_id'].toString();
          List<dynamic> allProducts = [];
          for (var subCategory in eachSubCategory) {
            allProducts.addAll(subCategory['products']);
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        categoryName!,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF868889)),
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        Get.toNamed(
                          '/displayMoreProducts',
                          parameters: {
                            'main_category_id': mainId.toString(),
                            'categoryName': categoryName,
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
                        child: Text(
                          "See all",
                          style: SafeGoogleFont(
                            'Poppins',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: -0.1650000066,
                            color: const Color(0xffAF6CDA),
                          ),
                        ),
                      )),
                ],
              ),
              Container(
                color: Colors.white,
                height: 170,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allProducts.length,
                  itemBuilder: (BuildContext context, int subIndex) {
                    return finalOutput(mainId, categoryName, eachSubCategory,
                        subIndex, allProducts);
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Padding finalOutput(String mainId, String categoryName,
      List<dynamic> eachSubCategory, int subIndex, List<dynamic> allProducts) {
    List<dynamic> choices = allProducts[subIndex]['choices'];
    var storeName = allProducts[subIndex]['st_store_name'] ?? "---";
    List<dynamic> filteredChoices =
        choices.where((choice) => choice['default_choice'] == '1').toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF2E7E7), width: 1.5),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
          boxShadow: const [
            BoxShadow(
              color: Colors.white10,
              blurRadius: 4,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        width: 165,
        child: GestureDetector(
          onTap: () {
            Get.toNamed(
              '/productDetail',
              parameters: {
                'main_category_id': mainId.toString(),
                'categoryName': categoryName.toString(),
                'sub_category_id':
                    allProducts[subIndex]['pro_sub_cat_id'].toString(),
                'productId': allProducts[subIndex]['pro_id'].toString(),
                'storeId': allProducts[subIndex]['pro_store_id'].toString(),
                "fromDashBoard": "true"
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: allProducts[subIndex]['pro_images'],
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    allProducts[subIndex]['pro_item_name'],
                    style: SafeGoogleFont("Poppins",
                        fontSize: 12.0,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        color: const Color(0xFF868889)),
                  ),
                ),
                // const SizedBox(height: 3),
                // Row(
                //   children: [
                //     const Icon(
                //       Icons.star,
                //       size: 15,
                //       color: Color(0xffAF6CDA),
                //     ),
                //     Text(
                //       "4.7",
                //       style: SafeGoogleFont(
                //         "Poppins",
                //         color: const Color(0xff868889),
                //         fontWeight: FontWeight.w500,
                //         fontSize: 11,
                //       ),
                //     ),
                //     const SizedBox(
                //       width: 5,
                //     ),
                //     const Icon(
                //       Icons.pin_drop,
                //       size: 15,
                //       color: Color(0xffAF6CDA),
                //     ),
                //     Text(
                //       "0.5 mi",
                //       style: SafeGoogleFont(
                //         "Poppins",
                //         color: const Color(0xff868889),
                //         fontWeight: FontWeight.w500,
                //         fontSize: 11,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          allProducts[subIndex]['pro_desc'],
                          style: SafeGoogleFont("Poppins",
                              fontSize: 10.0,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.2,
                              color: const Color(0xFF868889)),
                        ),
                      ),
                    ),
                    if (filteredChoices.isNotEmpty)
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 4.0,
                        children: filteredChoices.map<Widget>((choice) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              height: 22,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffAF6CDA),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                ),
                                child: Text(
                                  '${choice['ch_name']}',
                                  style: const TextStyle(
                                    fontSize: 9.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 16,
                          color: Color(0xffAF6CDA),
                        ),
                        Expanded(
                          child: Text(
                            " $storeName",
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                letterSpacing: 0.2,
                                fontWeight: FontWeight.w500,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getPageWidget(String route) {
    BoxDecoration decorationStyle = BoxDecoration(
      border: Border.all(color: const Color(0xffeeeeee), width: 2.0),
      color: Colors.white38,
      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(26, 133, 130, 130),
          blurRadius: 4,
          spreadRadius: 2,
          offset: Offset(0, 2),
        ),
      ],
    );

    switch (route) {
      case '/dashboard':
        return dashboardContents(decorationStyle, isLoading);
      case '/myCart':
        return const Center(
          child: Text('This is your shopping cart'),
        );
      default:
        return const Center(
          child: Text('Invalid route'),
        );
    }
  }

  Widget dashboardContents(BoxDecoration decorationStyle, bool isLoading) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildGrabOfferSection(),
            const SizedBox(height: 10),
            isLoading == false
                ? displayStoreData == true
                    ? Column(
                        children: [
                          dashboardCategories1.isNotEmpty
                              ? selectedProducts()
                              : Container(),
                          dashboardCategories1.isNotEmpty
                              ? productCategoriesWithSubCategoriesNew(
                                  dashboardCategories1)
                              : Container(),
                          const SizedBox(
                            height: 30,
                          ),
                          notSelectedProducts(
                              dashboardCategories2, decorationStyle),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                            child: SizedBox(
                              height: 200,
                              child: Text(
                                "Store not available for this particular location.",
                                style: SafeGoogleFont("Poppins",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: displayStoreData == true
                                        ? Colors.grey
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                : const SizedBox(
                    height: 250,
                    child: Center(
                      child: SpinKitCircle(
                        color: Color(0xffAF6CDA),
                        size: 50,
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

drawerDashboard(
  BuildContext context,
  DashboardController dashboardController,
) {
  TextStyle style = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: Color.fromARGB(255, 134, 137, 134),
    fontSize: 19,
  );
  final List<Map<String, dynamic>> accountSection = [
    {
      'leading': const Icon(
        Icons.person_outline_outlined,
        color: Color(0xFFAF6CDA),
      ),
      'title': Text('My Profile', style: style),
      'trailing': const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff868889),
      ),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/userProfile');
      },
    },
    {
      'leading': const Icon(
        Icons.favorite_outline_outlined,
        color: Color(0xFFAF6CDA),
      ),
      'title': Text('Interested Categories', style: style),
      'trailing': const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff868889),
      ),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/customerProductInterests',
            arguments: {'fromDashboard': 'true'});
      },
    },
    {
      'leading': const Icon(
        Icons.chat_outlined,
        color: Color(0xFFAF6CDA),
      ),
      'title': customerChatIndication(style, dashboardController),
      'trailing': const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xff868889),
      ),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed(
          '/customerAllChat',
        );
      },
    },
    {
      'leading': const Icon(Icons.history, color: Color(0xFFAF6CDA)),
      'title': Text('My Order History', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);

        Get.toNamed('/orderHistory');
      },
    },
    {
      'leading': const Icon(Icons.account_balance_wallet_outlined,
          color: Color(0xFFAF6CDA)),
      'title': Text('My Wallet', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/wallet');
      },
    },
    {
      'leading': const Icon(Icons.pin_drop_outlined, color: Color(0xFFAF6CDA)),
      'title': Text('My Address', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/YourAddress');
      },
    },
  ];

  final List<Map<String, dynamic>> storeDetailsSection = [
    {
      'leading':
          const Icon(Icons.person_outline_outlined, color: Color(0xFFAF6CDA)),
      'iconColor': const Color(0xFFAF6CDA),
      'title': storeChatIndication(dashboardController, style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'onTap': () async {
        Navigator.pop(context);
        dashboardController.clearControllerFromDashBoardAndNavigateTostore(
          context,
          dashboardController.isStoreCreated,
        );
      },
    },
    {
      'leading': const Icon(Icons.wallet_membership_outlined,
          color: Color(0xFFAF6CDA)),
      'title': Text('Bank Details', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/bankDetails');
      },
    },
    // {
    //   'leading':
    //       const Icon(Icons.notification_add_outlined, color: Color(0xFFAF6CDA)),
    //   'title': Text('Bunny Premium', style: style),
    //   'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
    //   'iconColor': const Color(0xFFAF6CDA),
    //   'onTap': () {
    //     Navigator.pop(context);
    //     Get.to(() => const SizedBox(
    //           child: UnderConstructionPage(
    //             pageTitle: "Bunny Premium",
    //           ),
    //         ));
    //   },
    // },
    // {
    //   'leading': const Icon(Icons.school_outlined, color: Color(0xFFAF6CDA)),
    //   'title': Text('Certificate', style: style),
    //   'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
    //   'iconColor': const Color(0xFFAF6CDA),
    //   'onTap': () {
    //     Navigator.pop(context);

    //     Get.to(() => const SizedBox(
    //           child: UnderConstructionPage(
    //             pageTitle: "Certificate",
    //           ),
    //         ));
    //   },
    // },
    // {
    //   'leading':
    //       const Icon(Icons.calendar_month_outlined, color: Color(0xFFAF6CDA)),
    //   'title': Text('Calender', style: style),
    //   'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
    //   'iconColor': const Color(0xFFAF6CDA),
    //   'onTap': () {
    //     Navigator.pop(context);
    //     Get.to(() => const SizedBox(
    //           child: UnderConstructionPage(
    //             pageTitle: "Calender",
    //           ),
    //         ));
    //   },
    // },
    // {
    //   'leading': const Icon(Icons.settings_outlined, color: Color(0xFFAF6CDA)),
    //   'title': Text('App Settings', style: style),
    //   'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
    //   'iconColor': const Color(0xFFAF6CDA),
    //   'onTap': () {
    //     Navigator.pop(context);
    //     Get.to(() => const SizedBox(
    //           child: UnderConstructionPage(
    //             pageTitle: "App Settings",
    //           ),
    //         ));
    //   },
    // },
    {
      'leading': const Icon(Icons.help_outline, color: Color(0xFFAF6CDA)),
      'title': Text('Help', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);
        Get.toNamed('/help');
      },
    },
    {
      'leading': const Icon(Icons.info_outline, color: Color(0xFFAF6CDA)),
      'title': Text('About', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);

        Get.toNamed('/aboutBunny');
      },
    },
    {
      'leading': const Icon(Icons.info_outline, color: Color(0xFFAF6CDA)),
      'title': Text('Delete Account', style: style),
      'trailing': const Icon(Icons.arrow_forward_ios, color: Color(0xff868889)),
      'iconColor': const Color(0xFFAF6CDA),
      'onTap': () {
        Navigator.pop(context);

        deleteUser(context, dashboardController);
      },
    },
  ];

  final List<Map<String, dynamic>> drawerItems = [
    {
      'title': Text(
        'My Account',
        style: SafeGoogleFont("Poppins",
            fontWeight: FontWeight.w600,
            color: const Color(0xff868889),
            fontSize: 25),
      ),
      'isHeader': true,
    },
    ...accountSection,
    {
      'title': Text('Selling',
          style: SafeGoogleFont("Poppins",
              fontWeight: FontWeight.w600,
              color: const Color(0xff868889),
              fontSize: 25)),
      'isHeader': true,
    },
    ...storeDetailsSection,
  ];

  return Drawer(
    width: MediaQuery.of(context).size.width - 50,
    backgroundColor: Colors.white,
    elevation: 2,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const SizedBox(height: 50),
        GestureDetector(
          onTap: () {
            Get.toNamed('/userProfile');
          },
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
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
                                  dashboardController.currentUserImage,
                                  width: 280,
                                  height: 280,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 151, 143, 196),
                          image:
                              (dashboardController.currentUserImage.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(
                                          dashboardController.currentUserImage),
                                      fit: BoxFit.cover)
                                  : null),
                        ),
                        child: null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dashboardController.currentUserName,
                        style: SafeGoogleFont(
                          "Poppins",
                          color: const Color.fromARGB(255, 37, 37, 37),
                          fontSize: 17,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        dashboardController.currentUserEmail,
                        style: SafeGoogleFont("Poppins",
                            color: const Color.fromARGB(255, 125, 126, 126),
                            fontSize: 13,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Divider(
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Color.fromARGB(255, 173, 143, 182),
        ),
        for (final item in drawerItems)
          ListTile(
            leading: item['leading'] is Widget ? item['leading'] : null,
            title: item['title'] is Widget
                ? item['title']
                : Text(
                    item['title'].toString(),

                    overflow: TextOverflow
                        .ellipsis, // Add ellipses if the text overflows
                  ),
            trailing: item['trailing'] is Widget ? item['trailing'] : null,
            onTap: item['onTap'] is Function ? item['onTap'] : () {},
          ),

        Padding(
          padding: const EdgeInsets.fromLTRB(5, 12, 12, 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              const Icon(
                Icons.logout,
                size: 32,
                color: Color(0xffFF4242),
              ),
              const SizedBox(width: 5),
              InkWell(
                onTap: () async {
                  await dashboardController.logOut(context);
                },
                child: Text(
                  'LOG OUT',
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff868889),
                      fontSize: 19),
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
        //   child: ElevatedButton(
        //     style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all<Color>(
        //           const Color.fromARGB(255, 194, 143, 226)),
        //     ),
        //     onPressed: () async {
        //       dashboardController.logOut(context);
        //     },
        //     child: Text(
        //       'LOG OUT',
        //       style: SafeGoogleFont("Poppins",
        //           fontWeight: FontWeight.w500,
        //           color: const Color.fromARGB(255, 40, 41, 41),
        //           fontSize: 19),
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

void deleteUser(BuildContext context, DashboardController dashboardController) {
  ButtonStyle elevatedButtonStyle1 = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(
          const Color.fromARGB(255, 181, 176, 184)));
  ButtonStyle elevatedButtonStyle2 = ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(const Color(0xffAF6CDA)));
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: Center(
          child: Text(
            "Do you want to delete your account and data?",
            style: SafeGoogleFont("Poppins",
                fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red),
          ),
        ),
        content: Text(
          "By Clicking 'Yes' you will be redirected to our website to continue the account deletion process.",
          style: SafeGoogleFont("Poppins",
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: const Color.fromARGB(255, 112, 111, 111)),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: elevatedButtonStyle1,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w500, color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: elevatedButtonStyle2,
            onPressed: () async {
              await dashboardController.logOut(context);
              launchURL("https://buywithbunny.com/request-account-deletion");
              Navigator.of(context).pop();
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

void launchURL(String url) async {
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

Widget storeChatIndication(
    DashboardController dashboardController, TextStyle style) {
  return Row(
    children: [
      Text(
          dashboardController.isStoreCreated == true
              ? 'My Store'
              : 'Create Store',
          style: style),
      const SizedBox(
        width: 5,
      ),
      dashboardController.buyerHasNewMessage == true
          ? const Text('New', style: TextStyle(fontSize: 12, color: Colors.red))
          : Container()
    ],
  );
}

Widget customerChatIndication(
    TextStyle style, DashboardController dashboardController) {
  return Row(
    children: [
      Text('Chat', style: style),
      const SizedBox(
        width: 5,
      ),
      dashboardController.sellerHasNewMessage == true
          ? const Text('New', style: TextStyle(fontSize: 12, color: Colors.red))
          : Container()
    ],
  );
}
