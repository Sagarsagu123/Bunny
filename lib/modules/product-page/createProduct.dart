// Copyright 2013, the Dart project authors. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:

//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
// A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
// LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
// THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
// import 'dart:html' as html; // Import the html library for web file picking

class ProductCreationPage extends StatefulWidget {
  const ProductCreationPage({super.key});

  @override
  State<ProductCreationPage> createState() => _ProductCreationPageState();
}

class _ProductCreationPageState extends State<ProductCreationPage> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> choiceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> productFormKey = GlobalKey<FormState>();

  final LoginController landingPageController = Get.find<LoginController>();
  final TextEditingController _controller = TextEditingController();
  int value = 10;
  List<dynamic> productChoices = [];
  final List<File> _images = [];
  String _storeId = '';
  Map<String, dynamic>? selectedChoiceData;
  bool submitAttemptChoice = false;
  bool isDefaultChoice111Selected = true;
  List<dynamic> choiceListForAddingChoice = [];
  List<GlobalKey<FormState>> choiceFormKeys = [GlobalKey<FormState>()];
  Choice? _selectedChoice;
  List<Choice> choiceTypes = [];
  int _currentChoiceFormIndex = 0;
  List<TextEditingController> mrpPriceControllers = [];
  List<TextEditingController> sellingPriceControllers = [];
  List<TextEditingController> stockControllers = [
    TextEditingController(text: "1")
  ];
  bool isLaodingForEditScreen = true;
  final MultiSelectController _controller1 = MultiSelectController();
  bool errormsg = false;
  List<dynamic> productInfo = [];
  List<dynamic> choices = [];
  bool isEdit = false;
  String productId = '';
  final MultiSelectController<dynamic> _multiSelectController =
      MultiSelectController();
  List<bool> isDefaultList = [false];
  @override
  void initState() {
    super.initState();
    clearCont();
    _getCategoriesList();
    _getChoiceList();
    getProductLabels();
    dashboardController.savedChoices = [];
    _initializeControllers();
    _initializeSwitches();
    dashboardController.productImagesList.clear();
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('itemSubCategoryName') ||
        parameters.containsKey('itemCategoryName') ||
        parameters.containsKey('itemName') ||
        parameters.containsKey('itemImg') ||
        parameters.containsKey('storeId') ||
        parameters.containsKey('itemDescription') ||
        parameters.containsKey('itemSubCategoryId') ||
        parameters.containsKey('itemCategoryId') ||
        parameters.containsKey('isEditProduct')) {
      if (parameters['isEditProduct'] == 'true') {
        setState(() {
          _storeId = parameters['storeId'].toString();
          isEdit = true;
          productId = parameters['itemId'].toString();
        });
        getProductDetails(productId.toString());
      }
    } else {
      isEdit = false;
    }
  }

  void _initializeSwitches() {
    setState(() {
      isDefaultList = List.generate(choiceFormKeys.length, (index) => false);
    });
  }

  clearCont() {
    dashboardController.storeNameController.clear();
    dashboardController.storeAddressController.clear();
    dashboardController.storeDeliveryController.clear();
  }

  void _initializeControllers() {
    mrpPriceControllers.add(TextEditingController());
    sellingPriceControllers.add(TextEditingController());
    stockControllers.add(TextEditingController());
  }

  // calling only in edit mode
  Future getProductDetails(String productId) async {
    var jsonData1 = await dashboardController.getProductDetails(productId);
    if (jsonData1['code'] == 400 || jsonData1['code'] == 500) {
      Get.snackbar('Failure', jsonData1['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1000));
    } else if (jsonData1['code'] == 200 && jsonData1['data'] != null) {
      setState(() {
        productInfo = jsonData1['data']['itemt_info'];
        if (productInfo.isNotEmpty) {
          if (productInfo.isNotEmpty && productInfo[0]['item_name'] != null) {
            dashboardController.productImageUrl =
                productInfo[0]['item_image'][0];
          }
        }
        // choices = jsonData1['data']['choices'];
        // if (choices.isNotEmpty) {
        //   dashboardController.savedChoices =
        //       choices.cast<Map<String, dynamic>>();
        // }
      });
    } else {
      dashboardController.productImagesList = [];
    }
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
    // TODO
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('itemCategoryId')) {
      await assignCatIOnEditMode(parameters['itemCategoryId'].toString());
      await _getSubCategoriesList(parameters['itemCategoryId'].toString());
    } else {
      setState(() {
        dashboardController.currentStoreId = _storeId;
        isLaodingForEditScreen = false;
      });
    }
  }

  Future getProductLabels() async {
    var jsonData = await dashboardController.getProductLabels();

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        dashboardController.productLabels = jsonData['data']['labels'];
      });
    }
  }

  assignCatIOnEditMode(catId) {
    print(catId);
    var selectedCategory = dashboardController.productCategories.firstWhere(
      (category) => category['category_id'].toString() == catId.toString(),
    );
    print(selectedCategory['category_name']);
    print(selectedCategory['category_id']);
    setState(() {
      dashboardController.selectedProductCategory =
          selectedCategory['category_name'];
      dashboardController.selectedProductCategoryID =
          selectedCategory['category_id'];
    });
    print(selectedCategory['category_id']);
  }

  Future _getSubCategoriesList(String selectedCategoryId) async {
    var jsonData =
        await landingPageController.getSubCategoryProducts(selectedCategoryId);

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        dashboardController.subCategory =
            jsonData['data']['sub_category_Details'];
      });
      final Map<String, dynamic> parameters = Get.parameters;
      if (parameters.containsKey('itemSubCategoryId')) {
        assignSUBCatIOnEditMode(parameters['itemSubCategoryId'].toString());
      }
    }
  }

  assignSUBCatIOnEditMode(subCatId) {
    var selectedCategory = dashboardController.subCategory.firstWhere(
      (subCategory) =>
          subCategory['sub_category_id'].toString() == subCatId.toString(),
    );
    setState(() {
      dashboardController.selectedSubProductCategory =
          selectedCategory['sub_category_name'];
      dashboardController.selectedSubProductCategoryID =
          selectedCategory['sub_category_id'];
      isLaodingForEditScreen = false;
    });
  }

  Future _getChoiceList() async {
    var jsonData = await dashboardController.getChoiceList();

    List<dynamic> choiceDetails = jsonData['data']['choice_Details'];
    setState(() {
      choiceTypes = choiceDetails
          .map((choice) =>
              Choice(chId: choice["ch_id"], chName: choice["ch_name"]))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decorationStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: const Color.fromARGB(255, 158, 153, 160),
        width: 1,
      ),
      color: Colors.transparent,
    );
    TextStyle style = const TextStyle(
        fontFamily: "Poppins",
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xff838383));
    if (productInfo.isNotEmpty) {
      dashboardController.productNameController.text =
          productInfo[0]['item_name'];
      dashboardController.productDescriptionController.text =
          productInfo[0]['item_desc'];
      if (productInfo[0]['item_labels'] != null &&
          productInfo[0]['item_labels'].isNotEmpty) {
        dashboardController.selectedLabels = productInfo[0]['item_labels']
            .map<int>((desc) => int.parse(desc) ?? 0)
            .toList();
      }
    }
    // print(dashboardController.selectedLabels);
    // print(dashboardController.productLabels);
    // _controller.selectedValues.addAll(dashboardController.selectedLabgels
    //     .map<String>((id) => id.toString())
    //     .toList());
    print(dashboardController.savedChoices);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar(dashboardController),
          body: SingleChildScrollView(
            child: SizedBox(
              child: isLaodingForEditScreen == false
                  ? Column(
                      children: [
                        Form(
                          key: productFormKey,
                          child: Padding(
                            padding: getPadding(left: 20, top: 26, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                productName(dashboardController, style),
                                description(dashboardController, style),
                                productLabelss(dashboardController, style),
                                imageField(dashboardController, _images, style),
                                const Divider(),
                                categories(
                                    dashboardController,
                                    dashboardController.productCategories,
                                    style),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Choice".tr,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: style),
                          ),
                        ),
                        _buildChoiceForms(decorationStyle),
                        errormsg == true
                            ? const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  " Choices not selected",
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: SizedBox(
                              height: 28,
                              child: ElevatedButton(
                                onPressed: () {
                                  addChoice(
                                      choiceFormKeys[_currentChoiceFormIndex]);
                                  errormsg = false;
                                },
                                child: const Text(
                                  'Add Choice',
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        createProductButton(dashboardController, productId),
                        const SizedBox(
                          height: 20,
                        ),
                        // if (dashboardController.savedChoices.isNotEmpty)
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       const Text(
                        //         'Saved Choices:',
                        //         style: TextStyle(
                        //             fontSize: 18, fontWeight: FontWeight.bold),
                        //       ),
                        //       for (int i = 0;
                        //           i < dashboardController.savedChoices.length;
                        //           i++)
                        //         Text(
                        //           'Choice $i: ${dashboardController.savedChoices[i]}',
                        //           style: const TextStyle(fontSize: 16),
                        //         ),
                        //     ],
                        //   ),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SpinKitCircle(
                            color: Color(0xffAF6CDA),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  appBar(DashboardController dashboardController) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight + 25),
      child: Container(
        color: Colors.white,
        padding: getPadding(top: 12, bottom: 8, left: 20, right: 20),
        child: CustomAppBar(
          height: getVerticalSize(
            65,
          ),
          leadingWidth: 32,
          leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: Align(
            alignment: Alignment.center,
            child: AppbarImage(
                height: getVerticalSize(
                  65,
                ),
                width: getHorizontalSize(
                  160,
                ),
                imagePath: ImageConstant.imgBunnylogorgbfc),
          ),
        ),
      ),
    );
  }

  productName(DashboardController controller, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Name",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: style),
        TextFormField(
          controller: controller.productNameController,
          decoration: InputDecoration(
            hintText: 'Enter Product name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
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
        ),
      ],
    );
  }

  productLabelss(DashboardController dashboardController, TextStyle style) {
    if (dashboardController.productLabels.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Labels",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: style,
          ),
          SizedBox(
            child: MultiSelectDropDown(
              hint: "Select labels",
              controller: _multiSelectController,
              onOptionSelected: (List<ValueItem> selectedOptions) {
                print(selectedOptions);
                List<int> selectedIds = selectedOptions
                    .map<int>((option) => int.parse(option.value))
                    .toList();

                print(selectedIds);
                setState(() {
                  dashboardController.selectedLabels = selectedIds;
                });
                print(selectedOptions.toString());
              },
              options: dashboardController.productLabels.map((label) {
                return ValueItem(
                    label: label['label'], value: label['id'].toString());
              }).toList(),
              maxItems: dashboardController.productLabels.length,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(
                  backgroundColor: Color(0xffAF6CDA),
                  wrapType: WrapType.wrap,
                  autoScroll: true,
                  labelStyle: TextStyle(fontSize: 12, color: Colors.white)),
              dropdownHeight: 300,
              optionTextStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      );
    }
  }

  description(DashboardController controller, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: style),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter Description',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: controller.productDescriptionController,
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
        ),
      ],
    );
  }

  imageField(DashboardController controller, List<File> images, style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Image",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: style),
            SizedBox(
              width: Get.width - 60,
              child: GestureDetector(
                onTap: () {
                  _pickFile("item_image", (file) {
                    setState(() {
                      dashboardController.productImagesList.add(file);
                    });
                  });
                },
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const Icon(Icons.cloud_upload_outlined,
                          size: 45, color: Color.fromARGB(255, 36, 39, 44)),
                      const SizedBox(height: 6),
                      const Text(
                        'Browse and choose the files you want to upload from your mobile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff7C7C7C),
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 6),
                      Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffAF6CDA),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: const Icon(Icons.add,
                              size: 45, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            dashboardController.productImageUrl == null ||
                    dashboardController.productImagesList.isNotEmpty
                ? SizedBox(
                    child: dashboardController.productImagesList.isNotEmpty
                        ? SizedBox(
                            height: 120,
                            width: 140,
                            child: Image.file(
                                dashboardController.productImagesList.last),
                          )
                        : Container(),
                  )
                : CachedNetworkImage(
                    width: 140,
                    height: 120,
                    imageUrl: dashboardController.productImageUrl!,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
          ],
        ),
      ],
    );
  }

  categories(
      DashboardController dashboardController, productCategories, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Product Categories",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: style),
        const SizedBox(
          height: 5,
        ),
        productCategories.length > 0
            ? Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey), // Set border color here
                  borderRadius:
                      BorderRadius.circular(5.0), // Set border radius here
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: dashboardController.selectedProductCategory,
                  items: productCategories
                      .map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_name'].toString(),
                      child: SizedBox(
                          width: 150, child: Text(category['category_name'])),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    var selectedCategory = productCategories.firstWhere(
                      (category) =>
                          category['category_name'].toString() == newValue,
                    );
                    setState(() {
                      dashboardController.selectedProductCategory = newValue;
                      dashboardController.selectedProductCategoryID =
                          selectedCategory['category_id'];
                    });
                    productFormKey.currentState!.validate();
                    _getSubCategoriesList(
                        selectedCategory['category_id'].toString());
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Select a Category';
                    }
                    return null;
                  },
                ))
            : const Text("No dropdown found"),
        const SizedBox(
          height: 10,
        ),
        dashboardController.subCategory.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("Sub Categories :",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: style),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey), // Set border color here
                          borderRadius: BorderRadius.circular(
                              5.0), // Set border radius here
                        ),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: dashboardController.selectedSubProductCategory,
                          items: dashboardController.subCategory
                              .map<DropdownMenuItem<String>>((category) {
                            return DropdownMenuItem<String>(
                              value: category['sub_category_name'].toString(),
                              child: SizedBox(
                                  width: 150,
                                  child: Text(category['sub_category_name'])),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            var selectedCategory =
                                dashboardController.subCategory.firstWhere(
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
                              return 'Select Sub Category';
                            }
                            return null;
                          },
                        ))
                  ])
            : Container(),
      ],
    );
  }

  createProductButton(DashboardController dashboardController, productId) {
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          dashboardController.savedChoices.isNotEmpty == true
              ? const Color(0xFFAF6CDA)
              : const Color(0xFFAF6CDA).withOpacity(0.35)),
    );
    return GetBuilder<DashboardController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
              style: elevatedButtonStyle,
              onPressed: () async {
                dashboardController.savedChoices.isNotEmpty
                    ? await handleCreateMode(productId)
                    : null;
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  isEdit == true ? "Update" : "Save",
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ),
      );
    });
  }

  handleCreateMode(productId) {
    if (productFormKey.currentState!.validate()) {
      if (dashboardController.savedChoices.isEmpty) {
        print("Error");
        setState(() {
          errormsg = true;
        });
      } else {
        final Map<String, dynamic> parameters = Get.parameters;
        if (parameters.containsKey('storeId')) {
          _storeId = parameters['storeId'].toString();
        }
        dashboardController.createProduct(context, _storeId, productId);
      }
    }
    // Get.toNamed('/dashboard');
  }

  displayUploadedImages(DashboardController dashboardController) {
    return dashboardController.productImageUrl == null ||
            dashboardController.productImagesList.isNotEmpty
        ? Expanded(
            flex: 1,
            child: SizedBox(
              child: Row(
                children: [
                  if (dashboardController.productImagesList.isNotEmpty)
                    SizedBox(
                      height: 120,
                      width: 140,
                      child: Image.file(
                          dashboardController.productImagesList.last),
                    ),
                ],
              ),
            ),
          )
        // multipleImagesDisplay(dashboardController)
        : CachedNetworkImage(
            width: 140,
            height: 120,
            imageUrl: dashboardController.productImageUrl!,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }

  SizedBox multipleImagesDisplay(DashboardController dashboardController) {
    return SizedBox(
      height: 150.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dashboardController.croppedImages.length,
        itemBuilder: (context, index) {
          final imageItem =
              dashboardController.croppedImages[index]['croppedImage'];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              imageItem,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDefaultSwitch(int index) {
    return Switch(
      value: isDefaultList[index],
      onChanged: (value) {
        setState(() {
          isDefaultList[index] = value;
        });
      },
    );
  }

  Widget _buildChoiceForms(BoxDecoration decorationStyle) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: choiceFormKeys.length,
      itemBuilder: (context, index) {
        // if (dashboardController.savedChoices.isNotEmpty) {
        //   _selectedChoice = dashboardController.savedChoices.isNotEmpty
        //       ? choiceTypes.firstWhere(
        //           (choice) =>
        //               choice.chName ==
        //               dashboardController.savedChoices[index]['choiceType'],
        //           orElse: () => Choice(chId: -1, chName: 'Default'),
        //         )
        //       : null;
        // }

        // Map<String, dynamic>? savedChoice1 =
        //     index < dashboardController.savedChoices.length
        //         ? dashboardController.savedChoices[index]
        //         : null;
        // print("savedChoice1");
        // print(savedChoice1);
        // // Use savedChoice to prepopulate form fields, if available
        // _selectedChoice =
        //     savedChoice1 != null ? savedChoice1['selectedChoice'] : null;

        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Form(
              key: choiceFormKeys[index],
              child: Container(
                decoration: decorationStyle,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text('Choice Type:',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Color(0xff7D7D7D),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Colors.grey), // Set border color here
                                borderRadius: BorderRadius.circular(
                                    5.0), // Set border radius here
                              ),
                              height: 50,
                              child: DropdownButtonFormField<Choice>(
                                value: _selectedChoice,
                                items: choiceTypes
                                    .map((choice) => DropdownMenuItem<Choice>(
                                          value: choice,
                                          child: Text(choice.chName),
                                        ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a choice type';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  print("888888");
                                  print(value?.chName);
                                  setState(() {
                                    _selectedChoice = value!;
                                    // Clear the error message when a value is selected
                                    choiceFormKeys[index]
                                        .currentState
                                        ?.validate();
                                    if (value.chName != '') {
                                      Choice? selectedChoice =
                                          choiceTypes.firstWhere(
                                        (choice) =>
                                            choice.chName == value.chName,
                                      );

                                      dashboardController.selectedChoiceID =
                                          selectedChoice.chId;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'MRP',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff7D7D7D),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                              controller: mrpPriceControllers[index],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return 'Please enter MRP name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                choiceFormKeys[_currentChoiceFormIndex]
                                    .currentState
                                    ?.validate();
                              },
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Selling Price',
                                border: OutlineInputBorder(),
                                labelStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff7D7D7D),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                              controller: sellingPriceControllers[index],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if ((value == null || value.isEmpty)) {
                                  return 'Please enter selling price value';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                choiceFormKeys[_currentChoiceFormIndex]
                                    .currentState
                                    ?.validate();
                              },
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text(
                                'Update Stock',
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7D7D7D),
                                    fontSize: 12),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    splashRadius: 5,
                                    onPressed: () {
                                      setState(() {
                                        decrementControllerValue(index);
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: TextFormField(
                                      controller: stockControllers[index],
                                      decoration: const InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        hintText: '',
                                      ),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      onChanged: (text) {
                                        // Handle onChanged if needed
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    splashRadius: 5,
                                    onPressed: () {
                                      setState(() {
                                        incrementControllerValue(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: Colors.red,
                          ),
                          _buildDefaultSwitch(index),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _pickFile(String fileType, Function(File) onFilePicked) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', "png"],
    );

    if (result != null) {
      if (result.files.isNotEmpty) {
        String? filePath = result.files.first.path;
        File file = File(filePath!);
        onFilePicked(file);
      } else {
        print("No files selected");
      }
    } else {
      // User canceled the picker
      print("No $fileType selected");
    }
  }

  void addChoice(GlobalKey<FormState> formKey) {
    setState(() {
      submitAttemptChoice = true;
    });
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      for (var i = 0; i < dashboardController.savedChoices.length; i++) {
        dashboardController.savedChoices[i]['isDefault'] = false;
      }
      dashboardController.savedChoices.add({
        'choiceId': _selectedChoice?.chId.toString(),
        'choiceType': _selectedChoice?.chName,
        'Mrp': double.parse(mrpPriceControllers[_currentChoiceFormIndex].text),
        'sellingPrice':
            double.parse(sellingPriceControllers[_currentChoiceFormIndex].text),
        'Stock': double.parse(stockControllers[_currentChoiceFormIndex].text),
        'isDefault': isDefaultList.length > _currentChoiceFormIndex
            ? isDefaultList[_currentChoiceFormIndex]
            : false,
      });
      setState(() {
        submitAttemptChoice = false;
        choiceFormKeys.add(GlobalKey<FormState>());
        _selectedChoice = null;
        mrpPriceControllers.add(TextEditingController());
        sellingPriceControllers.add(TextEditingController());
        stockControllers.add(TextEditingController());
        _currentChoiceFormIndex = choiceFormKeys.length - 1;
        isDefaultList.add(false);
      });

      mrpPriceControllers[_currentChoiceFormIndex].clear();
      sellingPriceControllers[_currentChoiceFormIndex].clear();
      stockControllers[_currentChoiceFormIndex] =
          TextEditingController(text: "1");
    }
  }

  void decrementControllerValue(int index) {
    int currentValue = int.tryParse(stockControllers[index].text) ?? 0;
    if (currentValue > 0) {
      stockControllers[index].text = (currentValue - 1).toString();
    }
  }

// Increment function
  void incrementControllerValue(int index) {
    int currentValue = int.tryParse(stockControllers[index].text) ?? 0;
    stockControllers[index].text = (currentValue + 1).toString();
  }
}

class Choice {
  int chId;
  String chName;

  Choice({required this.chId, required this.chName});
}
