import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/cutomizedCounterSteper.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  MyCartState createState() => MyCartState();
}

class MyCartState extends State<MyCart> {
  int currentValue = 0;
  String? totalAmountForCheckout;
  String? subTotalForCheckout;
  String? deliveryFeeForCheckout;
  bool loadMycart = false;
  @override
  void initState() {
    super.initState();
    loadMycart = true;
    fetchCartData();
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('categoryName') &&
        parameters.containsKey('main_category_id')) {
      var categoryName = parameters['categoryName'];
      var catId = parameters['main_category_id'];
      setState(() {
        dashboardController.categoryName = categoryName;
        dashboardController.selectedCategoryId = catId;
        dashboardController.routeFromDashboard = false;
      });
    } else {
      setState(() {
        dashboardController.routeFromDashboard = true;
      });
    }
  }

  Future fetchCartData() async {
    var jsonData = await dashboardController.myCart();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
    } else {
      if (jsonData != null) {
        var totalCartAmountForCheckout1 =
            jsonData['data'][0]['total_cart_amount'].toString();
        var subTotalForCheckout1 =
            jsonData['data'][0]['cart_sub_total'].toString();
        var deliveryFeeForCheckout1 =
            jsonData['data'][0]['delivery_fee'].toString();
        Future<void>.delayed(const Duration(seconds: 2));
        Auth.setTotalAmount(totalCartAmountForCheckout1);
        Auth.setSubTotalAmount(subTotalForCheckout1);
        Auth.setDeliveryFee(deliveryFeeForCheckout1);
        setState(() {
          totalAmountForCheckout = totalCartAmountForCheckout1;
          subTotalForCheckout = subTotalForCheckout1;
          deliveryFeeForCheckout = deliveryFeeForCheckout1;
          dashboardController.cartData = jsonData['data'][0];
          loadMycart = false;
        });
      } else {
        setState(() {
          loadMycart = false;
          dashboardController.cartData = null;
        });
      }
    }
  }

  fetchProductItemsOnclick(String mainId, String subId) async {
    var jsonData1 =
        await dashboardController.fetchProductItems(mainId, subId, "", "");
    if (jsonData1['code'] == 400) {
      Get.snackbar('Failure', jsonData1['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      setState(() {
        dashboardController.selectedCategoryId = subId;
        dashboardController.products = [];
      });
    } else {
      if (jsonData1['data']['item_lists'] != []) {
        setState(() {
          dashboardController.tempData =
              List.from(dashboardController.products);
          dashboardController.products = jsonData1['data']['item_lists'];
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    int currentIndex0 = 3;

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
            appBar: appBar(dashboardController, "My Cart", context, true),
            body: RefreshIndicator(
              color: Colors.white,
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await fetchCartData();
                return Future<void>.delayed(const Duration(seconds: 1));
              },
              child: loadMycart == false
                  ? myCartDrawer(dashboardController)
                  : const Center(
                      child: SpinKitCircle(
                        color: Color(0xffAF6CDA),
                        size: 50,
                      ),
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
                          width: 12,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          constraints: const BoxConstraints(
                            maxWidth: 12,
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

  void showSequenceOfDialogs() {
    dashboardController.cartData['pre_order_error'] != []
        ? addMessagesToDialogList(
            dashboardController.cartData['pre_order_error'], 'Pre Order Error')
        : [];

    dashboardController.cartData['quantity_error'] != []
        ? addMessagesToDialogList(
            dashboardController.cartData['quantity_error'], 'Quantity Error')
        : [];
    dashboardController.cartData['minimum_order_error'] != []
        ? addMessagesToDialogList(
            dashboardController.cartData['minimum_order_error'],
            'Minimum Order Error')
        : [];

    showNextDialog(0);
  }

  void addMessagesToDialogList(List<dynamic>? errors, String dialogTitle) {
    if (errors != null && errors.isNotEmpty) {
      dashboardController.messagesList.add([
        '$dialogTitle:',
        for (String errorMessage in errors) errorMessage,
      ]);
    }
  }

  void showNextDialog(int currentIndex) {
    if (currentIndex < dashboardController.messagesList.length) {
      showAlertDialog('Dialog ${currentIndex + 1}',
          dashboardController.messagesList[currentIndex], currentIndex + 1);
    }
  }

  void showAlertDialog(String title, List<String> messages, int currentIndex) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (String message in messages) Text(message),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showNextDialog(currentIndex);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  myCartDrawer(DashboardController dashboardController) {
    if (dashboardController.cartData != null) {
      final totalCartAmount =
          dashboardController.cartData['total_cart_amount'].toString();
      final currencyCode =
          dashboardController.cartData['currency_code'].toString();
      var addedItemDetails =
          dashboardController.cartData['cart_details'][0]['added_item_details'];
      ButtonStyle elevatedButtonStyle = ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
      );

      return Container(
          color: Colors.white,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 20, 0),
                  child: GestureDetector(
                    onTap: () {
                      clearAllItems(context);
                    },
                    child: const Text(
                      'Clear all',
                      style: TextStyle(
                          color: Color(0xffAF6CDA),
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
              // const Divider(
              //   indent: 10,
              //   thickness: 2,
              //   endIndent: 10,
              // ),
              // SizedBox(
              //   height: Get.height * 0.1,
              //   child: Text(
              //     dashboardController.cartData['cart_details'][0]['store_name'],
              //     style: const TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              cartItems(addedItemDetails),
              pricingDetails(totalCartAmount, currencyCode),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () {
                        // showSequenceOfDialogs();
                        Get.toNamed('/checkout');
                      },
                      child: Text(
                        "Checkout",
                        style: SafeGoogleFont("Poppins",
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ));
    } else {
      return const Center(
        child: Text(
          "Your cart is empty!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      );
    }
  }

  void clearAllItems(BuildContext context) {
    ButtonStyle elevatedButtonStyle1 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 181, 176, 184)));
    ButtonStyle elevatedButtonStyle2 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xffAF6CDA)));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Center(
            child: Text(
              "Clear All",
              style: SafeGoogleFont("Poppins",
                  fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
          content: Text(
            "Do you want to Clear all items from the Cart?",
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),
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
                Navigator.of(context).pop();
                var jsonData =
                    await dashboardController.removeAllItemsFromCart();
                if (jsonData['message'] == "Cart cleared successfully") {
                  Get.snackbar('Success', jsonData['message'],
                      snackPosition: SnackPosition.bottom,
                      duration: const Duration(milliseconds: 1000));
                  await fetchProductItemsOnclick(
                      "${dashboardController.selectedCategoryId}",
                      "${dashboardController.selectedSubCategoryId}");
                  setState(() {
                    dashboardController.cartData = null;
                    dashboardController.totalCartCount = '-1';
                    Auth.setTotalCartCount('0');
                  });
                  Get.toNamed(
                    '/displayMoreProducts',
                    parameters: {
                      'main_category_id': dashboardController.categoryName!,
                      'categoryName': dashboardController.selectedCategoryId!,
                    },
                  );
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

  void deleteSingleItemFromCart(String choiceItemCartId, BuildContext context) {
    ButtonStyle elevatedButtonStyle1 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 181, 176, 184)));
    ButtonStyle elevatedButtonStyle2 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor:
            MaterialStateProperty.all<Color>(const Color(0xffAF6CDA)));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          title: Center(
            child: Text(
              "Delete",
              style: SafeGoogleFont("Poppins",
                  fontSize: 17, fontWeight: FontWeight.w600, color: Colors.red),
            ),
          ),
          content: Text(
            "Do you want to delete an item from the Cart?",
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),
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
                Navigator.of(context).pop();
                var responseData = await dashboardController
                    .removeItemFromCart(choiceItemCartId.toString());
                if (responseData != null && responseData['code'] == 200) {
                  await fetchCartData();
                } else {
                  null;
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

  SizedBox pricingDetails(String totalCartAmount, String currencyCode) {
    String finalCode = currencyCode == "null" ? "\$" : currencyCode;
    return SizedBox(
      height: Get.height * 0.20,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Divider(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff585858)),
                ),
                Text(
                  "$finalCode$totalCartAmount",
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xffAF6CDA)),
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delivery charge",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff585858)),
                ),
                Text(
                  " 0.00",
                  style: TextStyle(fontSize: 16, color: Color(0xffAF6CDA)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff585858)),
                ),
                Text(
                  "$finalCode$totalCartAmount",
                  style:
                      const TextStyle(fontSize: 16, color: Color(0xffAF6CDA)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Expanded cartItems(addedItemDetails) {
    return Expanded(
      child: ListView.builder(
        itemCount: addedItemDetails.length,
        itemBuilder: (BuildContext context, int index) {
          final item = addedItemDetails[index];
          var productId = item['product_id'];
          var productName = item['product_name'];
          var productImage = item['product_image'];
          var cartQuantity = item['cart_quantity'];
          var cartId = item['cart_id'];
          var firstChoiceAmount = item["cart_has_choice"] == "Yes"
              ? item["cart_choices"][0]["choice_amount"]
              : null;
          var firstChoiceName = item["cart_has_choice"] == "Yes"
              ? item["cart_choices"][0]["choice_name"]
              : null;
          var selectedChoiceId = item["cart_has_choice"] == "Yes"
              ? item["cart_choices"][0]["choice_id"]
              : null;
          return Column(
            children: [
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: 60,
                          height: 70,
                          child: CachedNetworkImage(
                            fit: BoxFit.fitHeight,
                            imageUrl: productImage,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color(0xff868889)),
                          ),
                          Text(
                            '$firstChoiceName',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xff585858)),
                          ),
                          Row(children: [
                            const Text(
                              'Price: ',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xff585858)),
                            ),
                            Text(
                              '\$$firstChoiceAmount',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: Color(0xffAF6CDA)),
                            ),
                          ]),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          deleteButton(cartId),
                          // const Text(
                          //   "You saved 18.00",
                          //   style: TextStyle(
                          //       fontSize: 8, color: Color(0xff585858)),
                          // ),
                          const SizedBox(
                            height: 25,
                          ),
                          incrementAndDecrement(cartQuantity, productId,
                              selectedChoiceId, cartId),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                endIndent: 25,
                indent: 25,
              )
            ],
          );
        },
      ),
    );
  }

  Widget deleteButton(var choiceItemCartId) {
    return GestureDetector(
        onTap: () async {
          deleteSingleItemFromCart(choiceItemCartId.toString(), context);
        },
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.red,
        ));
  }

  incrementAndDecrement(
      cartQuantity, productId, selectedChoiceId, choiceItemCartId) {
    currentValue = int.parse(cartQuantity.toString());
    return Align(
      alignment: Alignment.topRight,
      child: CustomizedCountStepper(
          hasBackground: false,
          initialValue: currentValue,
          maxValue: 20,
          onPressed: (value) async {
            if (value > 0) {
              var responseData = await dashboardController.addToCartController(
                  context,
                  productId.toString(),
                  selectedChoiceId.toString(),
                  value.toString());
              if (responseData['code'] == 200) {
                await fetchCartData();
              } else {
                null;
              }
            } else {
              var responseData = await dashboardController
                  .removeItemFromCart(choiceItemCartId.toString());
              if (responseData != null && responseData['code'] == 200) {
                await fetchCartData();
              } else {
                null;
              }
            }
          }),
    );
  }
}

appBar(DashboardController dashboardController, String title,
    BuildContext context, bool val) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(appBarHeight + 5),
    child: Container(
      color: Colors.white,
      padding: getPadding(top: 10, bottom: 2, left: 20, right: 20),
      child: CustomAppBar(
        height: getVerticalSize(
          65,
        ),
        leadingWidth: 32,
        leading: InkWell(
            onTap: () {
              Get.offAllNamed('/dashboard');
            },
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            title,
            style: SafeGoogleFont(
              "Poppins",
              fontWeight: FontWeight.w500,
              color: const Color(0xff808089),
              fontSize: 20,
            ),
          ),
        ),
        actions: [
          // CircleAvatar(
          //   backgroundImage: AssetImage('assets/images/Mask.png'),
          // )
          val == true
              ? GestureDetector(
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
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(dashboardController.currentUserImage),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}
