import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';

import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/cutomizedCounterSteper.dart';

class Buyerstore extends StatefulWidget {
  const Buyerstore({super.key});

  @override
  State<Buyerstore> createState() => NameState();
}

class NameState extends State<Buyerstore> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();
  String _storeId = "";
  List<dynamic> restaurantInfo = [];
  List<dynamic> itemList = [];
  int currentValue = 0;
  Map<int, int?> selectedChoiceMap = {};
  String customerPhoneNo = "";

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('storeId')) {
      setState(() {
        _storeId = parameters['storeId'];
      });
    }
    getstoreproducts(_storeId);
  }

  Future getstoreproducts(String storeId) async {
    var jsonData = await landingPageController.getstoreproducts(storeId);

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        itemList = jsonData['data']["item_list"];
        restaurantInfo = jsonData['data']['restaurant_info'];
        customerPhoneNo = jsonData['data']["cus_phone"];
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
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          body: SingleChildScrollView(
            child: restaurantInfo.isNotEmpty
                ? Stack(
                    children: [
                      Column(children: [
                        SizedBox(
                            width: Get.width,
                            height: 300,
                            child: buildImage(restaurantInfo[0]
                                    ['restaurant_banner'][0]
                                .toString())),
                        Container(
                          color: Colors.white,
                          height: 50,
                        ),
                        resturentInfo(
                          restaurantInfo,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Available Items",
                              style: SafeGoogleFont(
                                "Poppins",
                                color: const Color(0xFF868889),
                                fontSize: 20,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        productList(itemList),
                      ]),
                      backArrow(context),
                      // location(context),
                      logo(context,
                          restaurantInfo[0]['restaurant_logo'].toString()),
                    ],
                  )
                : const SizedBox(
                    height: 20,
                    child: SpinKitCircle(
                      color: Color(0xffAF6CDA),
                      size: 50,
                    )),
          ),
          bottomNavigationBar:
              bottomNavigationItems(currentIndex0, context, pageKeys),
        ),
      ),
    );
  }

  Widget resturentInfo(
    restaurantInfo,
  ) {
    String storeName = '';
    String restaurantStatus = '';
    String location = '';
    String restaurantRating = '';
    String minimumOrder = '';

    String banner = "";

    if (restaurantInfo != null) {
      storeName =
          restaurantInfo.isNotEmpty ? restaurantInfo[0]['restaurant_name'] : '';
      restaurantStatus = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['restaurant_banner'][0]
          : '';
      location = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['restaurant_location']
          : '';
      restaurantStatus = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['restaurant_status']
          : '';
      restaurantRating = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['restaurant_rating'].toString()
          : '';
      minimumOrder = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['minimum_order'].toString()
          : '';

      banner = restaurantInfo.isNotEmpty
          ? restaurantInfo[0]['restaurant_banner'].toString()
          : '';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        height: 165,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        size: 20,
                        color: Color(0xffAF6CDA),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        storeName,
                        style: SafeGoogleFont(
                          "Poppins",
                          color: const Color(0xFF868889),
                          fontSize: 20,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 22,
                        color: Color(0xffAF6CDA),
                      ),
                      Text(
                        location,
                        style: SafeGoogleFont(
                          "Poppins",
                          color: const Color(0xFF868889),
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.event_available,
                        size: 20,
                        color: Color(0xffAF6CDA),
                      ),
                      Text(
                        restaurantStatus,
                        style: SafeGoogleFont(
                          "Poppins",
                          color: const Color(0xFF868889),
                          fontSize: 15,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(),
                // const Icon(
                //   Icons.favorite,
                //   color: Colors.red,
                //   size: 28,
                // ),
                GestureDetector(
                  onTap: () {
                    // launchURL("tel:+12766161600");
                    launchURL("tel:$customerPhoneNo");
                  },
                  child: const Icon(
                    Icons.call_outlined,
                    size: 28,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    // String whatsappUrl = "whatsapp://send?phone=+12766161600";
                    String whatsappUrl =
                        "whatsapp://send?phone=$customerPhoneNo";

                    bool isWhatsAppInstalled = await canLaunch(whatsappUrl);
                    if (isWhatsAppInstalled) {
                      await launch(whatsappUrl);
                    } else {
                      Get.snackbar(
                          'Error', "WhatsApp is not installed on this device.",
                          snackPosition: SnackPosition.bottom,
                          duration: const Duration(milliseconds: 2200));
                    }
                  },
                  child: Image.asset(
                    'assets/images/whatsapp.png',
                  ),
                ),
                Text(
                  "Review",
                  style: SafeGoogleFont(
                    "Poppins",
                    color: const Color(0xFF868889),
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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

  Widget productList(List<dynamic> itemList) {
    List<dynamic> items = itemList;

    return Column(
      children: items.map((item) {
        var productId = item['item_id'];

        var itemHasChoice = item['item_has_choice'].toString();
        var choices = item['choices'] ?? [];
        var selectedChoiceId = selectedChoiceMap[productId];

        var selectedChoiceStock = 0;

        var choiceItemInCart = false;
        var choiceMrpPrice;
        String choiceItemCountInCart = "";
        String choiceItemCartId = "";
        Map<String, dynamic>? selectedChoice;
        if (selectedChoiceId == null && choices.isNotEmpty) {
          var defaultChoice = choices.firstWhere(
            (choice) => choice['default_choice'] == true,
            orElse: () => null,
          );

          if (defaultChoice != null) {
            selectedChoiceId = defaultChoice['choice_id'];
            selectedChoiceMap[productId] = selectedChoiceId;
          }
        }

        if (selectedChoiceId != null) {
          selectedChoice = choices.firstWhere(
            (choice) => choice['choice_id'] == selectedChoiceId,
            orElse: () => null,
          );

          if (selectedChoice != null) {
            selectedChoiceStock = selectedChoice['choice_stock'];
            choiceItemInCart = selectedChoice['choice_item_in_cart'];
            choiceMrpPrice = selectedChoice['choice_mrp_price'];
            choiceItemCountInCart =
                (selectedChoice['choice_item_count_in_cart'].toString());
            choiceItemCartId =
                (selectedChoice['choice_item_cart_id'].toString());
          }
        }
        currentValue = int.parse(choiceItemCountInCart.toString());
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(
                  color: const Color.fromARGB(255, 231, 229, 231), width: 1.5),
              color: const Color(0xffffffff),
            ),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item['item_image'],
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 105,
                      height: 80,
                      fit: BoxFit.fitHeight,
                    ),
                    const SizedBox(width: 20.0),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['item_name'],
                              style: SafeGoogleFont(
                                color: const Color(0xFF868889),
                                'Poppins',
                                fontSize: 17,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                item['rating'] == null
                                    ? Container()
                                    : ratingSction(item['rating']),
                                (item['travel_distance'] != null)
                                    ? distanceSection(item['travel_distance'])
                                    : Container(),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${item['item_discount_price']}',
                                  style: SafeGoogleFont(
                                    color: const Color(0xFF868889),
                                    'Poppins',
                                    fontSize: 17,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      choiceItemInCart == false
                                          ? SizedBox(
                                              height: 30,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: addToCartButton(
                                                    dashboardController,
                                                    context,
                                                    productId,
                                                    selectedChoiceId,
                                                    itemList),
                                              ),
                                            )
                                          : customizedCounter(
                                              selectedChoiceStock,
                                              context,
                                              productId,
                                              selectedChoiceId,
                                              itemList,
                                              choiceItemCartId,
                                              selectedChoice,
                                              choices),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ],
                ),
                if (itemHasChoice == 'Yes') ...[
                  displayChoiceChip(
                      choices, selectedChoiceId, productId, choiceItemInCart),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  ratingSction(rating) {
    return Row(
      children: [
        rating == null
            ? Container()
            : const Icon(
                Icons.star,
                size: 15,
                color: Color(0xffAF6CDA),
              ),
        Text(
          rating ?? '',
          style: SafeGoogleFont(
            "Poppins",
            color: const Color(0xff868889),
            fontWeight: FontWeight.w500,
            // letterSpacing: 0.5,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget distanceSection(distanceAsString) {
    return Row(
      children: [
        const Icon(
          Icons.pin_drop,
          size: 15,
          color: Color(0xffAF6CDA),
        ),
        Text(
          distanceAsString.toString(),
          style: SafeGoogleFont(
            "Poppins",
            color: const Color(0xff868889),
            fontWeight: FontWeight.w500,
            // letterSpacing: 0.5,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget buildImage(imageUrl) {
    print(imageUrl);
    return Stack(
      alignment: Alignment.center,
      children: [
        // Image.network(
        //   restaurantInfo[0]['restaurant_banner'].toString(),
        //   width: double.infinity,
        //   fit: BoxFit.fill,
        // ),
        Container(
          // width: 100,
          // height: 100,
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

  Positioned backArrow(BuildContext context) {
    return Positioned(
      top: 40,
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

  Positioned logo(BuildContext context, imageUrl) {
    return Positioned(
      top: 250,
      left: 24,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xffF1F1F5),
          ),
          child: Center(
            child: ClipOval(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 63, 35, 221),
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
    );
  }

  CustomizedCountStepper customizedCounter(
      int selectedChoiceStock,
      BuildContext context,
      id,
      selectedChoiceId,
      List<dynamic> itemList,
      choiceItemCartId,
      Map<String, dynamic>? selectedChoice,
      choices) {
    return CustomizedCountStepper(
        hasBackground: true,
        initialValue: currentValue,
        maxValue: selectedChoiceStock,
        onPressed: (value) async {
          if (value > 0) {
            var responseData = await dashboardController.addToCartController(
                context,
                id.toString(),
                selectedChoiceId.toString(),
                value.toString());

            if (responseData['code'] == 200) {
              globalFunctionToUpdateInStateLevel(responseData, itemList);
            }
          } else {
            var responseData = await dashboardController
                .removeItemFromCart(choiceItemCartId.toString());
            if (responseData != null && responseData['code'] == 200) {
              if (selectedChoiceId != null) {
                selectedChoice = choices.firstWhere(
                  (choice) =>
                      choice['choice_id'] == responseData['data']['choice_id'],
                  orElse: () => null,
                );
                if (selectedChoice != null) {
                  setState(() {
                    dashboardController.totalCartCount =
                        responseData['data']['total_cart_count'].toString();
                    selectedChoice!['choice_item_in_cart'] = false;
                  });
                }
              }

              Auth.setTotalCartCount(
                  responseData['data']['total_cart_count'].toString());
            }
          }
        });
  }

  ElevatedButton addToCartButton(
    DashboardController dashboardController,
    BuildContext context,
    productId,
    int? selectedChoiceId,
    List<dynamic> products,
  ) {
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
    );
    return ElevatedButton(
        style: elevatedButtonStyle,
        onPressed: () async {
          var responseData = await dashboardController.addToCartController(
            context,
            productId.toString(),
            selectedChoiceId.toString(),
            "1".toString(),
          );

          if (responseData != null && responseData['code'] == 200) {
            globalFunctionToUpdateInStateLevel(responseData, products);
          }
        },
        child: Text("Add",
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 12)));
  }

  Padding displayChoiceChip(
      choices, int? selectedChoiceId, productId, bool choiceItemInCart) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 4.0,
          runSpacing: 8.0,
          children: [
            for (var choice in choices)
              SizedBox(
                height: 30,
                child: ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text('${choice['choice_name']}'),
                  ),
                  selected: selectedChoiceId == choice['choice_id'] ||
                      (selectedChoiceId == null &&
                          choice['default_choice'] == true),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedChoiceMap[productId] =
                          selected ? choice['choice_id'] : null;
                      selectedChoiceId = choice['choice_id'];
                      selectedChoiceMap[productId] = selectedChoiceId;
                      choiceItemInCart = choice['choice_item_in_cart'];
                    });
                  },
                  showCheckmark: false,
                  selectedColor: const Color(0xffaf6cda).withOpacity(.35),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void globalFunctionToUpdateInStateLevel(
      Map<String, dynamic> responseData, products) {
    var productIndex = products.indexWhere(
        (product) => product['item_id'] == responseData['data']['item_id']);
    setState(() {
      if (productIndex != -1) {
        if (productIndex >= 0 && productIndex < products.length) {
          products[productIndex]['item_id'] = responseData['data']['item_id'];

          List<Map<String, dynamic>> choices = List<Map<String, dynamic>>.from(
              products[productIndex]["choices"]);
          for (int i = 0; i < choices.length; i++) {
            if (choices[i]["choice_id"].toString() ==
                responseData['data']["choice_id"].toString()) {
              choices[i]["choice_item_cart_id"] =
                  responseData['data']["cart_id"].toString();
              choices[i]["choice_item_in_cart"] = true;
              choices[i]["choice_item_count_in_cart"] =
                  responseData['data']["cart_quantity"].toString();

              Auth.setTotalCartCount(
                  responseData['data']["total_cart_count"].toString());
              Auth.setTotalCartAmount(
                  responseData['data']["total_cart_amount"].toString());
              dashboardController.totalCartCount =
                  responseData['data']["total_cart_count"].toString();
              break;
            }
          }
        }
      }
    });
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
        // Navigator.pushNamed(context, pageKeys[index]);
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
}

class Product {
  final String name;
  final String imageUrl;
  final double distance;
  final double price;

  Product(
      {required this.name,
      required this.imageUrl,
      required this.distance,
      required this.price});
}
