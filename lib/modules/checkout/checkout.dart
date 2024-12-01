// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/dialog_utils.dart';
import 'package:flutter_demo/modules/login/location/customGoogleMap.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/values/app_constant.dart';
import 'package:flutter_demo/widgets/app_bar/custom_app_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends State<Checkout> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final LoginController landingPageController = Get.find<LoginController>();

  TextEditingController addressController = TextEditingController();

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  String selectedOption = "Delivery";
  String selectedDay = '';
  String selectedTimeSlot = '';
  String selectedTimeSlotForBackEnd = '';

  bool showError = false;
  int? selectedTimeSlotIndex;
  bool showTimeSlotError = false;
  bool showDayError = true;
  List<dynamic> customerShipAddress = [];
  int defaultIndex = 0;
  int _selectedIndex = 0;
  String selectedShId = "";
  String selectedDate = '';
  @override
  void initState() {
    super.initState();
    fetchCartData();
    _getCurrentLocation();
    _cartDeliveryDetails();
    _getDeliveryAddress();
  }

  _addMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_marker'), // Give the marker an ID
          position: position,
        ),
      );
      landingPageController.selectedLocation =
          LatLng(position.latitude, position.longitude);
    });
  }

  Future _getDeliveryAddress() async {
    var jsonData = await dashboardController.getDeliveryAddress();

    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData != null && jsonData['data'] != null) {
        setState(() {
          customerShipAddress = jsonData['data']['shipping_address'];
        });
      } else {
        setState(() {
          customerShipAddress = [];
        });
      }
    }
  }

  Future _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _addMarker(LatLng(position.latitude, position.longitude));
        landingPageController.selectedLocation =
            LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user location: $e");
      }
    }
  }

  Future fetchCartData() async {
    var jsonData = await dashboardController.myCart();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 700));
    } else {
      if (jsonData != null) {
        setState(() {
          dashboardController.cartData = jsonData['data'][0];
        });
      } else {
        setState(() {
          dashboardController.cartData = null;
        });
      }
    }
  }

  Future _cartDeliveryDetails() async {
    var jsonData = await dashboardController.cartDeliveryDetail();

    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData != null) {
        setState(() {
          dashboardController.checkDetails = jsonData['data'];
        });
      } else {
        setState(() {
          dashboardController.checkDetails = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var storeSlotDetails;
    var addedItemDetails;

    var storePickUpAddress;
    if (dashboardController.checkDetails != null) {
      storeSlotDetails = dashboardController.checkDetails['store_slots'];
      storePickUpAddress = dashboardController.checkDetails['st_address'];
    }
    if (dashboardController.cartData != null) {
      addedItemDetails =
          dashboardController.cartData['cart_details'][0]['added_item_details'];
    }
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBarCheckOut(dashboardController, context),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: const Color(0xffF4F4F6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildOptionButton(
                          "Delivery",
                        ),
                        buildOptionButton(
                          "Pickup",
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5.0),
                      if (selectedOption == "Delivery") ...[
                        listOfDeliveryAddress(customerShipAddress),
                      ] else if (selectedOption == "Pickup") ...[
                        pickUpDetails(storePickUpAddress),
                      ],
                      slotDetailsNew(context, storeSlotDetails),
                      itemsDetails(addedItemDetails),
                      const SizedBox(height: 10.0),
                      proceedButton(storeSlotDetails, customerShipAddress),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  slotDetailsNew(BuildContext context, storeSlotDetails) {
    if (storeSlotDetails != null && storeSlotDetails.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          slotDetails(storeSlotDetails[0]),
        ],
      );
    } else {
      return const CircularProgressIndicator();
    }
  }

  Widget itemsDetails(List<dynamic> addedItemDetails) {
    return Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Items Details:',
                style: SafeGoogleFont("Poppins",
                    color: const Color(0xff868889),
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            ...addedItemDetails.map((item) {
              if (item == null) {
                return const SizedBox.shrink();
              }

              var productName = item['product_name'];
              var productImage = item['product_image'];
              var cartQuantity = item['cart_quantity'];

              var firstChoiceAmount = item["cart_has_choice"] == "Yes"
                  ? item["cart_choices"][0]["choice_amount"]
                  : null;
              var firstChoiceName = item["cart_has_choice"] == "Yes"
                  ? item["cart_choices"][0]["choice_name"]
                  : null;
              return ListTile(
                leading: CachedNetworkImage(
                  fit: BoxFit.fill,
                  width: 70,
                  imageUrl: productImage,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text(
                  productName,
                  style: SafeGoogleFont(
                    "Poppins",
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff868889),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          '$firstChoiceName',
                          style: SafeGoogleFont(
                            "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff585858),
                          ),
                        ),
                        Text(
                          " and $cartQuantity pieces",
                          style: SafeGoogleFont(
                            "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff585858),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Price:',
                          style: SafeGoogleFont(
                            "Poppins",
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          " \$$firstChoiceAmount",
                          style: SafeGoogleFont(
                            "Poppins",
                            fontSize: 17.0,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffAF6CDA),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget slotDetails(Map<String, dynamic> weekDetails) {
    return Column(
      children: [dateAndTimeWithValidation(weekDetails)],
    );
  }

  Column dateAndTimeWithValidation(weekDetails) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Delivery Date',
                      style: SafeGoogleFont("Poppins",
                          color: const Color(0xff868889),
                          fontWeight: FontWeight.w600,
                          fontSize: 18)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    weekDetails.entries.length - DateTime.now().weekday,
                    (index) {
                      // Calculate the index-based day from the current day
                      String day = weekDetails.keys
                          .elementAt(index + DateTime.now().weekday);

                      // Extract day details
                      Map<String, dynamic> dayDetails = weekDetails[day]!;

                      // If day is not available or status is false, return an empty container
                      if (!dayDetails['status']) {
                        return const Column(
                          children: [
                            // Text(
                            //   "Slot not availble ",
                            //   style: TextStyle(color: Colors.red),
                            // ),
                            SizedBox.shrink(),
                          ],
                        );
                      } else {}

                      // Get the current date and calculate the button's date
                      DateTime currentDate = DateTime.now();
                      DateTime buttonDate =
                          currentDate.add(Duration(days: index));

                      // Variable to store the formatted date
                      String formattedDate;

                      // Display "Today" for the current day
                      if (index == 0) {
                        formattedDate = "Today";
                      }
                      // Display "Tomorrow" for the next day
                      else if (index == 1) {
                        formattedDate = "Tomorrow";
                      }
                      // Display the date for other days
                      else {
                        formattedDate =
                            "${buttonDate.day}-${buttonDate.month}-${buttonDate.year}";
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SizedBox(
                          height: 35,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedDay = day;
                                showError = false;
                                showTimeSlotError = false;
                                selectedTimeSlot = '';
                                selectedTimeSlotIndex = null;
                                selectedDate =
                                    "${buttonDate.year}-${buttonDate.month.toString().padLeft(2, '0')}-${buttonDate.day.toString().padLeft(2, '0')}";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: day == selectedDay
                                  ? const Color(0xffAF6CDA)
                                  : const Color.fromARGB(28, 39, 49, 8),
                            ),
                            child: Text(
                              formattedDate,
                              style: SafeGoogleFont(
                                "Poppins",
                                color: day == selectedDay
                                    ? Colors.white
                                    : const Color(0xff1c2731),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Please select a day',
                style: SafeGoogleFont("Poppins",
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 12),
              ),
            ),
          ),
        if (selectedDay.isNotEmpty)
          const SizedBox(
            height: 10,
          ),
        Align(
          alignment: Alignment.topLeft,
          child: Text('Time',
              style: SafeGoogleFont("Poppins",
                  color: const Color(0xff868889),
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              (weekDetails[selectedDay] ?? const {})['slots']?.length ?? 0,
              (index) {
                Map<String, dynamic>? slot =
                    (weekDetails[selectedDay] ?? const {})['slots']?[index];
                if (slot == null || slot['status'] == false) {
                  // If slot is not available or status is false, return an empty container
                  return const SizedBox.shrink();
                }

                String slotTime = slot['slot_time'];

                return buildTimeSlotButton(slotTime, index);
              },
            ),
          ),
        ),
        if (showTimeSlotError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Please select a time slot',
                style: SafeGoogleFont("Poppins",
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
            ),
          ),
        const SizedBox(height: 25),
      ],
    );
  }

  SizedBox proceedButton(weekDetails, customerShipAddress) {
    return SizedBox(
      height: 50,
      width: Get.width / 1.7,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
        ),
        onPressed: () async {
          setState(() {
            showError = selectedDay.isEmpty;
            showTimeSlotError = selectedTimeSlotIndex == null && !showError;
          });
          if (!showError && !showTimeSlotError) {
            String selectedShiId11 = '';

            Map<String, dynamic> selectedAddress =
                customerShipAddress.firstWhere(
              (address) => address['sh_default_addr'] == true,
              orElse: () => null,
            );
            selectedShiId11 = selectedAddress['sh_id'].toString();
            // bypassing
            String finalId =
                selectedShId == '' ? selectedShiId11 : selectedShId;

            var combinedDateAndTime =
                '$selectedDate $selectedTimeSlotForBackEnd';
            final checkoutInfo = CheckOutInfo(
                storeId:
                    dashboardController.checkDetails['store_id'].toString(),
                preOrderDate: combinedDateAndTime.toString(),
                preOrderStatus: "0",
                shShipId: finalId.toString());
            var jsonData = await dashboardController.updateCheckoutInfor(
                checkoutInfo, selectedOption);

            if (jsonData != null && jsonData['code'] == 400) {
              // Display success modal
              showCustomDialog("Error", jsonData['message'], context, true);
            } else {
              if ((jsonData['message'] == "Saved successfully!" ||
                      jsonData['message'] ==
                          "Pre order date updated successfully!") &&
                  (jsonData['data']["delivery_availability"] ==
                          "Delivery Available" ||
                      jsonData['data']["delivery_availability"] ==
                          "Not applicable")) {
                setState(() {
                  dashboardController.shId = finalId;
                  dashboardController.ordSelfPickup =
                      selectedOption == "Delivery" ? "0" : "1";
                });
                Get.toNamed("/payment");
                // Display error modal
                // showCustomDialog("Success", jsonData['message'], context);
              } else {}
            }
          }
        },
        child: Text(
          'Proceed',
          style: SafeGoogleFont("Poppins", fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Padding buildTimeSlotButton(String slotTime, int index) {
    String startTime = slotTime.split(" to ")[0];
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
      child: SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: () {
            List<String> times = slotTime.split(" to ");
            String splitTime = times[0];
            List<String> timeTo24HoursFormat = splitTime.split(" ");
            String splitTime1 = timeTo24HoursFormat[0];
            String amPm = timeTo24HoursFormat[1];

            List<String> hoursAndMinutes = splitTime1.split(":");
            int hours = int.parse(hoursAndMinutes[0]);
            int minutes = int.parse(hoursAndMinutes[1]);

            if (amPm == 'PM' && hours < 12) {
              hours += 12;
            } else if (amPm == 'AM' && hours == 12) {
              hours = 0;
            }

            String formattedTime =
                '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
            setState(() {
              selectedTimeSlot = splitTime;
              selectedTimeSlotForBackEnd = formattedTime;
              selectedTimeSlotIndex = index;
              showError = false;
              showTimeSlotError = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedTimeSlotIndex == index
                ? const Color(0xffAF6CDA)
                : const Color.fromARGB(28, 39, 49, 8),
          ),
          child: Text(
            ' $startTime',
            style: SafeGoogleFont(
              "Poppins",
              color: selectedTimeSlotIndex == index
                  ? Colors.white
                  : const Color(0xff1c2731),
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget listOfDeliveryAddress(List<dynamic> customerShipAddress) {
    if (customerShipAddress.isNotEmpty) {
      return Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Delivery Address',
              style: SafeGoogleFont("Poppins",
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff868889),
                  fontSize: 18),
            ),
          ),
          Column(
            children: customerShipAddress.asMap().entries.map((entry) {
              final index = entry.key;
              final address = entry.value;

              return Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECECEC)),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: RadioListTile(
                    value: index,
                    activeColor: Colors.purple,
                    groupValue: _selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        _selectedIndex = value!;
                        selectedShId =
                            customerShipAddress[value]['sh_id'].toString();
                      });
                    },
                    title: Text(
                      '${address['sh_label'] ?? "-"}',
                      style: SafeGoogleFont("Poppins",
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff868889),
                          fontSize: 14),
                    ),
                    subtitle: Wrap(
                      children: [
                        const Icon(
                          Icons.pin_drop_rounded,
                          color: Color(0xffAF6CDA),
                        ),
                        Text(
                          '${address['sh_location']},${address['sh_location1']},${address['sh_zipcode']},${address['sh_location']}',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: SafeGoogleFont("Poppins",
                              fontWeight: FontWeight.w400,
                              overflow: TextOverflow.ellipsis,
                              color: const Color(0xff6B7280),
                              fontSize: 10),
                        ),
                      ],
                    ),
                    secondary: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color(0xff868889),
                      ),
                      onPressed: () {
                        _handleEditButton(index);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: Get.width / 1.5,
              height: 32,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFAF6CDA)),
                  ),
                  onPressed: () {
                    _showShippingAddressDialog(context, landingPageController,
                        {});
                  },
                  child: Text(
                    "Add New Address",
                    style: SafeGoogleFont("Poppins", color: Colors.white),
                  )),
            ),
          ),
          const Divider()
        ],
      );
    }
    return Container();
  }

  void _handleEditButton(int index) {
    setState(() {
      _selectedIndex = index;
      selectedShId = customerShipAddress[index]['sh_id'].toString();
    });
    Map<String, dynamic> currentAddress = customerShipAddress[index];

    _showShippingAddressDialog(context, landingPageController, currentAddress);
  }

  _showShippingAddressDialog(
      BuildContext context,
      LoginController landingPageController,
      Map<String, dynamic> currentAddress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AlertDialog(
            insetPadding: const EdgeInsets.all(5),
            backgroundColor: Colors.white,
            actionsPadding: const EdgeInsets.all(2),
            contentPadding: const EdgeInsets.all(2),
            content: Container(
              padding: const EdgeInsets.all(4.0),
              child: shippingAddress(landingPageController, currentAddress),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget shippingAddress(
      LoginController landingPageController, customerAddress) {
    // Get.toNamed('/customGoogleMap');
    return CustomGoogleMap(
      isEdit: true,
      setDefault: false,
      routeTo: "",
      routeFrom: '',
      customerAddress: customerAddress,
    );
  }

  pickUpDetails(storePickUpAddress) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('PickUp details',
              style: SafeGoogleFont("Poppins",
                  color: const Color(0xff868889),
                  fontWeight: FontWeight.w600,
                  fontSize: 20)),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const Icon(
              Icons.pin_drop_outlined,
              size: 35,
              color: Color(0xffAF6CDA),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pick up location",
                  style: SafeGoogleFont("Poppins",
                      color: const Color(0xff868889),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "$storePickUpAddress",
                  style: SafeGoogleFont("Poppins",
                      color: const Color(0xff868889),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            const Icon(
              Icons.lock_clock_rounded,
              size: 35,
              color: Color(0xffAF6CDA),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pick up time",
                  style: SafeGoogleFont("Poppins",
                      color: const Color(0xff868889),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  selectedTimeSlot.isNotEmpty == true
                      ? selectedTimeSlot
                      : "   ---",
                  style: SafeGoogleFont("Poppins",
                      color: const Color(0xff868889),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        const Divider()
      ],
    );
  }

  Widget buildOptionButton(String option) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedOption = option;
            });
          },
          style: TextButton.styleFrom(
              backgroundColor: selectedOption == option
                  ? const Color(0xffAF6CDA)
                  : Colors.transparent,
              padding: const EdgeInsets.all(16.0),
              shape: const StadiumBorder()),
          child: Text(
            option,
            style: SafeGoogleFont("Poppins",
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
                color: selectedOption == option
                    ? const Color(0xffFFFFFF)
                    : const Color(0xff959595)),
          ),
        ),
      ),
    );
  }

  appBarCheckOut(
      DashboardController dashboardController, BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(appBarHeight),
      child: Container(
        color: Colors.white,
        child: CustomAppBar(
          height: getVerticalSize(
            80,
          ),
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 8, 15),
            child: InkWell(
                onTap: () {
                  Get.back();
                  // Get.toNamed(
                  //   '/myCart',
                  // );
                },
                child: const Icon(Icons.arrow_back_ios)),
          ),
          centerTitle: true,
          title: Text(
            'Order confirmation',
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w500, color: const Color(0xff868889)),
          ),
        ),
      ),
    );
  }
}

class CheckOutInfo {
  final String storeId;
  final String preOrderDate;
  final String shShipId;
  final String preOrderStatus;

  CheckOutInfo({
    required this.storeId,
    required this.preOrderDate,
    required this.shShipId,
    required this.preOrderStatus,
  });
}
