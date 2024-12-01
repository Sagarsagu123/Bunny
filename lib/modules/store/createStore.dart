// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/core/utils/image_constant.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/appbar_image.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CreateStorePage extends StatefulWidget {
  const CreateStorePage({super.key});

  @override
  _CreateStorePageState createState() => _CreateStorePageState();
}

class _CreateStorePageState extends State<CreateStorePage> {
  final GlobalKey<FormState> storeFormKey = GlobalKey<FormState>();
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();

  final TextEditingController _searchController = TextEditingController();
  bool displaySend = false;
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  late LatLng _userLocation;
  bool _isEditing = false;
  String _storeId = '';

  var uuid = const Uuid();
  String? sessionToken = '123456';
  List<dynamic> placesList = [];
  int selectedStoregrouptype = 1;
  List<dynamic> restaurantInfo = [];
  bool shouldFetchSuggestions = false;
  bool dataHasBeenSet = false;
  bool isAgreed = false;
  final List<String> documentCategories = [
    "Meat Handling Permit",
    "Poultry Handling Permit",
    "Dairy Manufacturing Permit",
    "Small-scale Cheese Exemption",
    "Meat Exemption Documentation",
    "Poultry Exemption Documentation",
    "Department of Health Inspection Report",
    "Department of Agriculture Inspection Report",
    "Home Processor/Microprocessor License",
    "USDA Certification (Organic)",
    "Egg Wholesaler/Distributor",
    "Nursery License",
    "Other",
  ];
  String GUIDELINES = '';
  @override
  void initState() {
    super.initState();
    dashboardController.selectedCottageFoodLawOption = 'Yes';
    dashboardController.selectedActivePermitToSellOption = 'Yes';
    _searchController.clear();
    _getUserLocation();
    _getStoreCategoryList();

    dashboardController.storeAddressController.addListener(() {
      onChange();
    });
    GUIDELINES =
        "http://buywithbunny.com/uploads/bunny-seller-guidlines-May2024.pdf";
    final Map<String, dynamic> parameters = Get.parameters;
    if (parameters.containsKey('type') || parameters.containsKey('storeId')) {
      String page = parameters['type'];
      _isEditing = page == 'edit' ? true : false;
      _storeId = parameters['storeId'];
      isAgreed = true;
    } else {
      _isEditing = false;
      _storeId = '';
      isAgreed = false;
    }
    dashboardController.storeNameController.clear();
    dashboardController.taxIdController.clear();
    dashboardController.storeAddressController.clear();
    dashboardController.storeDeliveryController.clear();
    dashboardController.licenseDocs.clear();
    dashboardController.proofDocs.clear();
    dashboardController.certificateDocs.clear();

    // _searchController.clear();
    if (_isEditing == true) {
      getstoreDetails(_storeId);
      setState(() {
        dashboardController.currentStoreId = _storeId;
      });
    }

    checkLocationService();
  }

  @override
  void dispose() {
    dashboardController.storeAddressController.removeListener(onChange);
    placesList.clear();
    super.dispose();
  }

  void onFocusChange() {
    setState(() {
      shouldFetchSuggestions = true; // Set flag to true when field gains focus
    });
  }

  void onChange() {
    if (shouldFetchSuggestions) {
      if (sessionToken == null) {
        setState(() {
          sessionToken = uuid.v4();
        });
      }
      getSuggession(dashboardController.storeAddressController.text);
    }
  }

  void getSuggession(String input) async {
    String apiKey = "AIzaSyBQ68u6vJvA2K19ReNxHZotDZnWGjRF_tc";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$apiKey&sessiontoken=$sessionToken';

    try {
      var response = await http.get(Uri.parse(request));
      var data = response.body.toString();
      print("data");
      print(data);
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          placesList = jsonDecode(response.body.toString())["predictions"];
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    }
  }

  Future getstoreDetails(String storeId) async {
    var jsonData = await landingPageController.getstoreproducts(storeId);

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        restaurantInfo = jsonData['data']['restaurant_info'];
        if (restaurantInfo.isNotEmpty) {
          if (restaurantInfo.isNotEmpty &&
              restaurantInfo[0]['store_license'] != null) {
            dashboardController.licenseDocs1 =
                restaurantInfo[0]['store_license'];
            dashboardController.selectedCategoryDoc1 =
                restaurantInfo[0]['license_label'];
          }
          if (restaurantInfo.isNotEmpty &&
              restaurantInfo[0]['store_proof'] != null) {
            dashboardController.proofDocs1 = restaurantInfo[0]['store_proof'];
            dashboardController.selectedCategoryDoc2 =
                restaurantInfo[0]['proof_label'];
          }
          if (restaurantInfo.isNotEmpty &&
              restaurantInfo[0]['store_certificate'] != null) {
            dashboardController.certificateDocs1 =
                restaurantInfo[0]['store_certificate'];
            dashboardController.selectedCategoryDoc3 =
                restaurantInfo[0]['certificate_label'];
            // downloadAndSetCertificate(restaurantInfo[0]['store_certificate']);
          }
          print(restaurantInfo[0]['store_lat']);
          print(restaurantInfo[0]['store_long']);
          if (restaurantInfo.isNotEmpty &&
              restaurantInfo[0]['store_lat'] != null) {
            _userLocation = LatLng(double.parse(restaurantInfo[0]['store_lat']),
                double.parse(restaurantInfo[0]['store_long']));
          }

          print(restaurantInfo[0]['store_certificate'].length);
        }
      });
    } else {
      setState(() {
        restaurantInfo = [];
        dashboardController.licenseDocs = [];
        dashboardController.proofDocs = [];
        dashboardController.certificateDocs = [];
      });
    }
  }

  Future _getStoreCategoryList() async {
    var jsonData = await dashboardController.getCategoriesListForStore();

    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        dashboardController.categogyTypesForCreateStore =
            jsonData['data']['category_Details'];
        GUIDELINES = jsonData['data']['bunny-guidlines'] ??
            "http://buywithbunny.com/uploads/bunny-seller-guidlines-May2024.pdf";
      });
    }
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission;
      dashboardController.serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (dashboardController.serviceEnabled == false) {
        showLocationServiceAlertDialog();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showPermissionDeniedDialog();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _addMarker(LatLng(position.latitude, position.longitude));
        _userLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      // Handle any errors related to location retrieval
      if (kDebugMode) {
        print("Error getting user location: $e");
      }
    }
  }

  void showLocationServiceAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text(
              'Please enable location services to use this feature.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Denied'),
          content: const Text(
              'Please grant location permission to use this feature by refreshing screen.'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _userLocation =
          LatLng(position.target.latitude, position.target.longitude);
    });
  }

  Future<void> checkLocationService() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text(
                "Please enable location services in your device settings."),
            actions: [
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_marker'), // Give the marker an ID
          position: position,
        ),
      );
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _searchAndMoveCamera() async {
    final query = _searchController.text;
    try {
      List<Location> locations = await locationFromAddress(query.trim());
      if (locations.isNotEmpty) {
        LatLng selectedLocation = LatLng(
          locations[0].latitude,
          locations[0].longitude,
        );

        _mapController?.animateCamera(CameraUpdate.newLatLng(selectedLocation));
        _addMarker(selectedLocation);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$e"),
      ));
      print("Error geocoding address: $e");
    }
  }

  Future<void> _onclear() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _searchController.clear();
      _addMarker(LatLng(position.latitude, position.longitude));
      _userLocation = LatLng(position.latitude, position.longitude);
      displaySend = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String data;
    if (!dataHasBeenSet && restaurantInfo.isNotEmpty) {
      dashboardController.storeNameController.text =
          restaurantInfo[0]['restaurant_name'];
      dashboardController.taxIdController.text =
          restaurantInfo[0]['st_taxId'] ?? "";
      dashboardController.storeWebSiteController.text =
          restaurantInfo[0]['store_website'] ?? "";
      dashboardController.selectedCottageFoodLawOption =
          restaurantInfo[0]['cottage_foodLaw'] ?? "";
      dashboardController.selectedActivePermitToSellOption =
          restaurantInfo[0]['active_permit'] ?? "";

      dashboardController.storeAddressController.text =
          restaurantInfo[0]['restaurant_location'];
      dashboardController.storeDeliveryController.text =
          restaurantInfo[0]['st_delivery_radius'] ?? "";
      _userLocation = LatLng(double.parse(restaurantInfo[0]['store_lat']),
          double.parse(restaurantInfo[0]['store_long']));
      if (restaurantInfo[0]['st_category'] == "1") {
        data = "Farm";
      } else if (restaurantInfo[0]['st_category'] == "2") {
        data = "Personal";
      } else {
        data = "Business";
      }

      dashboardController.selectedcategoryTypesForCreateStore = data.toString();
      dataHasBeenSet = true;
    }
    ButtonStyle elevatedButtonStyle1 = ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color(0xffaf6cda).withOpacity(.3)));
    TextStyle style = const TextStyle(
        fontFamily: "Poppins",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xff838383));
    TextStyle style1 = const TextStyle(
        fontFamily: "Poppins",
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xff838383));

    if (dashboardController.categogyTypesForCreateStore.isNotEmpty) {
      bool initialValueExists =
          dashboardController.categogyTypesForCreateStore.any((category) {
        return category['category_name'] ==
            dashboardController.selectedcategoryTypesForCreateStore;
      });
      if (initialValueExists) {
        dashboardController.initialValue =
            dashboardController.selectedcategoryTypesForCreateStore;
      }
    }
    print(_userLocation.latitude);
    print(_userLocation.longitude);
    print(GUIDELINES);
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            appBar: appBar11(),
            body: SingleChildScrollView(
                child: SizedBox(
                    child: Form(
              key: storeFormKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    storeName(dashboardController, style),
                    const SizedBox(
                      height: 10,
                    ),
                    taxId(dashboardController, style),
                    const SizedBox(
                      height: 10,
                    ),
                    storeAddress(dashboardController, style),
                    deliveryRadius(style),
                    const SizedBox(
                      height: 10,
                    ),
                    mainCategory(style),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    storeWebsite(dashboardController, style),
                    const SizedBox(
                      height: 10,
                    ),
                    buildCottageFoodLawQuestion(style1),
                    const SizedBox(
                      height: 10,
                    ),
                    buildActivePermitToSellQuestion(style1),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 180, 178, 180),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          children: [
                            documentOne(style, elevatedButtonStyle1),
                            const Divider(
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            documentTow(style, elevatedButtonStyle1),
                            const Divider(
                              thickness: 2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            documentThree(style, elevatedButtonStyle1),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    displayRefresh(),
                    googleMap(),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding: const EdgeInsets.all(10),
                                backgroundColor: Colors.white,
                                actionsPadding: const EdgeInsets.all(10),
                                contentPadding: const EdgeInsets.all(10),
                                title: const Center(
                                  child: Text(
                                    "Guidelines and Conditions",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFAF6CDA),
                                        fontSize: 20),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                      height: Get.height,
                                      width: Get.width,
                                      child: SfPdfViewer.network(GUIDELINES)),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isAgreed = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  ElevatedButton(
                                    style: elevatedButtonStyle,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        isAgreed = !isAgreed;
                                      });
                                    },
                                    child: Text(
                                      isAgreed == false ? 'Agree' : "Revert",
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: isAgreed == false
                                ? const Icon(Icons.check_box_outline_blank)
                                : const Icon(Icons.check_box),
                          ),
                          const Expanded(
                            flex: 12,
                            child: Text(
                              'Read guidlines and condition continue.',
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16.0,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    createButton(dashboardController, selectedStoregrouptype),
                  ],
                ),
              ),
            )))),
      ),
    );
  }

  void handleAgree() {
    setState(() {
      isAgreed = true;
    });
    Navigator.pop(context); // Close modal
  }

  Column documentOne(TextStyle style, ButtonStyle elevatedButtonStyle1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("1: Document Type", style: style),
        SizedBox(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              hintText: 'Select Document Category',
              suffixIcon: dashboardController.selectedCategoryDoc1 != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          dashboardController.selectedCategoryDoc1 = null;
                        });
                      },
                    )
                  : null,
            ),
            value: dashboardController.selectedCategoryDoc1 != ''
                ? dashboardController.selectedCategoryDoc1
                : null,
            items: documentCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: SizedBox(
                    width: Get.width - 150,
                    child:
                        Text(category, style: const TextStyle(fontSize: 14))),
              );
            }).toList(),
            onChanged: (String? newValue) {
              print(newValue);
              setState(() {
                dashboardController.selectedCategoryDoc1 = newValue;
              });
              print('Selected category: $newValue');
            },
            validator: (value) {
              print(value);
              if (dashboardController.licenseDocs.isNotEmpty &&
                  dashboardController.selectedCategoryDoc1 == null) {
                if (value != null ||
                    dashboardController.selectedCategoryDoc1 != null) {
                  return 'Please select a Category';
                }
                return null;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 35,
              child: ElevatedButton.icon(
                style: elevatedButtonStyle1,
                onPressed: () {
                  _pickFile("store_license", (file) {
                    setState(() {
                      dashboardController.licenseDocs.add(file);
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: Text((
                        // _isEditing == true &&
                        dashboardController.licenseDocs.isNotEmpty ||
                            dashboardController.licenseDocs1 != null)
                    ? "Replace"
                    : "Upload"),
              ),
            ),
            (dashboardController.licenseDocs1 == null ||
                    dashboardController.licenseDocs.isNotEmpty)
                ? SizedBox(
                    child: Row(
                      children: [
                        if (dashboardController.licenseDocs.isNotEmpty)
                          SizedBox(
                            height: 120,
                            width: 100,
                            child: Image.file(
                                dashboardController.licenseDocs.last),
                          ),
                      ],
                    ),
                  )
                : dashboardController.licenseDocs1 != null
                    ? CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        width: 120,
                        height: 120,
                        imageUrl: dashboardController.licenseDocs1!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container()
          ],
        ),
        const SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Column documentTow(TextStyle style, ButtonStyle elevatedButtonStyle1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("2: Document Type", style: style),
        SizedBox(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select Document Category',
              suffixIcon: dashboardController.selectedCategoryDoc2 != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          dashboardController.selectedCategoryDoc2 = null;
                        });
                      },
                    )
                  : null,
            ),
            value: dashboardController.selectedCategoryDoc2 != ''
                ? dashboardController.selectedCategoryDoc2
                : null,
            items: documentCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: SizedBox(
                    width: Get.width - 150,
                    child:
                        Text(category, style: const TextStyle(fontSize: 14))),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dashboardController.selectedCategoryDoc2 = newValue;
              });
              print('Selected category: $newValue');
            },
            validator: (value) {
              if (dashboardController.proofDocs.isNotEmpty &&
                  dashboardController.selectedCategoryDoc2 == null) {
                if (value != null ||
                    dashboardController.selectedCategoryDoc2 != null) {
                  return 'Please select a Category';
                }
                return null;
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 35,
                child: ElevatedButton.icon(
                  style: elevatedButtonStyle1,
                  onPressed: () {
                    _pickFile("store_proof", (file) {
                      setState(() {
                        dashboardController.proofDocs.add(file);
                      });
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                      // _isEditing == true &&
                      dashboardController.proofDocs.isNotEmpty ||
                              dashboardController.proofDocs1 != null
                          ? "Replace"
                          : "Upload"),
                ),
              ),
            ),
            (dashboardController.proofDocs1 == null ||
                    dashboardController.proofDocs.isNotEmpty)
                ? SizedBox(
                    child: Row(
                      children: [
                        if (dashboardController.proofDocs.isNotEmpty)
                          SizedBox(
                            height: 120,
                            width: 100,
                            child:
                                Image.file(dashboardController.proofDocs.last),
                          ),
                      ],
                    ),
                  )
                : dashboardController.proofDocs1 != null
                    ? CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        width: 120,
                        height: 120,
                        imageUrl: dashboardController.proofDocs1!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(),
          ],
        ),
      ],
    );
  }

  Column documentThree(TextStyle style, ButtonStyle elevatedButtonStyle1) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("3: Document Type", style: style),
        SizedBox(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select Document Category',
              suffixIcon: dashboardController.selectedCategoryDoc3 != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          dashboardController.selectedCategoryDoc3 = null;
                        });
                      },
                    )
                  : null,
            ),
            value: dashboardController.selectedCategoryDoc3 != ''
                ? dashboardController.selectedCategoryDoc3
                : null,
            onChanged: (String? newValue) {
              // Update the selected value when the user makes a selection
              setState(() {
                dashboardController.selectedCategoryDoc3 = newValue;
              });
              print('Selected category: $newValue');
            },
            validator: (value) {
              if (dashboardController.certificateDocs.isNotEmpty &&
                  dashboardController.selectedCategoryDoc3 == null) {
                if (value != null ||
                    dashboardController.selectedCategoryDoc3 != null) {
                  return 'Please select a Category';
                }
                return null;
              }
              return null;
            },
            items: documentCategories.map((String category) {
              return DropdownMenuItem<String>(
                value: category, // Use the category as the value
                child: SizedBox(
                    width: Get.width - 150,
                    child:
                        Text(category, style: const TextStyle(fontSize: 14))),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              child: ElevatedButton.icon(
                style: elevatedButtonStyle1,
                onPressed: () {
                  _pickFile("store_certificate", (file) {
                    setState(() {
                      dashboardController.certificateDocs.add(file);
                    });
                  });
                },
                icon: const Icon(Icons.add),
                label: Text(
                    // _isEditing == true &&
                    dashboardController.certificateDocs.isNotEmpty ||
                            dashboardController.certificateDocs1 != null
                        ? "Replace"
                        : "Upload"),
              ),
            ),
            (dashboardController.certificateDocs1 == null ||
                    dashboardController.certificateDocs.isNotEmpty)
                ? SizedBox(
                    child: Row(
                      children: [
                        if (dashboardController.certificateDocs.isNotEmpty)
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.file(
                                dashboardController.certificateDocs.last),
                          ),
                      ],
                    ),
                  )
                : dashboardController.certificateDocs1 != null
                    ? CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        width: 120,
                        height: 130,
                        imageUrl: dashboardController.certificateDocs1!,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      )
                    : Container(),
          ],
        ),
      ],
    );
  }

  Widget googleMap() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 45,
                  child: TextFormField(
                    controller: _searchController,
                    autofocus: false,
                    onChanged: (value) {
                      bool val;
                      if (value != '') {
                        val = true;
                      } else {
                        val = false;
                      }
                      setState(() {
                        displaySend = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Search for a place...',
                    ),
                  ),
                ),
              ),
            ),
            displaySend == true
                ? IconButton(
                    icon: const Icon(
                      Icons.clear_outlined,
                      size: 14,
                    ),
                    onPressed: _onclear)
                : Container(),
            IconButton(
              icon: displaySend
                  ? const Icon(Icons.send)
                  : const Icon(Icons.search),
              onPressed: displaySend ? _searchAndMoveCamera : null,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              trafficEnabled: true,
              compassEnabled: true,
              onCameraMove: _onCameraMove,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 15.0,
              ),
              markers: {
                Marker(
                  markerId:
                      const MarkerId('user_marker'), // Give the marker an ID
                  position: _userLocation,
                ),
              },
              onTap: (LatLng position) {
                setState(() {
                  _userLocation = LatLng(position.latitude, position.longitude);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget mainCategory(style) {
    return Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text("Store Category", style: style)),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: dashboardController.categogyTypesForCreateStore.isNotEmpty
              ? DropdownButtonFormField<String>(
                  isExpanded: true,
                  // value: dashboardController
                  //     .selectedcategoryTypesForCreateStore,
                  value: dashboardController.initialValue,
                  items: dashboardController.categogyTypesForCreateStore
                      .map<DropdownMenuItem<String>>((category) {
                    return DropdownMenuItem<String>(
                      value: category['category_name'].toString(),
                      child: SizedBox(
                        width: 150,
                        child: Text(category['category_name']),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    var selectedCategoryType = dashboardController
                        .categogyTypesForCreateStore
                        .firstWhere(
                      (category) =>
                          category['category_name'].toString() == newValue,
                    );
                    setState(() {
                      dashboardController.selectedcategoryTypesForCreateStore =
                          newValue!;
                      dashboardController
                              .selectedcategoryTypesIDForcreateStore =
                          selectedCategoryType['category_id'];
                    });
                    storeFormKey.currentState!.validate();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a Category';
                    }
                    return null;
                  },
                )
              : const Text("No dropdown found"),
        ),
      ],
    );
  }

  Widget deliveryRadius(TextStyle style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Delivery Radius", style: style),
        TextFormField(
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
            hintText: 'Delivery Radius in miles',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: dashboardController.storeDeliveryController,
          focusNode: dashboardController.focusNodeDeliveryRadius,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter delivery radius';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
        ),
      ],
    );
  }

  appBar11() {
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

  storeName(DashboardController controller, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Store Name", style: style),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter store name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: controller.storeNameController,
          focusNode: controller.focusNodeStoreName,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter store name';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
        ),
      ],
    );
  }

  taxId(DashboardController controller, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Tax ID", style: style),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Your Tax ID',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: controller.taxIdController,
          focusNode: controller.focusNodeTaxId,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter tax id';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          autofocus: false,
        ),
      ],
    );
  }

  storeWebsite(DashboardController controller, style) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Store Website", style: style),
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Website link...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          controller: controller.storeWebSiteController,
          focusNode: controller.focusNodeStoreWebsite,
          textInputAction: TextInputAction.next,
          autofocus: false,
        ),
      ],
    );
  }

  storeAddress(DashboardController controller, style) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Store Address", style: style),
          TextFormField(
            controller: controller.storeAddressController,
            textInputAction: TextInputAction.none,
            decoration: InputDecoration(
              hintText: 'Store Address',
              border: const OutlineInputBorder(),
              suffixIcon: controller.storeAddressController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        controller.storeAddressController.clear();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {},
            onTap: onFocusChange,
          ),
          const SizedBox(height: 20),
          ListView.builder(
            shrinkWrap: true,
            itemCount: placesList.length > 4 ? 4 : placesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(placesList[index]['description']),
                onTap: () {
                  setState(() async {
                    List<Location> location = await locationFromAddress(
                        placesList[index]['description']);
                    _addMarker(LatLng(
                        location.last.latitude, location.last.longitude));
                    _userLocation =
                        LatLng(location.last.latitude, location.last.longitude);
                    print("longitude");
                    print(location.last.longitude);
                    print(location.last.latitude);
                    controller.storeAddressController.text =
                        placesList[index]['description'];
                    dashboardController.storeAddressController
                        .removeListener(onChange); // Remove the listener
                  });
                },
              );
            },
          ),
        ]);
  }

  void clearPlacesList() {
    setState(() {
      placesList.clear(); // Clear the placesList
    });
  }

  displayRefresh() {
    return const Align(
      alignment: Alignment.topLeft,
      child: Row(
        children: [
          Expanded(
            child: Text("Location",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff838383))),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 6.0),
          //   child: IconButton(
          //     icon: const Icon(Icons.refresh),
          //     onPressed: _getUserLocation,
          //   ),
          // ),
        ],
      ),
    );
  }

  createButton(
      DashboardController dashboardController, int selectedStoregrouptype) {
    bool disable = (dashboardController.storeNameController.text.isNotEmpty ||
            dashboardController.storeAddressController.text.isNotEmpty)
        ? true
        : true;
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          (disable == true && isAgreed == true)
              ? const Color(0xFFAF6CDA)
              : const Color(0xFFAF6CDA).withOpacity(0.25)),
    );

    return GetBuilder<DashboardController>(builder: (controller) {
      return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: elevatedButtonStyle,
                  onPressed: () {
                    if (disable == true && isAgreed == true) {
                      // if (dashboardController.licenseDocs.isNotEmpty &&
                      //     dashboardController.proofDocs.isNotEmpty &&
                      //     dashboardController.certificateDocs.isNotEmpty) {
                      if (_isEditing == true) {
                        if (storeFormKey.currentState!.validate()) {
                          dashboardController.updateStore(
                              context,
                              dashboardController.currentStoreId,
                              _userLocation.latitude,
                              _userLocation.longitude,
                              dashboardController
                                  .selectedcategoryTypesIDForcreateStore!);
                        }
                      } else {
                        if (storeFormKey.currentState!.validate()) {
                          dashboardController.createStore(
                              context,
                              _userLocation.latitude,
                              _userLocation.longitude,
                              dashboardController
                                  .selectedcategoryTypesIDForcreateStore!);
                        }
                      }
                      // } else {
                      //   showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //       title: const Text("Upload Document"),
                      //       content: const Text(
                      //           "At least one document should be uploaded."),
                      //       actions: <Widget>[
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: const Text("OK"),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: _isEditing
                        ? const Text("Update",
                            style: TextStyle(color: Colors.white))
                        : const Text(
                            "Create",
                            style: TextStyle(color: Colors.white),
                          ),
                  ))
            ],
          ),
        ),
      );
    });
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
        if (filePath != null) {
          File file = File(filePath);
          onFilePicked(file);
        } else {
          print("No file path found in the result");
        }
      } else {
        print("No files selected");
      }
    } else {
      // User canceled the picker
      print("No $fileType selected");
    }
  }

  Widget buildCottageFoodLawQuestion(style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
              'Do you comply with your state’s food handling and cottage food laws? ',
              style: style),
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: 'Yes',
              groupValue: dashboardController.selectedCottageFoodLawOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedCottageFoodLawOption = value!;
                });
              },
            ),
            const Text('Yes'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: 'No',
              groupValue: dashboardController.selectedCottageFoodLawOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedCottageFoodLawOption = value!;
                });
              },
            ),
            const Text('No'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: "Don't Know",
              groupValue: dashboardController.selectedCottageFoodLawOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedCottageFoodLawOption = value!;
                });
              },
            ),
            const Text("Don't Know"),
          ],
        ),
        if (dashboardController.selectedCottageFoodLawOption == '' &&
            storeFormKey.currentState != null)
          const Text(
            'Please select an option',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }

  Widget buildActivePermitToSellQuestion(style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text('Do you have active permits to sell the above items? ',
              style: style),
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: 'Yes',
              groupValue: dashboardController.selectedActivePermitToSellOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedActivePermitToSellOption = value!;
                });
              },
            ),
            const Text('Yes'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: 'No',
              groupValue: dashboardController.selectedActivePermitToSellOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedActivePermitToSellOption = value!;
                });
              },
            ),
            const Text('No'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              activeColor: const Color(0xffAF6CDA),
              value: "Don't Know",
              groupValue: dashboardController.selectedActivePermitToSellOption,
              onChanged: (String? value) {
                setState(() {
                  dashboardController.selectedActivePermitToSellOption = value!;
                });
              },
            ),
            const Text("Don't Know"),
          ],
        ),
        if (dashboardController.selectedActivePermitToSellOption == '' &&
            storeFormKey.currentState != null)
          const Text(
            'Please select an option',
            style: TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
