// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_demo/auth.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/modules/checkout/checkout.dart';
import 'package:flutter_demo/services/api_services.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// import '../product-page/createProduct.dart';

class DashboardController extends GetxController {
  TextEditingController storeNameController = TextEditingController();
  TextEditingController taxIdController = TextEditingController();
  TextEditingController storeWebSiteController = TextEditingController();
  TextEditingController cottageFoodLawController = TextEditingController();
  TextEditingController activePermitToSellController = TextEditingController();
  TextEditingController storeAddressController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  TextEditingController storeDeliveryController = TextEditingController();
  bool isStoreCreated = true;
  bool customerStore = false;
  bool storeFieldsHasValue = false;
  String currentStoreId = '';
  String currentStoreName = '';
  String currentStoreAddress = '';
  String currentStoreGroupId = '';
  String currentUserName = '';
  String currentUserImage = '';
  String currentUserEmail = '';
  String customerStoreId = ''; // Global storeId for each customer
  List<Map<String, dynamic>> base64Images = [];
  List<Map<String, String>> selectedChoices = [];
  List<Map<String, dynamic>> savedChoices = [];

  String? selectedProductCategory;
  int? selectedProductCategoryID;

  String? selectedSubProductCategory;
  int? selectedSubProductCategoryID;

  // Farm , Business , Personal
  List<dynamic> categogyTypes = [];
  String selectedcategoryTypes = "All";
  int? selectedcategoryTypesID = 0;

  List<dynamic> categogyTypesForCreateStore = [];
  String? selectedcategoryTypesForCreateStore;
  String? initialValue;
  int? selectedcategoryTypesIDForcreateStore = 0;

  String selectedChoice1 = '';
  List<String> selectedChoice = ['5 kg'];
  GoogleMapController? mapController;
  int? selectedChoiceID;
  List<dynamic> productCategories = [];
  List<dynamic> productSubCategories = [];
  List<dynamic> subCategory = [];
  List<String?> selectedChoiceNames = [];
  List<dynamic> cartDeliveryDetailsList1 = [];
  bool loadingPage = false;

  late String selectedCottageFoodLawOption;
  late String selectedActivePermitToSellOption;

  final FocusNode focusNodeStoreName = FocusNode();
  final FocusNode focusNodeTaxId = FocusNode();
  final FocusNode focusNodeStoreWebsite = FocusNode();
  final FocusNode focusNodeStoreAddress = FocusNode();
  final FocusNode focusNodeDeliveryRadius = FocusNode();

  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  TextEditingController mrpPriceController = TextEditingController();
  TextEditingController sellingPriceController = TextEditingController();
  List<dynamic> dataList = [].obs;
  String? categoryName;
  String? selectedCategoryId;
  String? selectedSubCategoryId;
  String? selectedChoiceId;
  String? currentProductId;
  String? storeId;
  String? pageNumber;
  String? storeIdGlobal;
  int currentQuantityCountValue = 1;
  String totalCartCount = '-1';
  String? totalCartAmount;
  List products = [];
  List singleProduct = [];
  List storeData = [];

  List restuerentInfo = [];

  String choiceItemCountInCart = '1';
  List<dynamic> choiceList = [];
  List itemsInCart = [];
  List<dynamic> productChoicesForDropDown = [];
  String? selectedProductCategoryForDroDown;
  int? selectedProductCategoryIdForDroDown;
  bool routeFromDashboard = false;
  bool fromDashBoard = false;

  bool? serviceEnabled;
  List<File> licenseDocs = [];
  String? licenseDocs1;
  List<File> proofDocs = [];
  String? proofDocs1;
  List<File> certificateDocs = [];
  String? certificateDocs1;
  // produt=ct images
  List<File> productImagesList = [];
  String? productImageUrl;

  ///  ####3
  RxList<Map<String, dynamic>> croppedImages = <Map<String, dynamic>>[].obs;

  String? shId;

  String? ordSelfPickup;

  List<int> selectedLabels = [];
  List<dynamic> productLabels = [];
  void addCroppedImage(File croppedImage) {
    int id = croppedImages.length + 1;

    // Add the cropped image with an associated ID to the list
    croppedImages.add({'id': id, 'croppedImage': croppedImage});
  }

  ///// @@@@@@@@
  List<dynamic> tempData = [];
  List<List<String>> messagesList = [];
  var cartData;
  var checkDetails;
  var paymentDetails;
  var walletDetails;
  String? totalAmountForPayment;
  bool updateDashboardPage = false;

  List<Map<String, dynamic>> satisfiedChoices = [];
  List<Map<String, dynamic>> unsatisfiedChoices = [];

  String? selectedCategoryDoc1;
  String? selectedCategoryDoc2;
  String? selectedCategoryDoc3;

  bool buyerHasNewMessage = false;
  bool sellerHasNewMessage = false;
  @override
  void onInit() {
    super.onInit();
    fetchData();
    getMainCategoriesListNewRender();
    print("Entering onin it method");
  }

  Future fetchData() async {
    var response = await getAllCustomersStore();
    if (response != null && response['data'] != null) {
      dataList = response['data']['List_of_Stores'];
      update();
      return true;
    } else {
      Get.snackbar("Error", "Error fetching store data");
    }
  }

  Future getMainCategoriesListNewRender() async {
    satisfiedChoices = [];
    unsatisfiedChoices = [];
    var jsonData = await ApiService.getProductsCategoriesList();
    return jsonData;
  }

  Future<void> onSendIds(
      List categories, BuildContext context, bool isSkipped) async {
    List<int> selectedIds = [];
    int count = 0;
    if (isSkipped == true) {
      for (int i = 0; i < categories.length; i++) {
        selectedIds.add(categories[i]['category_id']);
        count++;
        if (count >= 3) {
          break;
        }
      }
    } else {
      for (var category in categories) {
        if (category["isSelected"]) {
          selectedIds.add(category["category_id"]);
        }
      }
    }
    bool msg = await ApiService.updateProductSelectedByCustomer(selectedIds);

    if (msg == true) {
      Get.snackbar('Success', "Interestedd categories updated successfully",
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));

      // await getMainCategoriesListNewRender();
      Get.toNamed('/dashboard');
      update();
    } else {
      Get.snackbar('Error', "Error updating categories ",
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
    }
  }

  Future<void> createStore(
    BuildContext context,
    double latitude,
    double longitude,
    int storeCategoryId,
  ) async {
    final storeInfo = StoreInfo(
      storeId: '',
      storeName: storeNameController.text.trim(),
      taxId: taxIdController.text.trim(),
      storeWebsite: storeWebSiteController.text.trim(),
      cottageFoodLaw: selectedCottageFoodLawOption.trim(),
      activePermit: selectedActivePermitToSellOption.trim(),
      storeAddress: storeAddressController.text.trim(),
      storeCategoryId: storeCategoryId,
      deliverRadius: storeDeliveryController.text.trim(),
      storeLicense: licenseDocs,
      storeLicenseDocName: selectedCategoryDoc1 ?? "",
      storeProofDocName: selectedCategoryDoc2 ?? "",
      storeCertificateDocName: selectedCategoryDoc3 ?? "",
      storeProof: proofDocs,
      storeCertificate: certificateDocs,
      storeLatitude: latitude,
      storeLongitude: longitude,
    );
    var jsonData = await ApiService.createStore(storeInfo);
    if (jsonData == "true") {
      clearController();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          ButtonStyle elevatedButtonStyle1 = ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 168, 107, 204)));
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            content: SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 160,
                      child: Image.asset(
                        ImageConstant.storeCreated,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Store Created successfully",
                        style: SafeGoogleFont("Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: elevatedButtonStyle1,
                onPressed: () async {
                  bool val = await fetchData();

                  Get.back();
                },
                child: Text(
                  "Ok",
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );

      update();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error creating store"),
      ));
    }
  }

  Future<void> updateStore(BuildContext context, String storeId,
      double latitude, double longitude, int storeCategoryId) async {
    final storeInfo = StoreInfo(
      storeId: storeId,
      storeName: storeNameController.text.trim(),
      taxId: taxIdController.text.trim(),
      storeWebsite: storeWebSiteController.text.trim(),
      cottageFoodLaw: selectedCottageFoodLawOption.trim(),
      activePermit: selectedActivePermitToSellOption.trim(),
      storeAddress: storeAddressController.text.trim(),
      storeCategoryId: storeCategoryId,
      deliverRadius: storeDeliveryController.text.trim(),
      storeLicenseDocName: selectedCategoryDoc1!,
      storeProofDocName: selectedCategoryDoc2!,
      storeCertificateDocName: selectedCategoryDoc3!,
      storeLicense: licenseDocs,
      storeProof: proofDocs,
      storeCertificate: certificateDocs,
      storeLatitude: latitude,
      storeLongitude: longitude,
    );
    var jsonData = await ApiService.updateStore(storeInfo);
    if (jsonData == "true") {
      clearController();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          ButtonStyle elevatedButtonStyle1 = ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 168, 107, 204)));
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            content: SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 160,
                      child: Image.asset(
                        ImageConstant.storeCreated,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Store Updated successfully",
                        style: SafeGoogleFont("Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: elevatedButtonStyle1,
                onPressed: () async {
                  bool val = await fetchData();
                  if (val == true) {
                    Get.toNamed(
                      '/storeDashboardIndividual',
                      parameters: {
                        'storeId': storeId,
                        'name': storeInfo.storeName,
                        'address': storeInfo.storeAddress,
                        'stGroup': storeInfo.storeCategoryId.toString(),
                      },
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  "Ok",
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );

      update();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error updating store"),
      ));
    }
    update();
  }

  Future<bool> disableStore(BuildContext context, String storeId) async {
    var jsonData = await ApiService.disableStore(storeId);

    var displayMessage = '';
    if (jsonData['data'] != null && jsonData['code'] == 200) {
      displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));

      bool val = await fetchData();
      if (val == true) {
        Get.toNamed('/storeDashboardAll');
      }
      return true;
    } else {
      displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
      update();
      return false;
    }
  }

  Future<void> clearControllerFromDashBoardAndNavigateTostore(
      BuildContext context, bool val) async {
    storeNameController.clear();
    storeAddressController.clear();
    if (val == false) {
      Get.toNamed('/storeRegistrationPage');
    } else {
      bool val = await fetchData();
      if (val == true) {
        // Navigator.pop(context);
        // Get.offAndToNamed('/storeDashboardAll');
        // changed to pass individul page as per new feature
        Get.offAndToNamed('/storeDashboardIndividual');
      } else {
        return;
      }
    }
    update();
  }

  void clearController() {
    storeNameController.clear();
    storeAddressController.clear();
    storeDeliveryController.clear();
    selectedCategoryDoc1 = "";
    selectedCategoryDoc2 = "";
    selectedCategoryDoc2 = "";
    // licenseDocs.clear();
    // proofDocs.clear();
    // while (certificateDocs.isNotEmpty) {
    //   certificateDocs.removeAt(0);
    // }
    update();
  }

  getAllCustomersStore() async {
    var jsonData = await ApiService.getAllCustomersStoreList();
    return jsonData;
  }

  getChoiceList() async {
    var jsonData = await ApiService.getChoiceList();
    return jsonData;
  }

  Future<void> createProduct(
      BuildContext context, String storeId, String? productId) async {
    final productInfo = ProductInfo(
        storeId: storeId,
        productId: productId,
        productLabelIds: selectedLabels,
        productName: productNameController.text.trim(),
        productDescription: productDescriptionController.text.trim(),
        productImagesList1: productImagesList,
        productCategoryId: '${selectedProductCategoryID!}',
        selectedChoices: savedChoices,
        selectedSubProductCategoryID: '${selectedSubProductCategoryID!}');

    var jsonData = await ApiService.createProduct(productInfo);
    if (jsonData == 'true') {
      clearProductController();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          ButtonStyle elevatedButtonStyle1 = ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      15.0), // Adjust the radius as needed
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 168, 107, 204)));
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
            content: SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        productId == ""
                            ? "Product Created successfully"
                            : "Product Updated successfully",
                        style: SafeGoogleFont("Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: elevatedButtonStyle1,
                onPressed: () async {
                  // Get.toNamed(
                  //   '/storeDashboardIndividual',
                  //   parameters: {
                  //     'storeId': currentStoreId.toString(),
                  //     'name': currentStoreName.toString(),
                  //     'address': currentStoreAddress.toString(),
                  //   },
                  // );
                  Get.back();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: SafeGoogleFont("Poppins",
                      fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
      Get.back();
      update();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error updating product"),
      ));
    }
    update();
  }

  void clearProductController() {
    productNameController.clear();
    productDescriptionController.clear();
    // selectedProductCategoryID = '' as int?;
    update();
  }

  Future fetchProductItems(
      String? mainId, String? subId, String? text, String? storeId) async {
    final items = Items(
        mainCategoryId: mainId.toString(),
        subCategoryId: subId.toString(),
        searchText: text.toString(),
        storeId: storeId.toString());
    var jsonData = await ApiService.fetchProductItems(items);
    return jsonData;
  }

  getSubCategoryProducts(String id, String mainApi) async {
    var jsonData = await ApiService.getSubCategoryList(id.toString(), mainApi);
    return jsonData;
  }

  getAllProductsItems(
      String pageNo, String storeId, String? searchValue) async {
    var jsonData =
        await ApiService.getAllProductsItems(pageNo, storeId, searchValue!);
    return jsonData;
  }

  currentQuantityCount(int value) {
    return currentQuantityCountValue = value;
  }

  Future addToCartController(BuildContext context, String productId,
      String selectedChoiceId, String quantity) async {
    var jsonData =
        await ApiService.addToCart(productId, selectedChoiceId, quantity);
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Success', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1500));
    } else {
      Get.snackbar('Success', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));

      return jsonData;
    }
  }

  Future removeItemFromCart(String cartId) async {
    var jsonData = await ApiService.removeItemFromCart(cartId);
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('failure', "Error removing item",
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
    } else {
      Get.snackbar('Success', "Item removed succesfully",
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
      return jsonData;
    }
  }

  Future myCart() async {
    var jsonData = await ApiService.myCart();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future removeAllItemsFromCart() async {
    var jsonData = await ApiService.removeAllItemsFromCart();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future cartDeliveryDetail() async {
    var jsonData = await ApiService.cartDeliveryDetails();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getDeliveryAddress() async {
    var jsonData = await ApiService.customerShipAddress();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future updateCheckoutInfor(
      CheckOutInfo checkoutInfo, String selectedType) async {
    var jsonData =
        await ApiService.updateCheckoutInfor(checkoutInfo, selectedType);
    if (jsonData != null && jsonData['code'] == 400) {
      return jsonData;
    } else {
      return jsonData;
    }
  }

  Future getCustomerProfileDetail() async {
    var jsonData = await ApiService.getCustomerProfileDetail();
    return jsonData;
  }

  Future fetchPaymentDetails() async {
    var jsonData = await ApiService.fetchPaymentDetails();
    return jsonData;
  }

  Future useWallet() async {
    var jsonData = await ApiService.useWallet();
    return jsonData;
  }

  Future checkoutAPI(String apiType, String ordSelfPickup, String useWallet,
      String walletAmt, String shShipId) async {
    var jsonData = await ApiService.checkoutAPI(
        apiType, ordSelfPickup, useWallet, walletAmt, shShipId);
    return jsonData;
  }

  Future fetchCustomerDetails() async {
    var jsonData = await ApiService.fetchCustomerDetails();
    return jsonData;
  }

  Future updateCustomerDetails() async {
    var jsonData = await ApiService.updateCustomerDetails();
    return jsonData;
  }

  Future<void> logOut(context) async {
    loadingPage = true;
    _showLogoutDialog1(context);
    var jsonData = await ApiService.logOut();

    if (jsonData != null && jsonData['code'] == 400) {
      var displayMessage = jsonData['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(displayMessage),
      ));
    } else {
      await Future.delayed(const Duration(seconds: 3), () {
        loadingPage == false;
      });

      await clearCacheOnLogout();
      update();
    }
  }

  void _showLogoutDialog1(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            content: Container(
          width: MediaQuery.of(context).size.width,
          height: 100.0, // Specify the height as needed
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              loadingPage
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(width: 20),
                        Text("Logging out..."),
                      ],
                    )
                  : const Text("You have been logged out successfully."),
            ],
          ),
        ));
      },
    );
  }

  clearCacheOnLogout() async {
    // Clear user data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or remove specific keys using prefs.remove('key')

    // Clear image cache
    // DefaultCacheManager().emptyCache();

    Get.toNamed('/splashScreen');
  }

  changePwd(old, new1, context) async {
    var jsonData = await ApiService.changePwd(old, new1);

    return jsonData;
  }

  Future getMerchantAuthCode(String storeId) async {
    var jsonData = await ApiService.getMerchantAuthCode(storeId);

    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
      return false;
    } else {
      var getMerchantAuth = await Auth.getMerchantAuthCode();
      print(getMerchantAuth);
      if (getMerchantAuth == null) {
        var merchantAuth = jsonData['data']['token'];
        Auth.setMerchantAuthCode(merchantAuth);
      }
      return true;
    }
  }

  Future merchantAuthCode() async {
    var jsonData = await ApiService.merchantAuthCode();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      return jsonData;
    }
  }

  getCategoriesListForStore() async {
    var jsonData = await ApiService.getCategoriesListForStore();

    if (jsonData != null && jsonData['data'] != null) {
      categogyTypesForCreateStore = jsonData['data']['category_Details'];
    }
    return jsonData;
  }

  fetchCustomerProfie() async {
    var jsonData = await ApiService.fetchCustomerProfie();
    return jsonData;
  }

  updateCustomerProfile(fname, lname, email, pnumber, gender, dob,
      File? selectedImageFile, context) async {
    var jsonData = await ApiService.updateCustomerProfile(
        fname, lname, email, pnumber, gender, dob, selectedImageFile, context);
    return jsonData;
  }

  getstoreproducts(String storeId) async {
    var jsonData = await ApiService.getstoreproducts(storeId);

    return jsonData;
  }

  Future fetchBankDetails() async {
    var jsonData = await ApiService.fetchBankDetails();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future updateBankDetailsAPI(List bankDetails) async {
    var jsonData = await ApiService.updateBankDetailsAPI(bankDetails);
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future createPaymentIntentBunny(String amount, String currency) async {
    var jsonData = await ApiService.createPaymentIntentBunny(amount, currency);
    if (jsonData != null && jsonData['code'] == 400) {
      return jsonData;
    } else {
      return jsonData;
    }
  }

  Future stripePaymentStatus() async {
    var jsonData = await ApiService.stripePaymentStatus();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getProductDetails(String productId) async {
    var jsonData = await ApiService.getProductDetails(productId);
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getProductLabels() async {
    var jsonData = await ApiService.getProductLabels();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future setAndUnSetFavorite(String productId, String selectedChoiceId) async {
    var jsonData =
        await ApiService.setAndUnSetFavorite(productId, selectedChoiceId);
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future fetchFavouriteProducts() async {
    var jsonData = await ApiService.fetchFavouriteProducts();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getAllCustomerMessages() async {
    var jsonData = await ApiService.getAllCustomerMessages();
    if (jsonData != null && jsonData['code'] == 400) {
      return jsonData;
    } else {
      return jsonData;
    }
  }

  Future getIndividualChatMessges(String chatId) async {
    var jsonData = await ApiService.getIndividualChatMessges(chatId.toString());
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future sendMsgFromCusToSeller(String storeId, String message) async {
    var jsonData =
        await ApiService.sendMsgFromCusToSeller(storeId.toString(), message);
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getAllSellerMessages() async {
    var jsonData = await ApiService.getAllSellerMessages();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  Future getIndividualCustomerChat(String chatId) async {
    var jsonData =
        await ApiService.getIndividualCustomerChat(chatId.toString());
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  /// MERCHANT
  Future sendMsgToCustomer(String cusId, String cusName, String message) async {
    var jsonData = await ApiService.sendMsgToCustomer(
        cusId.toString(), cusName.toString(), message);
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  // Set flag to zeero after the customer has opened chat
  Future updateChatFlagFromCustomer(String chatId) async {
    var jsonData =
        await ApiService.updateChatFlagFromCustomer(chatId.toString());
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }

  // Set flag to zeero after the customer has opened chat
  Future updateChatFlagFromSeller(String chatId) async {
    var jsonData = await ApiService.updateChatFlagFromSeller(chatId.toString());
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      return jsonData;
    }
  }
}

class StoreInfo {
  final String storeId;
  final String storeName;
  final String taxId;
  final String storeWebsite;
  final String cottageFoodLaw;
  final String activePermit;
  final String storeAddress;
  final String deliverRadius;
  final List<File?> storeLicense;
  final String storeLicenseDocName;
  final List<File?> storeProof;
  final String storeProofDocName;
  final List<File?> storeCertificate;
  final String storeCertificateDocName;
  final int storeCategoryId;
  final double storeLatitude;
  final double storeLongitude;
  StoreInfo({
    required this.storeId,
    required this.storeName,
    required this.taxId,
    required this.storeWebsite,
    required this.cottageFoodLaw,
    required this.activePermit,
    required this.storeAddress,
    required this.deliverRadius,
    required this.storeLicense,
    required this.storeLicenseDocName,
    required this.storeProof,
    required this.storeProofDocName,
    required this.storeCertificate,
    required this.storeCertificateDocName,
    required this.storeCategoryId,
    required this.storeLatitude,
    required this.storeLongitude,
  });
}

class ProductInfo {
  final String storeId;
  final String? productId;
  final String productName;
  final List<int> productLabelIds;
  final String productDescription;
  final String productCategoryId;
  final List<File?> productImagesList1;
  final List<Map<dynamic, dynamic>> selectedChoices;

  final String selectedSubProductCategoryID;

  ProductInfo(
      {required this.storeId,
      required this.productName,
      required this.productDescription,
      required this.productLabelIds,
      required this.productImagesList1,
      required this.productCategoryId,
      required this.selectedChoices,
      required this.selectedSubProductCategoryID,
      required this.productId});
}

class Items {
  final String? mainCategoryId;
  final String? subCategoryId;
  final String? storeId;

  final String? searchText;
  Items(
      {required this.mainCategoryId,
      required this.subCategoryId,
      required this.searchText,
      required this.storeId});
}
