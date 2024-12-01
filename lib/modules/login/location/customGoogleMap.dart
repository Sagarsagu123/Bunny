// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class CustomGoogleMap extends StatefulWidget {
  final bool isEdit;
  final String routeTo;
  final bool setDefault;
  final String routeFrom;
  final Map<String, dynamic> customerAddress;
  const CustomGoogleMap(
      {super.key,
      required this.isEdit,
      required this.routeTo,
      required this.setDefault,
      required this.customerAddress,
      required this.routeFrom});

  @override
  CustomGoogleMapState createState() => CustomGoogleMapState();
}

class CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final LoginController landingPageController = Get.find<LoginController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// focus node for all fields
  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode phone1Focus = FocusNode();
  FocusNode phone2Focus = FocusNode();

  FocusNode houseNumberFocus = FocusNode();
  FocusNode streetNameFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode areaCodeFocus = FocusNode();
  bool displaySend = false;
  bool error = false;
  String? shShipId;
  @override
  void initState() {
    super.initState();
    _searchController.clear();
    _getCurrentLocation();
    clearAllTextFieldsInitially();
    if (widget.customerAddress.isNotEmpty) {
      widget.customerAddress.forEach((key, value) {
        print("$key: $value");
        if (key == 'sh_cus_fname') {
          landingPageController.firstName.text = value;
        } else if (key == 'sh_cus_lname') {
          landingPageController.lastName.text = value;
        } else if (key == 'sh_cus_email') {
          landingPageController.email.text = value;
        } else if (key == 'sh_phone1') {
          landingPageController.phone1.text = value;
        } else if (key == 'sh_phone2') {
          landingPageController.phone2.text = value;
        } else if (key == 'sh_location1') {
          landingPageController.streetNameController.text = value;
        } else if (key == 'sh_location') {
          landingPageController.addressController.text = value;
        } else if (key == 'sh_zipcode') {
          landingPageController.areaCodeController.text = value;
        } else if (key == 'sh_id') {
          shShipId = value.toString();
        } else if (key == 'sh_default_addr') {
          if (value == true) {
            landingPageController.switchValue = true;
          } else {
            landingPageController.switchValue = false;
          }
        } else if (key == 'sh_label') {
          if (value == "HOME") {
            landingPageController.selectedAddressTypeValue = 1;
          } else if (value == "WORK") {
            landingPageController.selectedAddressTypeValue = 2;
          } else {
            landingPageController.selectedAddressTypeValue = 3;
          }
        }
      });
    }
  }

  clearAllTextFieldsInitially() {
    landingPageController.firstName.clear();
    landingPageController.lastName.clear();
    landingPageController.email.clear();
    landingPageController.phone1.clear();
    landingPageController.phone2.clear();
    landingPageController.streetNameController.clear();
    landingPageController.addressController.clear();
    landingPageController.areaCodeController.clear();
    landingPageController.switchValue = false;
  }

  Future<void> _getCurrentLocation() async {
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
      await getAddressFromLatLng(LatLng(position.latitude, position.longitude));

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

  Future<void> _onclear() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _searchController.clear();
      _addMarker(LatLng(position.latitude, position.longitude));
      landingPageController.selectedLocation =
          LatLng(position.latitude, position.longitude);
      displaySend = false;
    });
  }

  _addMarker(LatLng position) {
    setState(() async {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_marker'),
          position: position,
        ),
      );
      landingPageController.selectedLocation =
          LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(LatLng(position.latitude, position.longitude));
    });
  }

  Future getAddressFromLatLng(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark? secondPlacemark = placemarks.length > 1 ? placemarks[1] : null;
      print(secondPlacemark!);
      setState(() {
        landingPageController.streetNameController.text =
            " ${secondPlacemark.street}";
        landingPageController.areaCodeController.text =
            "${secondPlacemark.postalCode}";
        landingPageController.addressController.text =
            " ${secondPlacemark.subLocality}, ${secondPlacemark.locality}, ${secondPlacemark.subAdministrativeArea}, ${secondPlacemark.administrativeArea}";

        ///  recently added
        landingPageController.locationController1.text =
            " ${secondPlacemark.subLocality}, ${secondPlacemark.locality}, ${secondPlacemark.administrativeArea}";
        landingPageController.locationController2.text =
            " ${secondPlacemark.street}";
        landingPageController.zipcode.text = " ${secondPlacemark.postalCode}";
        landingPageController.landmark.text = " ${secondPlacemark.subLocality}";

        landingPageController.cityController.text =
            " ${secondPlacemark.locality}";
        landingPageController.stateController.text =
            " ${secondPlacemark.administrativeArea}";
        landingPageController.countryController.text =
            " ${secondPlacemark.country}";
      });
    } else {
      print("No address found");
    }
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle elevatedButtonStyle = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFAF6CDA)),
    );
    return SafeArea(
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              child: Column(children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 32,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              border: Border.all(
                                color: Colors.purple,
                                width: 1.2,
                              ),
                            ),
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
                              decoration: const InputDecoration(
                                hintText: 'Search a place',
                                prefixIcon: Icon(Icons.search),
                                border:
                                    InputBorder.none, // Remove default border

                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20),
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
                        onPressed: displaySend ? searchAndMoveCamera : null,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 280,
                          child: GoogleMap(
                            trafficEnabled: true,
                            compassEnabled: true,
                            onCameraMove: onCameraMove,
                            onMapCreated: onMapCreated,
                            initialCameraPosition: CameraPosition(
                              target: landingPageController.selectedLocation,
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId(
                                    'user_marker1'), // Give the marker an ID
                                position:
                                    landingPageController.selectedLocation,
                              ),
                            },
                            onTap: (LatLng latLng) {
                              setState(() {
                                landingPageController.selectedLocation = latLng;
                              });
                            },
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: [
                                    const Text("Make Default: "),
                                    Switch(
                                      value: landingPageController.switchValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          landingPageController.switchValue =
                                              newValue;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              widget.isEdit == true
                                  ? createSizedTextField(
                                      landingPageController.firstName,
                                      'First Name',
                                      context,
                                      firstNameFocus)
                                  : Container(),
                              widget.isEdit == true
                                  ? createSizedTextField(
                                      landingPageController.lastName,
                                      'Last Name',
                                      context,
                                      lastNameFocus)
                                  : Container(),
                              widget.isEdit == true
                                  ? createSizedTextField(
                                      landingPageController.email,
                                      'Email',
                                      context,
                                      emailFocus)
                                  : Container(),
                              // widget.isEdit == true
                              //     ?
                              createSizedTextField(landingPageController.phone1,
                                  'Phone Number', context, phone1Focus),
                              // : Container(),
                              createSizedTextField(landingPageController.phone2,
                                  'Mobile Number', context, phone2Focus),
                              createSizedTextField(
                                  landingPageController.houseNumberController,
                                  'House Number',
                                  context,
                                  houseNumberFocus),
                              createSizedTextField(
                                  landingPageController.streetNameController,
                                  'Street Name',
                                  context,
                                  streetNameFocus),
                              createSizedTextField(
                                  landingPageController.addressController,
                                  'Address',
                                  context,
                                  addressFocus),
                              createSizedTextField(
                                  landingPageController.areaCodeController,
                                  'Area Code',
                                  context,
                                  areaCodeFocus),
                              createSizedTextField(
                                  landingPageController.cityController,
                                  'City',
                                  context,
                                  areaCodeFocus),
                              createSizedTextField(
                                  landingPageController.stateController,
                                  'State',
                                  context,
                                  areaCodeFocus),
                              createSizedTextField(
                                  landingPageController.countryController,
                                  'Country',
                                  context,
                                  areaCodeFocus),
                              const SizedBox(height: 5),
                              saveAddressAs(),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: elevatedButtonStyle,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      await landingPageController
                                          .addCustomerAddressToShipping(
                                              context,
                                              shShipId == null ? "" : shShipId!,
                                              widget.routeTo,
                                              widget.setDefault == true
                                                  ? true
                                                  : false,
                                              widget.routeFrom,
                                              widget.routeTo == "intrested"
                                                  ? "Normal"
                                                  : "checkout");
                                    }
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget saveAddressAs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Save this Address As:"),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      landingPageController.selectedAddressTypeValue = 1;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return landingPageController.selectedAddressTypeValue == 1
                          ? const Color(0xffAF6CDA)
                          : Colors.grey;
                    }),
                  ),
                  icon: const Icon(Icons.home, size: 16, color: Colors.white),
                  label: const Text(
                    'HOME',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      landingPageController.selectedAddressTypeValue = 2;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return landingPageController.selectedAddressTypeValue == 2
                          ? const Color(0xffAF6CDA)
                          : Colors.grey;
                    }),
                  ),
                  icon: const Icon(Icons.work, size: 16, color: Colors.white),
                  label: const Text(
                    'WORK',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      landingPageController.selectedAddressTypeValue = 3;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      return landingPageController.selectedAddressTypeValue == 3
                          ? const Color(0xffAF6CDA)
                          : Colors.grey;
                    }),
                  ),
                  icon: const Icon(Icons.place, size: 16, color: Colors.white),
                  label: const Text(
                    'Other',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
        ],
      ),
    );
  }

  Widget createSizedTextField(TextEditingController controller,
      String labelText, BuildContext context, FocusNode nextFocus) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        focusNode: nextFocus,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Enter $labelText';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction:
            nextFocus == Null ? TextInputAction.done : TextInputAction.next,
        onChanged: (value) {
          FocusScope.of(context).requestFocus(nextFocus);
        },
      ),
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode nextFocus) {
    _fieldFocusChange(context, nextFocus);
  }

  Future<void> searchAndMoveCamera() async {
    final query = _searchController.text;
    try {
      List<Location> locations = await locationFromAddress(query.trim());
      if (locations.isNotEmpty) {
        LatLng setLocation = LatLng(
          locations[0].latitude,
          locations[0].longitude,
        );

        _mapController?.animateCamera(CameraUpdate.newLatLng(setLocation));
        _addMarker(setLocation);
      }
    } catch (e) {
      print("Error geocoding address: $e");
    }
  }

  void updateMarker(LatLng position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('user_marker'),
          position: position,
        ),
      );
    });
  }

  void onCameraMove(CameraPosition position) {
    setState(() async {
      landingPageController.selectedLocation =
          LatLng(position.target.latitude, position.target.longitude);
      await getAddressFromLatLng(
          LatLng(position.target.latitude, position.target.longitude));
    });
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
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
}
