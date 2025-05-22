import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practicing_google_map/controller/location_update_controller.dart';
import 'package:practicing_google_map/service/get_location.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _locationUpdateController = Get.find<LocationUpdateController>();


  @override
  void initState() {
    _locationUpdateController.startLocationUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Map"), actions: []),
      body: GetBuilder<LocationUpdateController>(
        builder: (context) {
          return GoogleMap(
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              _locationUpdateController.mapController = controller;
              _locationUpdateController.goToMyLocation();
            },
            trafficEnabled: true,
            initialCameraPosition: CameraPosition(target: LatLng(0, 0), zoom: 2),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (LatLng latlng) {
              print(latlng);
            },
            polylines: _locationUpdateController.getPolylines,
            markers:
                _locationUpdateController.currentLocationMarker != null
                    ? {_locationUpdateController.currentLocationMarker!}
                    : {},
          );
        }
      ),
    );
  }
}
