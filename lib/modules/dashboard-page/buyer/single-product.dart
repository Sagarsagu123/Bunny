import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/cutomizedCounterSteper.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ProductD {
  final int? itemId;
  final String? itemName;
  final String? itemDesc;
  final String? itemOriginalPrice;
  final String? itemHasDiscount;
  final String? itemImage;
  final List<Choice>? choices;

  ProductD({
    this.itemId,
    this.itemName,
    this.itemDesc,
    this.itemOriginalPrice,
    this.itemHasDiscount,
    this.itemImage,
    this.choices,
  });

  factory ProductD.fromJson(Map<String, dynamic> json) {
    List<dynamic>? choicesJson = json['choices'];
    List<Choice>? choices =
        choicesJson?.map((choice) => Choice.fromJson(choice)).toList();

    return ProductD(
      itemId: json['item_id'],
      itemName: json['item_name'],
      itemDesc: json['item_desc'],
      itemOriginalPrice: json['item_original_price'],
      itemHasDiscount: json['item_has_discount'],
      itemImage: json['item_image'],
      choices: choices,
    );
  }
}

class Choice {
  final int? choiceId;
  final String? choiceName;
  final String? choicePrice;
  final bool? defaultChoice;

  Choice({
    this.choiceId,
    this.choiceName,
    this.choicePrice,
    this.defaultChoice,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choiceId: json['choice_id'],
      choiceName: json['choice_name'],
      choicePrice: json['choice_price'],
      defaultChoice: json['default_choice'] ?? false,
    );
  }
}

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ProductDetailPageState createState() => ProductDetailPageState();
}

class ProductDetailPageState extends State<ProductDetailPage> {
  Choice? _selectedChoice;
  int currentValue = 0;
  var firstItemImage;

  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<dynamic> tempData = [];
  List<dynamic> customerProfile = [];
  Map<int, int?> selectedChoiceMap = {};
  bool isLoading = true;
  final GlobalKey<FormState> _messageFormKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCustomerProfileDetail();
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('categoryName') ||
        parameters.containsKey('main_category_id') ||
        parameters.containsKey('sub_category_id') ||
        parameters.containsKey('productId') ||
        parameters.containsKey('storeId') ||
        parameters.containsKey('fromDashBoard')) {
      var categoryName = parameters['categoryName'];
      var catId = parameters['main_category_id'];
      var subCatId = parameters['sub_category_id'];
      var productId = parameters['productId'];
      var storeId = parameters['storeId'];
      bool fromDashBoard;
      if (parameters.containsKey('fromDashBoard')) {
        fromDashBoard = true;
      } else {
        fromDashBoard = false;
      }

      setState(() {
        dashboardController.categoryName = categoryName;
        dashboardController.selectedCategoryId = catId;
        dashboardController.selectedSubCategoryId = subCatId;
        dashboardController.currentProductId = productId;
        dashboardController.storeId = storeId;
        dashboardController.fromDashBoard = fromDashBoard;
        isLoading = true;
      });

      fetchProductItemsOnclick(catId.toString(), subCatId.toString(),
          productId.toString(), storeId.toString());
    }
  }

  Future getCustomerProfileDetail() async {
    var jsonData1 = await dashboardController.getCustomerProfileDetail();
    if (jsonData1 != null && jsonData1['code'] == 400) {
    } else {
      // setState(() {
      //   customerProfile = jsonData1['data'];
      // });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _messageController.dispose();
    super.dispose();
  }

  Future fetchProductItemsOnclick(
      String mainId, String subId, String productId, String storeId) async {
    var jsonData1 =
        await dashboardController.fetchProductItems(mainId, subId, "", storeId);
    if (jsonData1['code'] == 400) {
      Get.snackbar('Failure', jsonData1['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      setState(() {
        isLoading = true;
        dashboardController.products = [];
      });
    } else if (jsonData1['code'] == 500) {
      Get.snackbar('Failure', jsonData1['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
    } else if (jsonData1['code'] == 200) {
      if (jsonData1['data']['item_lists'] != []) {
        var filteredData = jsonData1['data']['item_lists']
            .where((item) => item['item_id'].toString() == productId.toString())
            .toList();
        Future.delayed(const Duration(milliseconds: 600), () {
          setState(() {
            tempData = List.from(dashboardController.products);
            dashboardController.products = jsonData1['data']['item_lists']
                .where((item) =>
                    item['item_id'].toString() != productId.toString())
                .toList();

            dashboardController.singleProduct = filteredData;
            isLoading = false;
          });
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar(dashboardController, context),
          body: SizedBox(
            child: isLoading == true
                ? const SizedBox(
                    child: SpinKitCircle(
                    color: Color(0xffAF6CDA),
                    size: 50,
                  ))
                : productDesign(dashboardController.singleProduct),
          ),
        ),
      ),
    );
  }

  productDesign(singleProduct) {
    if (singleProduct.isNotEmpty) {
      firstItemImage = singleProduct[0]["item_image"];

      if (firstItemImage != null) {
        firstItemImage = singleProduct[0]["item_image"];
      }
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              padding: getPadding(top: 2, bottom: 2),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ImageConstant.individualroductImage),
                      fit: BoxFit.fill)),
            ),
            Positioned.fill(
              top: 5,
              child: Stack(alignment: Alignment.topCenter, children: [
                Align(
                  child: SizedBox(
                    height: getVerticalSize(305),
                    child: (firstItemImage != '' || firstItemImage != null)
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: firstItemImage,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const Icon(Icons.error),
                  ),
                ),
              ]),
            ),
          ],
        ),
        Expanded(
          child: productData(singleProduct, _messageFormKey),
        )
      ],
    );
  }

  ListView productData(List<dynamic> singleProduct, messageFormKey) {
    return ListView.builder(
      itemCount: singleProduct.length,
      itemBuilder: (context, index) {
        var product = singleProduct[index];

        var productId = product['item_id'];
        var productName = product['item_name'];
        var productDesc = product['item_desc'];
        var itemHasChoice = product['item_has_choice'].toString();
        var choices = product['choices'] ?? [];
        var tags = product['item_tags'] ?? [];
        var selectedChoiceId = selectedChoiceMap[productId];
        var selectedChoiceStock = 0;
        var choiceItemInCart = false;
        //// store

        var storeName = product['store_name'];
        var storeId = product['store_id'];
        var choiceName;
        String choiceItemCountInCart = "";
        String choiceItemCartId = '';
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
            choiceName = selectedChoice['choice_price'];

            choiceItemCountInCart =
                (selectedChoice['choice_item_count_in_cart'].toString());
            choiceItemCartId =
                (selectedChoice['choice_item_cart_id'].toString());
          }
        }
        currentValue = int.parse(choiceItemCountInCart.toString());
        ButtonStyle elevatedButtonStyle = ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust the radius as needed
              ),
            ),
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xffAF6CDA)));
        ButtonStyle elevatedButtonStyle1 = ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust the radius as needed
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.grey));
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productName,
                      style: SafeGoogleFont("Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                          color: const Color(0xff868889)),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: _scaffoldKey.currentContext!,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AlertDialog(
                                insetPadding: const EdgeInsets.all(10),
                                title: const Text(
                                  "Chat with Store Owner",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                                content: SingleChildScrollView(
                                  child: Form(
                                    key: messageFormKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          maxLines: null,
                                          controller: _messageController,
                                          decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 15.0),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            labelText: 'Message',
                                            hintText: 'Type your message here',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a message';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: elevatedButtonStyle1,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _messageController.clear();
                                      },
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: elevatedButtonStyle,
                                      onPressed: () async {
                                        if (messageFormKey.currentState
                                            .validate()) {
                                          var data = await dashboardController
                                              .sendMsgFromCusToSeller(storeId,
                                                  _messageController.text);
                                          if (data != null) {
                                            _messageController.clear();
                                            Navigator.of(context).pop();
                                          }
                                        }
                                      },
                                      child: const Text(
                                        'Send',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.chat_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
                GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        '/Buyerstore',
                        parameters: {
                          'storeId': storeId,
                        },
                      );
                    },
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 20,
                              color: Color(0xffAF6CDA),
                            ),
                            Expanded(
                              child: Text(
                                " $storeName",
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    letterSpacing: 0.2,
                                    color: Color(0xff868889),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                    //  Text(
                    //   storeName,
                    //   style: SafeGoogleFont("Poppins",
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 16,
                    //       color: const Color(0xff868889)),
                    // ),
                    ),

                Wrap(children: [
                  Text(
                    "\$",
                    style: SafeGoogleFont(
                      "Poppins",
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff868889),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "$choiceName",
                    style: SafeGoogleFont(
                      "Poppins",
                      color: const Color(0xffDA412A),
                      fontSize: 16,
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productDesc,
                      style: SafeGoogleFont("Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: const Color(0xff979899)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 30,
                        child: choiceItemInCart == false
                            ? ElevatedButton(
                                style: elevatedButtonStyle,
                                onPressed: () async {
                                  var responseData = await dashboardController
                                      .addToCartController(
                                    context,
                                    productId.toString(),
                                    selectedChoiceId.toString(),
                                    "1".toString(),
                                  );

                                  if (responseData != null &&
                                      responseData['code'] == 200) {
                                    globalFunctionToUpdateInStateLevel(
                                        responseData, singleProduct);
                                  }
                                },
                                child: Text('Add',
                                    style: SafeGoogleFont("Poppins",
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 12)),
                              )
                            : SizedBox(
                                height: 30,
                                child: Column(
                                  children: [
                                    customizedCounter(
                                        selectedChoiceStock,
                                        dashboardController,
                                        context,
                                        productId,
                                        selectedChoiceId,
                                        singleProduct,
                                        choiceItemCartId,
                                        selectedChoice,
                                        choices),
                                  ],
                                )),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton(
                //   onPressed: () {
                //     _showChoicesDialog(context, widget.product.choices);
                //   },
                //   child: const Text('View Choices'),
                // ),
                const SizedBox(height: 20),

                if (itemHasChoice == 'Yes') ...[
                  displayChoiceChip(
                      choices, selectedChoiceId, productId, choiceItemInCart),
                ],
                tags.length > 0
                    ? productTags(tags)
                    : const SizedBox(
                        height: 10,
                      ),
                productList(dashboardController.products),
              ]),
        );
      },
    );
  }

  Widget productTags(tags) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Image.network(
                    tags[index]["image"],
                    width: 80,
                    height: 80,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding displayChoiceChip(
    List<dynamic> choices,
    int? selectedChoiceId,
    int productId,
    bool choiceItemInCart,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            for (var choice in choices)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedChoiceMap[productId] =
                        selectedChoiceId == choice['choice_id']
                            ? null
                            : choice['choice_id'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: selectedChoiceId == choice['choice_id'] ||
                            (selectedChoiceId == null &&
                                choice['default_choice'] == true)
                        ? const Color(0xffAF6CDA)
                        : Colors.grey[300],
                  ),
                  child: Text(
                    '${choice['choice_name']}',
                    style: TextStyle(
                      color: selectedChoiceId == choice['choice_id'] ||
                              (selectedChoiceId == null &&
                                  choice['default_choice'] == true)
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  CustomizedCountStepper customizedCounter(
      int selectedChoiceStock,
      DashboardController dashboardController,
      BuildContext context,
      productId,
      int? selectedChoiceId,
      List<dynamic> products,
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
                productId.toString(),
                selectedChoiceId.toString(),
                value.toString());

            if (responseData['code'] == 200) {
              globalFunctionToUpdateInStateLevel(responseData, products);
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

  productList(List products) {
    return products.isNotEmpty
        ? Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "View Options",
                    style: SafeGoogleFont("Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 94, 92, 92)),
                  )),
              SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = products[index];

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            '/productDetail',
                            parameters: {
                              'main_category_id':
                                  item['pro_category_id'].toString(),
                              'categoryName':
                                  item['main_category_name'].toString(),
                              'sub_category_id':
                                  item['pro_sub_cat_id'].toString(),
                              'productId': item['item_id'].toString(),
                              'storeId': item['store_id'].toString(),
                              "fromDashBoard": "true"
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color: const Color.fromARGB(255, 224, 224, 231),
                                width: 1.0,
                              ),
                            ),
                            width: 140.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  item['item_image'],
                                  width: 90,
                                  height: 90,
                                  // fit: BoxFit.fill,
                                ),
                                const SizedBox(height: 4.0),
                                Center(
                                  child: Text(
                                    item['item_name'],
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Color.fromARGB(255, 63, 62, 62),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )),
            ],
          )
        : Container();
  }
}

appBar(DashboardController dashboardController, BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(appBarHeight + 25),
    child: Container(
      padding: getPadding(left: 20, right: 10, top: 10),
      child: CustomAppBar(
        height: getVerticalSize(
          65,
        ),
        leadingWidth: 30,
        leading: InkWell(
          onTap: () {
            dashboardController.fromDashBoard.toString() == "true"
                ? Get.offNamed('/dashboard')
                : Get.toNamed(
                    '/displayMoreProducts',
                    parameters: {
                      'main_category_id':
                          dashboardController.selectedCategoryId!,
                      'categoryName': dashboardController.categoryName!,
                    },
                  );
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        centerTitle: false,
        title: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 151, 143, 196),
                    image: (dashboardController.currentUserImage.isNotEmpty
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
            const SizedBox(
              width: 10,
            ),
            Text(
              dashboardController.currentUserName,
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: const Color.fromARGB(255, 54, 53, 53),
                  fontSize: 18),
            ),
          ],
        ),
        actions: [cartIcon(dashboardController)],
      ),
    ),
  );
}

cartIcon(DashboardController dashboardController) {
  return IconButton(
    icon: Stack(
      children: [
        const Icon(
          Icons.shopping_cart,
          size: 35,
        ),
        (dashboardController.totalCartCount != '-1' &&
                dashboardController.totalCartCount != '0')
            ? Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    dashboardController.totalCartCount,
                    style: SafeGoogleFont(
                      "Poppins",
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    ),
    onPressed: () {
      Get.toNamed(
        '/myCart',
        parameters: {
          'main_category_id': dashboardController.categoryName!,
          'categoryName': dashboardController.selectedCategoryId!,
        },
      );
    },
  );
}

class CircleWidget extends StatelessWidget {
  final String logo;
  final String value;
  final String description;
  final Color circleColor;

  const CircleWidget({
    super.key,
    required this.logo,
    required this.value,
    required this.description,
    required this.circleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9), width: 1.0),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 4.0),
          CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage(logo),
          ),
          const SizedBox(height: 2.0),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 8.0,
            ),
          ),
          const SizedBox(height: 3.0),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
