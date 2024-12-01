import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';

class SearchDashboard extends StatefulWidget {
  const SearchDashboard({super.key});

  @override
  SearchDashboardState createState() => SearchDashboardState();
}

class SearchDashboardState extends State<SearchDashboard> {
  List<dynamic> searchedProducts = [];
  List<dynamic> choicelist = [];
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  String defaultChoiceName = "";

  TextEditingController inputSearchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  Future<void> fetchData() async {
    var jsonData1 = await dashboardController.fetchProductItems(
        '', '', inputSearchController.text, '');
    if (inputSearchController.text == '') {
      setState(() {
        searchedProducts = [];
      });
    } else {
      if (jsonData1 != null && jsonData1['code'] == 400) {
        // Get.snackbar('Failure', jsonData1['message'],
        //     snackPosition: SnackPosition.bottom,
        //     duration: const Duration(milliseconds: 1000));
        setState(() {
          searchedProducts = [];
        });
      } else {
        if (jsonData1 != null && jsonData1['code'] == 200) {
          setState(() {
            searchedProducts = jsonData1['data']['item_lists'];
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffAF6CDA),
            centerTitle: true,
            title: Text(
              'Search Products',
              style: SafeGoogleFont(
                "Poppins",
                color: Colors.white,
                fontSize: 19,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        25.0), // Adjust the border radius as needed
                    border: Border.all(
                      color: Colors.purple, // Adjust the border color as needed
                      width: 1.5,
                    ),
                  ),
                  child: TextFormField(
                    controller: inputSearchController,
                    decoration: InputDecoration(
                      hintText: 'Type here to search',
                      hintStyle: const TextStyle(fontSize: 15),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: inputSearchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                inputSearchController.clear();
                                setState(() {
                                  searchedProducts = [];
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) async {
                      print(value);
                      await fetchData();
                    },
                  ),
                ),
              ),
              Expanded(
                child: searchedProducts.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchedProducts.length,
                        itemBuilder: (context, index) {
                          for (var choice in searchedProducts[index]
                              ["choices"]) {
                            if (choice["default_choice"] == true) {
                              defaultChoiceName = choice["choice_name"];
                              break;
                            }
                          }
                          final random = Random();
                          final r =
                              200 + random.nextInt(56); // Red channel (200-255)
                          final g = 200 +
                              random.nextInt(56); // Green channel (200-255)
                          final b = 200 +
                              random.nextInt(56); // Blue channel (200-255)
                          final color = Color.fromRGBO(r, g, b, 1);
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                '/productDetail',
                                parameters: {
                                  'main_category_id': searchedProducts[index]
                                          ["pro_category_id"]
                                      .toString(),
                                  'categoryName': searchedProducts[index]
                                      ["main_category_name"],
                                  'sub_category_id': searchedProducts[index]
                                          ["pro_sub_cat_id"]
                                      .toString(),
                                  'productId': searchedProducts[index]
                                          ["item_id"]
                                      .toString(),
                                },
                              );
                            },
                            child: Card(
                              // color: color,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Display item image
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Image.network(
                                        searchedProducts[index]["item_image"],
                                        fit: BoxFit.fitWidth,
                                        width: 50,
                                      ),
                                    ),

                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchedProducts[index]["item_name"],
                                          style: SafeGoogleFont(
                                            "Poppins",
                                            color: const Color.fromARGB(
                                                255, 88, 88, 88),
                                            fontSize: 15,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "MRP: ${searchedProducts[index]["choices"][0]["choice_mrp_price"].toString()}",
                                          style: SafeGoogleFont(
                                            "Poppins",
                                            color: const Color(0xFF868889),
                                            fontSize: 10,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Our Price: \$${searchedProducts[index]["choices"][0]["choice_price"].toString()}",
                                          style: SafeGoogleFont(
                                            "Poppins",
                                            color: const Color(0xFF868889),
                                            fontSize: 10,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    if (defaultChoiceName.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                    255, 122, 142, 206)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            defaultChoiceName,
                                            style: SafeGoogleFont(
                                              "Poppins",
                                              color: const Color(0xFF868889),
                                              fontSize: 11,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          inputSearchController.text.isNotEmpty
                              ? "No records found"
                              : "Search products by providing text",
                          style: SafeGoogleFont(
                            "Poppins",
                            color: const Color(0xFF868889),
                            fontSize:
                                inputSearchController.text.isNotEmpty ? 20 : 16,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
