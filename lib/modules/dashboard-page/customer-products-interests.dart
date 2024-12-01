import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/theme/theme_helper.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProductInterests extends StatefulWidget {
  const CustomerProductInterests({super.key});

  @override
  CustomerInterestProducts createState() => CustomerInterestProducts();
}

class CustomerInterestProducts extends State<CustomerProductInterests> {
  final LoginController landingPageController = Get.find<LoginController>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  List<dynamic> mainCategories = [];
  List<int> selectedIds = [];
  @override
  void initState() {
    super.initState();
    getInterestProducts();
    // listSharedPreferencesKeys();
    getUserNameFromSession();
  }

  Future getUserNameFromSession() async {
    await landingPageController.getUserNameFromSession();
  }

  void listSharedPreferencesKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();

    if (kDebugMode) {
      print('List of SharedPreferences keys:');
    }
    for (String key in allKeys) {
      if (kDebugMode) {
        print(key);
      }
    }
  }

  Future getInterestProducts() async {
    var jsonData = await dashboardController.getMainCategoriesListNewRender();
    setState(() {
      mainCategories = jsonData['data']['category_Details'];
    });
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decorationStyleSelected = BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: const Color.fromARGB(255, 159, 112, 173),
        width: 2,
      ),
      color: const Color(0xffffffff),
    );
    BoxDecoration decorationStyle = BoxDecoration(
      borderRadius: BorderRadius.circular(5.0),
      border: Border.all(
        color: const Color.fromARGB(255, 228, 218, 218),
        width: 1.5,
      ),
      color: const Color(0xffffffff),
    );
    var selectedCategoriesLength = mainCategories
        .where((category) => category['isSelected'] == true)
        .length;
    final Map<String, dynamic> params = Get.arguments;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBar(params['fromDashboard']),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  sectionOne(landingPageController, params['fromDashboard']),
                  const SizedBox(
                    height: 30,
                  ),
                  StaticGrid(
                    columnMainAxisAlignment: MainAxisAlignment.center,
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    rowMainAxisAlignment: MainAxisAlignment.start,
                    rowCrossAxisAlignment: CrossAxisAlignment.center,
                    gap: 15,
                    columnCount: 2,
                    children: mainCategories.map((item) {
                      var name = item['category_name'];
                      var imageName = item['category_image'];
                      var isSelectedToHighlightBorder =
                          item['isSelected'] ?? true;

                      return Builder(builder: (context) {
                        int index = mainCategories.indexOf(item);
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  mainCategories[index]["isSelected"] =
                                      !mainCategories[index]["isSelected"];

                                  if (mainCategories[index]["isSelected"]) {
                                    selectedIds.add(
                                        mainCategories[index]["category_id"]);
                                  } else {
                                    selectedIds.remove(
                                        mainCategories[index]["category_id"]);
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration:
                                        isSelectedToHighlightBorder == true
                                            ? decorationStyleSelected
                                            : decorationStyle,
                                    height: 180,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 130,
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: imageName,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Text(
                                          name,
                                          style: const TextStyle(
                                            letterSpacing: 0.6,
                                            color: Color(0xff838383),
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  submitButton(landingPageController, selectedCategoriesLength)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sectionOne(LoginController landingPageController, param) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        param != 'true'
            ? Padding(
                padding: getPadding(
                  top: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(children: [
                      Text(
                        "Welcome",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        " ${landingPageController.currentUserName.text},",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: SafeGoogleFont("Poppins",
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffAF6CDA),
                            fontSize: 18),
                      ),
                    ])
                  ],
                ),
              )
            : Container(),
        Padding(
          padding: getPadding(
            top: 8,
          ),
          child: Text(
            "Help us to provide a better selling and buying experience.",
            style: SafeGoogleFont("Poppins"),
            textAlign: TextAlign.left,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: getPadding(
              top: 28,
            ),
            child: Text(
              "Select Interested Categories",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }

  submitButton(
      LoginController landingPageController, selectedCategoriesLength) {
    bool enableButton = selectedCategoriesLength >= 3 ? true : false;
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(enableButton == true
          ? const Color(0xFFAF6CDA)
          : const Color(0xFFAF6CDA).withOpacity(0.25)),
    );
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        width: Get.width,
        height: 60,
        child: ElevatedButton(
            style: elevatedButtonStyle,
            onPressed: () async {
              enableButton
                  ? await dashboardController.onSendIds(
                      mainCategories, context, false)
                  : null;
            },
            child: Text(
              "Done",
              style: SafeGoogleFont("Poppins",
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            )),
      ),
    );
  }

  appBar(param) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(75),
      child: Stack(children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
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
        ),
        param != 'true'
            ? Positioned(
                top: 20,
                right: 10,
                child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                        onTap: () async {
                          await dashboardController.onSendIds(
                              mainCategories, context, true);
                        },
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(0, 25, 15, 0),
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Color(
                                0xffAF6CDA,
                              ),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))),
              )
            : Container(),
        param == 'true'
            ? Positioned(
                top: 35,
                left: 30,
                child: InkWell(
                    onTap: () {
                      Get.toNamed(
                        '/dashboard',
                      );
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                      color: Color.fromARGB(255, 124, 124, 122),
                    )),
              )
            : Container(),
      ]),
    );
  }
}
