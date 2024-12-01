import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({super.key});

  @override
  State<UserLocation> createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  final LoginController landingPageController = Get.find<LoginController>();

  final DashboardController dashboardController =
      Get.find<DashboardController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool displaySend = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.clear();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission;
      dashboardController.serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (dashboardController.serviceEnabled == false) {
        _showLocationServiceAlertDialog();
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedDialog();
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

  Future getAddressFromLatLng(LatLng location) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );
    if (placemarks.isNotEmpty) {
      Placemark? secondPlacemark = placemarks.length > 1 ? placemarks[1] : null;

      setState(() {
        landingPageController.streetNameController.text =
            " ${secondPlacemark!.street}";
        landingPageController.locationController.text =
            " ${secondPlacemark.subLocality},${secondPlacemark.locality}";
        landingPageController.areaCodeController.text =
            "${secondPlacemark.postalCode}";
        landingPageController.addressController.text =
            " ${secondPlacemark.subLocality}, ${secondPlacemark.locality}, ${secondPlacemark.subAdministrativeArea}, ${secondPlacemark.administrativeArea}";
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

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: RefreshIndicator(
              color: const Color.fromARGB(255, 185, 62, 62),
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await _getCurrentLocation();
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                  hintText: 'Search for a place',
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 2.0, horizontal: 10),
                                  filled: true,
                                  fillColor: Color(0xffF4EBFF),
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
                            onPressed:
                                displaySend ? _searchAndMoveCamera : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 350,
                      child: GoogleMap(
                        trafficEnabled: true,
                        compassEnabled: true,
                        onCameraMove: _onCameraMove,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: landingPageController.selectedLocation,
                          zoom: 17,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId(
                                'user_marker1'), // Give the marker an ID
                            position: landingPageController.selectedLocation,
                          ),
                        },
                        onTap: (LatLng latLng) {
                          setState(() {
                            landingPageController.selectedLocation = latLng;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Switch on your location to stay in tune with what’s happening in your area',
                      style: SafeGoogleFont('Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: const Color(0xff868889)),
                    ),
                    TextFormField(
                      controller: landingPageController.houseNumberController,
                      decoration: const InputDecoration(
                        labelText: 'House number',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: landingPageController.streetNameController,
                      decoration: const InputDecoration(
                        labelText: 'Street Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' Enter valid Street name';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: landingPageController.addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' Enter valid Address ';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: landingPageController.areaCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Area Code',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ' Enter valid Area Code ';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: elevatedButtonStyle,
                      onPressed: () async {
                        // if (_formKey.currentState!.validate()) {
                        //   _formKey.currentState!.save();
                        //   var shShipId = '';
                        //   bool value = await landingPageController
                        //       .addCustomerAddressToShippindg1(
                        //           context, shShipId, context);
                        //   if (value == true) {
                        //     Get.toNamed('/customerProductInterests',
                        //         arguments: {'fromDashboard': 'false'});
                        //   }
                        // }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onCameraMove(CameraPosition position) {
    setState(() async {
      landingPageController.selectedLocation =
          LatLng(position.target.latitude, position.target.longitude);
      await getAddressFromLatLng(
          LatLng(position.target.latitude, position.target.longitude));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _showLocationServiceAlertDialog() {
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

  void _showPermissionDeniedDialog() {
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
          markerId: const MarkerId('user_marker'), // Give the marker an ID
          position: position,
        ),
      );
      landingPageController.selectedLocation =
          LatLng(position.latitude, position.longitude);
      await getAddressFromLatLng(LatLng(position.latitude, position.longitude));
    });
  }

  Future<void> _searchAndMoveCamera() async {
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
}
