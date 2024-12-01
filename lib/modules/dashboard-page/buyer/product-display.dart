// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/cutomizedCounterSteper.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ProductSubcategoryList extends StatefulWidget {
  const ProductSubcategoryList({super.key});

  @override
  ProductSubcategoryListState createState() => ProductSubcategoryListState();
}

class ProductSubcategoryListState extends State<ProductSubcategoryList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();

  List<dynamic> subCategory = [];
  List<dynamic> tempData = [];
  int selectedSubcategoryIndex = 0;
  int count = 0;
  Map<int, int?> selectedChoiceMap = {};
  int currentDialog = 0;
  bool displayLoading = false;
  List<List<String>> messagesList = [];
  // final TextEditingController _searchController = TextEditingController();
  bool enableCircularForWholePage = false;
  bool isDropdownOpen = false;
  int currentValue = 0;
  bool loadingForEntireScreen = false;
  @override
  void initState() {
    super.initState();
    loadingForEntireScreen = true;
    glbalFunctionToSupportPageRefresh();
  }

  Future glbalFunctionToSupportPageRefresh() async {
    setState(() {
      dashboardController.products = [];
      loadingForEntireScreen = true;
      dashboardController.selectedProductCategoryForDroDown = null;
    });
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('categoryName') ||
        parameters.containsKey('main_category_id')) {
      var categoryName = parameters['categoryName'];
      var catId = parameters['main_category_id'];
      _getCategoriesListForDropDown();
      _getSubCategoriesList(catId.toString(), 'true');
      setState(() {
        dashboardController.categoryName = categoryName;
        dashboardController.selectedCategoryId = catId;
        loadingForEntireScreen = false;
      });
    }
    _getAuthCode();
  }

  assignSelectedCategoryToDropDown(catId) {
    if (catId != null) {
      var selectedCategory =
          dashboardController.productChoicesForDropDown.firstWhere(
        (category) => category['category_id'].toString() == catId.toString(),
      );
      setState(() {
        dashboardController.selectedProductCategoryForDroDown =
            selectedCategory['category_name'];
        dashboardController.selectedProductCategoryIdForDroDown =
            selectedCategory['category_id'];
      });
    } else {
      setState(() {
        dashboardController.selectedProductCategoryForDroDown = '';
      });
    }
  }

  Future _getCategoriesListForDropDown() async {
    var jsonData = await landingPageController.getMainCategoriesList();

    List<dynamic> categoryDetails = jsonData['data']['category_Details'];
    if (categoryDetails.isNotEmpty) {
      setState(() {
        dashboardController.productChoicesForDropDown = categoryDetails;
      });
    }
  }

  Future? _getAuthCode() async {
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

  Future _getSubCategoriesList(
      String selectedCategoryId, String isMainApi) async {
    setState(() {
      dashboardController.products = [];
    });
    var jsonData = await dashboardController.getSubCategoryProducts(
        selectedCategoryId.toString(), isMainApi);
    var jsonData1;
    List subCategory1 = jsonData['data']['sub_category_Details'];
    if (subCategory1.isNotEmpty) {
      var firstSubcategoryId = subCategory1[0]['sub_category_id'].toString();
      setState(() {
        dashboardController.selectedSubCategoryId = firstSubcategoryId;
        subCategory = subCategory1;
        enableCircularForWholePage = false;
      });
      // TODO
      // Need to call "category_based_product" API to fetch all items specific to each sub category
      jsonData1 = await dashboardController.fetchProductItems(
          selectedCategoryId, firstSubcategoryId, '', "");
      if (jsonData1['code'] == 400) {
        Get.snackbar('Failure', jsonData1['message'],
            snackPosition: SnackPosition.bottom,
            duration: const Duration(milliseconds: 1000));

        setState(() {
          dashboardController.products = [];
        });
      } else {
        if (jsonData1['data']['item_lists'] != []) {
          setState(() {
            dashboardController.products = jsonData1['data']['item_lists'];
          });
        }
      }
      setState(() {
        dashboardController.products = jsonData1['data']['item_lists'];
        dashboardController.totalCartCount =
            jsonData1['data']['total_cart_count'].toString();
      });
      assignSelectedCategoryToDropDown(selectedCategoryId.toString());

      Auth.setTotalCartCount(jsonData1['data']["total_cart_count"].toString());
    } else {
      subCategory = [];
      dashboardController.products = [];
    }
  }

  fetchProductItemsOnclick(String mainId, String subId) async {
    setState(() {
      dashboardController.products = [];
    });
    var jsonData1 =
        await dashboardController.fetchProductItems(mainId, subId, "", "");
    if (jsonData1['code'] == 400) {
      Get.snackbar('Failure', jsonData1['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      setState(() {
        dashboardController.selectedCategoryId = subId;
        dashboardController.products = [];
        displayLoading = true;
      });
    } else {
      if (jsonData1['data']['item_lists'] != []) {
        setState(() {
          tempData = List.from(dashboardController.products);
          displayLoading = false;
          dashboardController.products = jsonData1['data']['item_lists'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            key: _scaffoldKey,
            appBar: buildAppBar(),
            body: RefreshIndicator(
              color: Colors.white,
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await glbalFunctionToSupportPageRefresh();
              },
              child: loadingForEntireScreen == false
                  ? SizedBox(
                      child:
                          newDesign(subCategory, dashboardController.products))
                  : SizedBox(
                      height: 250, child: Center(child: SpinKitCircle())),
            )),
      ),
    );
  }

  cartIcon() {
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
            'main_category_id': dashboardController.selectedCategoryId!,
            'categoryName': dashboardController.categoryName!,
          },
        );
      },
    );
  }

  newDesign(List subcategories, List products) {
    BoxDecoration decorationStyledefault = BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xffD9D9D9).withOpacity(0.45),
        width: 1,
      ),
      color: const Color(0xffffffff),
    );
    BoxDecoration decorationStyleSelected = BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(
        color: const Color(0xffd9d9d9).withOpacity(0.27),
        width: 1.5,
      ),
      color: const Color(0xffE2E2E2),
    );
    return enableCircularForWholePage == false
        ? subCategory.isNotEmpty
            ? Row(
                children: [
                  Expanded(
                    flex: 24,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3),
                      child: SizedBox(
                          child: subcategories.isNotEmpty
                              ? ListView.builder(
                                  itemCount: subcategories.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration:
                                              selectedSubcategoryIndex == index
                                                  ? decorationStyleSelected
                                                  : decorationStyledefault,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSubcategoryIndex =
                                                          index;
                                                      displayLoading = true;
                                                    });
                                                    fetchProductItemsOnclick(
                                                        "${dashboardController.selectedCategoryId}",
                                                        subcategories[index][
                                                                'sub_category_id']
                                                            .toString());
                                                  },
                                                  child: Column(
                                                    children: [
                                                      CachedNetworkImage(
                                                        fit: BoxFit.cover,
                                                        repeat: ImageRepeat
                                                            .noRepeat,
                                                        imageUrl: subcategories[
                                                                index][
                                                            'sub_category_image'],
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                          Icons.error,
                                                          color:
                                                              Color(0xffAF6CDA),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          subcategories[index][
                                                              'sub_category_name'],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                "Poppins",
                                                            letterSpacing: 0.6,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: selectedSubcategoryIndex ==
                                                                    index
                                                                ? Colors.black
                                                                : const Color(
                                                                    0xff868889),
                                                            fontSize: 11.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    );
                                  },
                                )
                              : const Center(child: Text("No data"))),
                    ),
                  ),
                  Expanded(
                    flex: 76,
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 50,
                        //   child: TextFormField(
                        //     controller: _searchController,
                        //     decoration: const InputDecoration(
                        //       hintText: 'Search by item name',
                        //     ),
                        //     onChanged: (text) {
                        //       setState(() {
                        //         products = tempData
                        //             .where((item) => item['item_name']
                        //                 .toLowerCase()
                        //                 .contains(text.toLowerCase()))
                        //             .toList();
                        //       });
                        //     },
                        //   ),
                        // ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 10, 6),
                            child: Container(
                              color: Colors.white,
                              child: displayLoading == false
                                  ? products.isNotEmpty
                                      ? productListBuilder(products)
                                      : SizedBox(
                                          height: Get.height,
                                          child: const Center(
                                              child: Text("No record found")))
                                  : const SizedBox(
                                      height: 20,
                                      child: SpinKitCircle(
                                        color: Color(0xffAF6CDA),
                                        size: 50,
                                      )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator())
        : const Column(
            children: [
              Center(
                child: SpinKitCircle(
                  color: Color(0xffAF6CDA),
                ),
              ),
            ],
          );
  }

  ListView productListBuilder(List<dynamic> products) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        var productId = product['item_id'];

        var productName = product['item_name'];
        var storeName = product['store_name'];
        var productImage = product['item_image'];
        var productCurrency = product['item_currency'];
        double travelDistance = product['travel_distance'];
        var itemHasChoice = product['item_has_choice'].toString();
        var choices = product['choices'] ?? [];
        var selectedChoiceId = selectedChoiceMap[productId];
        String distanceAsString = travelDistance.toStringAsFixed(2);
        var selectedChoiceStock = 0;
        var storeId = product['store_id'];

        var choiceItemInCart = false;
        var choiceMrpPrice;
        String choiceItemCountInCart = "";
        var choiceItemCartId;
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
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 6),
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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: productMoreDetails(context, product,
                              productImage, productId, storeId),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text(
                                productName,
                                softWrap: true,
                                maxLines: 2,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: "Poppins",
                                  color: Color(0xff868889),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "MRP $productCurrency$choiceMrpPrice",
                                style: SafeGoogleFont(
                                  "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff838383),
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  product['rating'] != null
                                      ? ratingSction(product['rating'])
                                      : Container(),
                                  distanceAsString != ''
                                      ? distanceSection(distanceAsString)
                                      : Container(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 8, 0),
                          child: product['item_is_favourite'] == "Favourite"
                              ? GestureDetector(
                                  onTap: () async {
                                    var jsonData = await dashboardController
                                        .setAndUnSetFavorite(
                                            productId.toString(),
                                            selectedChoiceId.toString());
                                    if (jsonData != null &&
                                            jsonData['code'] == 200 ||
                                        jsonData['message'] ==
                                            "Wish list added successfully!") {
                                      setState(() {
                                        products[index]['item_is_favourite'] =
                                            "Not Favourite";
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    size: 26,
                                    color: Colors.redAccent,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    var jsonData = await dashboardController
                                        .setAndUnSetFavorite(
                                            productId.toString(),
                                            selectedChoiceId.toString());
                                    if (jsonData != null &&
                                            jsonData['code'] == 200 ||
                                        jsonData['message'] ==
                                            "Wish list deleted successfully!") {
                                      setState(() {
                                        product['item_is_favourite'] =
                                            "Favourite";
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    grade: 10,
                                    Icons.favorite_border,
                                    size: 28,
                                    color: Colors.black,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.store,
                          size: 18,
                          color: Color(0xffAF6CDA),
                        ),
                        Expanded(
                          child: Text(
                            "$storeName",
                            softWrap: true,
                            maxLines: 2,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontFamily: "Poppins",
                              color: Color(0xff868889),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
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
                                      products),
                                ),
                              )
                            : customizedCounter(
                                selectedChoiceStock,
                                dashboardController,
                                context,
                                productId,
                                selectedChoiceId,
                                products,
                                choiceItemCartId,
                                selectedChoice,
                                choices),
                      ],
                    ),
                  ),
                  if (itemHasChoice == 'Yes') ...[
                    displayChoiceChip(
                        choices, selectedChoiceId, productId, choiceItemInCart),
                  ],
                ],
              ),
            ),
          ),
        );
      },
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
          "${distanceAsString.toString()} mi",
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

  Widget ratingSction(rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.star,
          size: 15,
          color: Colors.orange,
        ),
        Text(
          rating,
          style: SafeGoogleFont(
            "Poppins",
            color: const Color(0xff868889),
            fontWeight: FontWeight.w500,
            // letterSpacing: 0.5,
            fontSize: 11,
          ),
        ),
        const SizedBox(
          width: 10,
        )
      ],
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

  SizedBox productMoreDetails(
      BuildContext context, product, productImage, productId, storeId) {
    return SizedBox(
      height: 120,
      width: 100,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            '/productDetail',
            parameters: {
              'main_category_id': dashboardController.selectedCategoryId!,
              'categoryName': dashboardController.categoryName!,
              'sub_category_id': dashboardController.selectedSubCategoryId!,
              'productId': productId.toString(),
              'storeId': storeId.toString(),
            },
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductDetailPage(
          //       product: ProductD.fromJson(product),
          //     ),
          //   ),
          // );
        },
        child: CachedNetworkImage(
          fit: BoxFit.fitHeight,
          imageUrl: productImage,
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
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
          spacing: 5.0,
          runSpacing: 1.0,
          children: [
            for (var choice in choices)
              SizedBox(
                height: 30,
                child: ChoiceChip(
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                    child: Text(
                      '${choice['choice_name']}',
                      style: const TextStyle(
                          fontSize: 12, color: Color.fromARGB(255, 71, 71, 71)),
                    ),
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
                  selectedColor: const Color(0xffaf6cda).withOpacity(.33),
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
              Auth.setTotalAmount(
                  responseData['data']["total_cart_amount"].toString());
              Auth.setCurrencyCode(
                  responseData['data']["cart_currency"].toString());
              dashboardController.totalCartCount =
                  responseData['data']["total_cart_count"].toString();
              break;
            }
          }
        }
      }
    });
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
      messagesList.add([
        '$dialogTitle:',
        for (String errorMessage in errors) errorMessage,
      ]);
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

  void showNextDialog(int currentIndex) {
    if (currentIndex < messagesList.length) {
      showAlertDialog('Dialog ${currentIndex + 1}', messagesList[currentIndex],
          currentIndex + 1);
    } else {}
  }

  buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppbarImage(
                  height: getVerticalSize(
                    65,
                  ),
                  width: getHorizontalSize(
                    160,
                  ),
                  imagePath: ImageConstant.imgBunnylogorgbfc),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Color(0xffAF6CDA),
                      size: 30,
                    ),
                    onPressed: () {
                      Get.offAllNamed('/dashboard');
                    },
                  ),
                  appBarDropDown(),
                  cartIcon()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded appBarDropDown() {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 1, 12, 1),
          child: SizedBox(
            width: 170,
            child: DropdownButtonFormField<String>(
              elevation: 8,
              menuMaxHeight: 400,
              alignment: AlignmentDirectional.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                filled: true,
                fillColor: Color(0xffF4EBFF),
              ),
              itemHeight: 50.0,
              dropdownColor: Colors.white,
              value: dashboardController.selectedProductCategoryForDroDown,
              items: dashboardController.productChoicesForDropDown
                  .map<DropdownMenuItem<String>>((category) {
                return DropdownMenuItem<String>(
                  value: category['category_name'].toString(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      category['category_name'],
                      style: SafeGoogleFont("Poppins",
                          color: const Color(0xffAF6CDA), fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                var selectedCategory =
                    dashboardController.productChoicesForDropDown.firstWhere(
                  (category) =>
                      category['category_name'].toString() == newValue,
                );
                setState(() {
                  dashboardController.selectedProductCategory = newValue;
                  dashboardController.selectedProductCategoryID =
                      selectedCategory['category_id'];
                });
                String catId = selectedCategory['category_id'].toString();
                _getSubCategoriesList(catId.toString(), 'true');
                enableCircularForWholePage = true;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a Category';
                }
                return null;
              },
            ),
          )),
    );
  }
}
