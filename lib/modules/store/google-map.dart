// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreGoogleMap extends StatefulWidget {
  const StoreGoogleMap({super.key});

  @override
  State<StoreGoogleMap> createState() => StoreGoogleMapState();
}

class StoreGoogleMapState extends State<StoreGoogleMap> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();
  LatLng _userLocation = const LatLng(12.3428969, 76.5851523);
  final TextEditingController _searchController = TextEditingController();
  bool displaySend = false;
  @override
  void initState() {
    super.initState();

    _searchController.clear();
    _getUserLocation();
    checkLocationService();
  }

  Future<void> checkLocationService() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permission is denied. Request it from the user.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user did not grant location permission.
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

  Future<void> _getUserLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _searchAndMoveCamera() async {
    final query = _searchController.text;

    if (kDebugMode) {
      print(query);
    }
    try {
      List<Location> locations = await locationFromAddress(query.trim());
      if (kDebugMode) {
        print("locations");
      }
      if (kDebugMode) {
        print(locations);
      }
      if (locations.isNotEmpty) {
        LatLng selectedLocation = LatLng(
          locations[0].latitude,
          locations[0].longitude,
        );

        dashboardController.mapController
            ?.animateCamera(CameraUpdate.newLatLng(selectedLocation));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("$e"),
      ));
      if (kDebugMode) {
        print("Error geocoding address: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            controller: _searchController,
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
              hintText: 'Search for a place...',
              suffixIcon: IconButton(
                icon: displaySend
                    ? const Icon(Icons.send)
                    : const Icon(Icons.search),
                onPressed: _searchAndMoveCamera,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 350,
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GoogleMap(
              mapType: MapType.hybrid,
              onMapCreated: (GoogleMapController controller) {
                dashboardController.mapController = controller;
              },
              onTap: (argument) {
                setState(() {
                  _userLocation = LatLng(argument.latitude, argument.longitude);
                });
              },
              markers: {
                Marker(
                  draggable: true,
                  markerId: const MarkerId(''),
                  position: _userLocation,
                ),
              },
              initialCameraPosition: CameraPosition(
                target: _userLocation,
                zoom: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
