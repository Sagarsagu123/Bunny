import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class ViewAllProducts extends StatefulWidget {
  const ViewAllProducts({super.key});

  @override
  ViewAllProductsState createState() => ViewAllProductsState();
}

class ViewAllProductsState extends State<ViewAllProducts> {
  final ScrollController _scrollController = ScrollController();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool callApi = true;
  List<dynamic> stockList = [];
  String storeId = '';
  int? currentPageNo;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    isLoading = true;
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('storeId')) {
      storeId = parameters['storeId'];

      // second ap
      String? pageNo = '';
      String? initialSearchValue = '';
      _getAllProductsItems(pageNo, storeId, initialSearchValue);
    }
    // third api
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future callingForSearchValue() async {
    _getAllProductsItems('', storeId, _searchController.text);
  }

  //Global API call
  Future _getAllProductsItems(
      String pageNo, String storeId, String? searchValue) async {
    // print("pageNo $pageNo");
    // print("storeId $storeId");
    // print("searchValue $searchValue");

    var jsonData = await dashboardController.getAllProductsItems(
        pageNo, storeId, searchValue!);

    if (jsonData['message'] == 'No records found!') {
      setState(() {
        callApi = false;
        isLoading = false;
      });
    } else {
      int? currentPageNo = jsonData['data']['pageNo'];
      setState(() {
        stockList = jsonData['data']['stock_list'];
        dashboardController.storeIdGlobal = storeId;
        dashboardController.pageNumber = currentPageNo.toString();
        isLoading = false;
      });
    }
  }

  void _scrollListener() {
    double threshold = 0.8;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * threshold) {
      _fetchMoreData();
    }
  }

  Future<void> _fetchMoreData() async {
    await Future.delayed(const Duration(seconds: 2));

    if (callApi == true) {
      _getAllProductsItems(
          dashboardController.pageNumber!, storeId, _searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("current pageNumber:  ${dashboardController.pageNumber}");

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: appBar(dashboardController, "View Products", context),
          body: isLoading == false
              ? Column(children: [
                  stockList.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Adjust the border radius as needed
                              border: Border.all(
                                color: Colors
                                    .purple, // Adjust the border color as needed
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      iconColor: Colors.black12,
                                      hintText: 'Search by item name',
                                      border: InputBorder
                                          .none, // Remove default border
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      // Adjust padding as needed
                                    ),
                                    onChanged: (text) async {
                                      setState(() {
                                        dashboardController.pageNumber = "";
                                      });
                                      await callingForSearchValue();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () async {
                                    setState(() {
                                      dashboardController.pageNumber = "";
                                    });
                                    await callingForSearchValue();
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: stockList.isNotEmpty
                        ? SizedBox(
                            height: Get.height,
                            child: Container(
                              color: Colors.white,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: stockList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index < stockList.length) {
                                    return displayProducts(
                                        index, stockList, context, storeId);
                                  }
                                  if (callApi == false) {
                                    return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color.fromARGB(
                                              255, 150, 101, 138),
                                        ),
                                        height: 5,
                                        child:
                                            const Center(child: Text(". . .")));
                                  } else {
                                    return _buildLoadingIndicator();
                                  }
                                },
                              ),
                            ),
                          )
                        : const Center(child: Text("No items in store")),
                  ),
                ])
              : const SpinKitCircle(
                  color: Color(0xffAF6CDA),
                  size: 50,
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}

Widget displayProducts(
    index, List stockList, BuildContext context, String storeId) {
  String itemName = stockList[index]['item_name'];
  String itemId = stockList[index]['item_id'].toString();
  String itemImg = stockList[index]['item_image'].toString();
  String itemDescription = stockList[index]['item_desc'].toString();
  stockList[index]['item_mrp'].toString();
  String itemCategoryName = stockList[index]['item_pro_cat_name'].toString();
  String itemSubCategoryName =
      stockList[index]['item_pro_subcat_name'].toString();
  String itemCategoryId = stockList[index]['item_pro_cat_id'].toString();
  String itemSubCategoryId = stockList[index]['item_pro_subcat_id'].toString();

  List<Map<String, dynamic>> selectedChoices = [];
  for (var choice in stockList[index]['item_choice_details']) {
    if (choice['default_selected'] == true) {
      selectedChoices.add(choice);
    }
  }
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromARGB(255, 167, 164, 164),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl: itemImg,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(itemName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 143, 140, 140),
                                  fontSize: 18)),
                          Row(
                            children: selectedChoices.map((choice) {
                              return Text(
                                "Choice: ${choice['item_choice_name']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 143, 140, 140),
                                    fontSize: 16),
                              );
                            }).toList(),
                          ),
                          Row(
                            children: selectedChoices.map((choice) {
                              return Text(
                                  "MRP: \u20B9${choice['item_choice_mrp']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromARGB(255, 143, 140, 140),
                                      fontSize: 16));
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(itemDescription,
                        softWrap: true,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: Color.fromARGB(255, 143, 140, 140),
                            fontSize: 18)),
                    Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        height: 35,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.toNamed(
                              '/addProduct',
                              parameters: {
                                'itemSubCategoryName': itemSubCategoryName,
                                'itemCategoryName': itemCategoryName,
                                'isEditProduct': 'true',
                                "storeId": storeId,
                                'itemName': itemName,
                                'itemImg': itemImg,
                                "itemId": itemId,
                                'itemDescription': itemDescription,
                                'itemSubCategoryId': itemSubCategoryId,
                                'itemCategoryId': itemCategoryId,
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffAF6CDA),
                          ),
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 15,
                          ),
                          label: Text(
                            "Edit",
                            style: SafeGoogleFont(
                              "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

appBar(DashboardController dashboardController, String title,
    BuildContext context) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(appBarHeight + 25),
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
              Get.back();
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
          CircleAvatar(
            backgroundImage: NetworkImage(dashboardController.currentUserImage),
          )
        ],
      ),
    ),
  );
}

class Product {
  int id;
  String name;
  String description;
  double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}

class Individualproductitem {
  String itemName;
  String itemImg;
  String itemQuantity;
  String itemDescription;
  String itemCategoryName;
  String itemSubCategoryName;

  Individualproductitem({
    required this.itemName,
    required this.itemImg,
    required this.itemQuantity,
    required this.itemDescription,
    required this.itemCategoryName,
    required this.itemSubCategoryName,
  });
}
