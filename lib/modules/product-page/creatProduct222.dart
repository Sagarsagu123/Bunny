import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/modules/product-page/choice.dart';
import 'package:flutter_demo/modules/product-page/view-product.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/widgets/custom_text_form_field.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProductPage extends StatefulWidget {
  final Individualproductitem individualproductitem;

  final bool isEditProduct;

  final GlobalKey<FormState> choiceFormKey;

  const UpdateProductPage(
      {super.key,
      required this.individualproductitem,
      required this.isEditProduct,
      required String storeId,
      required this.choiceFormKey});
  @override
  State<UpdateProductPage> createState() => _ProductCreationPageState();
}

class _ProductCreationPageState extends State<UpdateProductPage> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // GlobalKey<FormState> choiceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  final LoginController landingPageController = Get.find<LoginController>();
  final TextEditingController _controller = TextEditingController();
  int value = 10;
  // late final List<Product> stockList;

  List<dynamic> subCategory = [];
  final List<File> _images = [];
  List choiceCards = [];

  int choiceCount = 0;
  final String _storeId = '';
  Map<String, dynamic>? selectedChoiceData;
  int quantity = 0;
  bool submitAttemptChoice = false;
  bool isDefaultChoice111Selected = false;
  bool displayImgErrorMsg = false;
  Future<void> _getImages() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final pickedFiles = await ImagePicker().pickMultiImage(
        imageQuality: 85,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      List<File> files = pickedFiles.map((file) => File(file.path)).toList();

      setState(() {
        _images.addAll(files);

        for (int i = 0; i < files.length; i++) {
          dashboardController.base64Images.add({
            'id': (i + 1).toString(),
            'base64value': base64Encode(files[i].readAsBytesSync()),
          });
        }
        displayImgErrorMsg = false;
      });
    } else {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );
      if (result != null) {
        List<Uint8List> files =
            result.files.map((file) => file.bytes!).toList();

        setState(() {
          for (int i = 0; i < files.length; i++) {
            dashboardController.base64Images.add({
              'id': (i + 1).toString(),
              'base64value': base64Encode(files[i]),
            });
          }
        });
      }
    }
  }

  // late Individualproductitem individualproductitem;
  @override
  void initState() {
    super.initState();
    _getCategoriesList();
    _getChoiceList();
    // edit mode
    print("hbjjdcjj");
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('itemSubCategoryName') ||
        parameters.containsKey('itemCategoryName') ||
        parameters.containsKey('itemName') ||
        parameters.containsKey('itemImg') ||
        parameters.containsKey('itemDescription') ||
        parameters.containsKey('itemSubCategoryId') ||
        parameters.containsKey('itemCategoryId') ||
        parameters.containsKey('isEditProduct')) {
      // print(parameters['itemCategoryName']);
      // print(parameters['itemSubCategoryName']);
      // print(parameters['itemName']);
      // print(parameters['itemImg']);
      // print(parameters['itemDescription']);
      // print(parameters['itemCategoryId']);
      // print(parameters['itemSubCategoryId']);

      if (parameters['isEditProduct'] == 'true') {
        // print("GTGT");
        // print(parameters['itemCategoryName']);
        // dashboardController.selectedProductCategory =
        //     parameters['itemCategoryName'].toString();
        // dashboardController.selectedSubProductCategory =
        //     parameters['itemSubCategoryName'].toString();
        dashboardController.productNameController.text = parameters['itemName'];
        dashboardController.productDescriptionController.text =
            parameters['itemDescription'];
        // await assignCatIOnEditMode(parameters['itemCategoryName'].toString());
        // var catName = parameters['itemCategoryName'].toString();
        // print(catName);
        // print(dashboardController.productCategories);
        // var selectedCategory = dashboardController.productCategories.firstWhere(
        //   (category) => category['category_name'].toString() == catName,
        // );
        // print(selectedCategory);
        // setState(() {
        //   dashboardController.selectedProductCategory = catName;
        //   dashboardController.selectedProductCategoryID =
        //       selectedCategory['category_id'];
        // });
        // productFormKey.currentState!.validate();
      }
    }

    _controller.text = value.toString();
    setState(() {
      dashboardController.currentStoreId = _storeId;
      // dashboardController.selectedProductCategory =
      //     widget.individualproductitem.itemCategoryId.toString();
    });
  }

  Future _getCategoriesList() async {
    var jsonData = await landingPageController.getMainCategoriesList();
    List<String> categoriesToExclude = [
      "Fruits & vegetables",
      "Ice creames",
      "fruit"
    ];

    List<dynamic> categoryDetails = jsonData['data']['category_Details'];

    dashboardController.productCategories =
        jsonData['data']['category_Details'];
    categoryDetails = dashboardController.productCategories
        .where((category) =>
            !categoriesToExclude.contains(category["category_name"]))
        .toList();
    setState(() {
      dashboardController.productCategories = categoryDetails;
    });
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('itemCategoryId')) {
      assignCatIOnEditMode(parameters['itemCategoryId'].toString());
      _getSubCategoriesList(parameters['itemSubCategoryId'].toString());
    }
  }

  assignCatIOnEditMode(catId) {
    var selectedCategory = dashboardController.productCategories.firstWhere(
      (category) => category['category_id'].toString() == catId.toString(),
    );
    setState(() {
      dashboardController.selectedProductCategory =
          selectedCategory['category_name'];
      dashboardController.selectedProductCategoryID =
          selectedCategory['category_id'];
    });
    productFormKey.currentState!.validate();
  }

  Future _getSubCategoriesList(String selectedCategoryId) async {
    var jsonData = await landingPageController
        .getSubCategoryProducts(selectedCategoryId.toString());

    if (jsonData != null) {
      setState(() {
        subCategory = jsonData['data']['sub_category_Details'];
      });
    }
  }

  Future _getChoiceList() async {
    var jsonData = await dashboardController.getChoiceList();

    List<dynamic> choiceDetails = jsonData['data']['choice_Details'];

    setState(() {
      dashboardController.choiceList = choiceDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decorationStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: const Color.fromARGB(255, 159, 112, 173),
        width: 1.5,
      ),
      color: const Color.fromARGB(255, 163, 207, 228),
    );
    _controller.text = quantity.toString();
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              Form(
                key: productFormKey,
                child: Padding(
                  padding: getPadding(left: 20, top: 26, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      productName(dashboardController),
                      description(dashboardController),
                      imageField(dashboardController, _images),
                      categories(dashboardController,
                          dashboardController.productCategories),
                      const SizedBox(
                        height: 20,
                      ),
                      buildProductChoices(context)
                    ],
                  ),
                ),
              ),
              createProductButton(dashboardController),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductChoices(BuildContext context) {
    return Column(
      children: [
        // Display initial choice card
        const ChoiceCard(choiceNumber: 1),
        const SizedBox(height: 16),
        // Display subsequent choice cards
        for (var choiceCard in choiceCards) choiceCard,
        const SizedBox(height: 16),
        // Display "Add Choice" button after the last card
        ElevatedButton(
          onPressed: () {
            setState(() {
              submitAttemptChoice = true;
            });

            // if (choiceFormKey.currentState!.validate()) {
            //   setState(() {
            //     choiceCount++;
            //     choiceCards.add(ChoiceCard(choiceNumber: choiceCount + 1));
            //   });
            // }
          },
          child: const Text('Add Choice'),
        ),
        // ElevatedButton(
        //   onPressed: () {
        //     setState(() {
        //       submitAttemptChoice = true;
        //     });
        //     if (choiceFormKey.currentState!.validate()) {
        //       String? selectedChoice1 = dashboardController.selectedChoice;

        //       Map<String, String> choiceMap = {
        //         // 'id': dashboardController.selectedChoiceID.toString(),
        //         // 'defaultChoice': isDefaultChoice111Selected.toString(),
        //         // 'choiceType': selectedChoice1!,
        //         // 'Stock': quantity.toString(),
        //         'Mrp': dashboardController.mrpPriceController.text,
        //         'sellingPrice': dashboardController.sellingPriceController.text,
        //       };

        //       dashboardController.mrpPriceController.clear();
        //       dashboardController.sellingPriceController.clear();
        //       quantity = 0;
        //       dashboardController.selectedChoice = null;

        //       productFormKey.currentState!.reset();
        //       setState(() {
        //         submitAttemptChoice = false;
        //         dashboardController.selectedChoices.add(choiceMap);
        //         isDefaultChoice111Selected = false;
        //         dashboardController.selectedChoiceID = null;
        //       });
        //     }
        //   },
        //   child: const Text('Add Choice'),
        // ),
      ],
    );
  }

  productName(DashboardController dashboardController) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text("Product Name".tr,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: theme.textTheme.titleSmall),
        ),
        CustomTextFormField(
          controller: dashboardController.productNameController,
          margin: getMargin(left: 20, top: 14, right: 20),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter product name';
            }
            return null;
          },
          onChanged: (value) {
            productFormKey.currentState!.validate();
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
          alignment: Alignment.center,
          defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          disabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        ),
      ],
    );
  }

  description(DashboardController controller) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text("Description",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: theme.textTheme.titleSmall),
        ),
        CustomTextFormField(
          controller: controller.productDescriptionController,
          margin: getMargin(left: 20, top: 14, right: 20),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter product description';
            }
            return null;
          },
          onChanged: (value) {
            productFormKey.currentState!.validate();
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
          alignment: Alignment.center,
          defaultBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          enabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          focusedBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
          disabledBorderDecoration: TextFormFieldStyleHelper.underLinePrimary,
        ),
      ],
    );
  }

  imageField(DashboardController controller, List<File> images) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text("Product Image".tr,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: theme.textTheme.titleSmall),
        ),
        displayImgErrorMsg == true
            ? const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "img not uploded",
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              )
            : displayUploadedImages(dashboardController),
        Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 25,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              onPressed: _getImages,
              child: const Text(
                'Upload Image',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            height: 5,
          ),
        ),
      ],
    );
  }

  displayUploadedImages(DashboardController dashboardController) {
    return dashboardController.base64Images.isNotEmpty
        ? SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dashboardController.base64Images.length,
              itemBuilder: (context, index) {
                final imageItem = dashboardController.base64Images[index];
                if (imageItem.containsKey('base64value')) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      base64Decode(imageItem['base64value']!),
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  // Handle the case where 'base64value' is not present in the map.
                  return Container();
                }
              },
            ),
          )
        : Container();
  }

  categories(DashboardController dashboardController, productCategories) {
    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text("Product Categories :",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: theme.textTheme.titleSmall),
            ),
            const SizedBox(
              width: 5,
            ),
            productCategories.length > 0
                ? SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: dashboardController.selectedProductCategory,
                      items: productCategories
                          .map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['category_name'].toString(),
                          child: SizedBox(
                              width: 150,
                              child: Text(category['category_name'])),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        print("##########");
                        print(newValue);
                        var selectedCategory =
                            dashboardController.productCategories.firstWhere(
                          (category) =>
                              category['category_name'].toString() == newValue,
                        );
                        setState(() {
                          dashboardController.selectedProductCategory =
                              newValue;
                          dashboardController.selectedProductCategoryID =
                              selectedCategory['category_id'];
                        });
                        productFormKey.currentState!.validate();
                        _getSubCategoriesList(
                            selectedCategory['category_id'].toString());
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Category';
                        }
                        return null;
                      },
                    ))
                : const Text("No dropdown found"),
          ],
        ),
        subCategory.isNotEmpty
            ? Row(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Sub Product Categories :",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: theme.textTheme.titleSmall),
                ),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: dashboardController.selectedSubProductCategory,
                      items:
                          subCategory.map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['sub_category_name'].toString(),
                          child: SizedBox(
                              width: 150,
                              child: Text(category['sub_category_name'])),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        var selectedCategory = subCategory.firstWhere(
                          (category) =>
                              category['sub_category_name'].toString() ==
                              newValue,
                        );
                        setState(() {
                          dashboardController.selectedSubProductCategory =
                              newValue;
                          dashboardController.selectedSubProductCategoryID =
                              selectedCategory['sub_category_id'];
                        });
                        productFormKey.currentState!.validate();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select sub  Category';
                        }
                        return null;
                      },
                    ))
              ])
            : Container(),
      ],
    );
  }

  createProductButton(DashboardController dashboardController) {
    bool disable = false;
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(disable == false
          ? const Color(0xFFAF6CDA)
          : const Color(0xFFAF6CDA).withOpacity(0.45)),
    );
    return GetBuilder<DashboardController>(builder: (controller) {
      return Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          child: ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: () {
                // if (widget.isEditProduct) {
                //   // Handle edit mode actions
                //   _handleEditMode();
                // } else {
                //   // Handle create mode actions
                _handleCreateMode();
                // }

                // if (productFormKey.currentState!.validate()) {
                //   dashboardController.createProduct(context);
                // }
              },
              child: const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ),
      );
    });
  }

  void _handleCreateMode() {
    // if (productFormKey.currentState!.validate()) {
    //   dashboardController.createProduct(context, '','');
    // } else {
    //   print("tttt");
    // }
    // Get.toNamed('/dashboard');
  }

  // void _handleEditMode() {
  //   // Implement the logic to update the existing product
  //   // For example, call a method in your controller to update the product
  //   if (productFormKey.currentState!.validate()) {
  //     dashboardController.updateProduct1(
  //         context, widget.individualproductitem as Map<String, dynamic>?);
  //   }
  // }

  leadingButtonpopUpMenu(DashboardController dashboardController) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      offset: const Offset(0, 40),
      iconSize: 20,
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: GestureDetector(
                onTap: () async {
                  Get.toNamed('/dashboard');
                },
                child: const Text("Go to dashboard")),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.toNamed('/splashScreen');
                },
                child: const Text("Logout")),
          ),
        ];
      },
    );
  }
}
