import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:practicing_google_map/service/get_location.dart';

class LocationUpdateController extends GetxController {
  GoogleMapController? mapController;
  Marker? currentLocationMarker;
  late final Timer _locationTimer;
  late LatLng latLng;

  List<LatLng> _locationPoints = [];
  Set<Polyline> _polylines = {};

  get getPolylines => _polylines;

  Future<void> updateLocation() async {
    try {
      Position position = await GetLocation.determinePosition();
      latLng = LatLng(position.latitude, position.longitude);
      _locationPoints.add(latLng);

      _polylines = {
        Polyline(
          polylineId: PolylineId("tracking_line"),
          color: Colors.blue,
          width: 5,
          points: _locationPoints,
        ),
      };

      // Update marker
      currentLocationMarker = Marker(
        markerId: MarkerId("current_location"),
        position: latLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(
          title: "My Location",
          snippet: "Lat: ${position.latitude.toStringAsFixed(2)} Long: ${position.longitude.toStringAsFixed(2)}",
        ),
      );
      update();
    } catch (e) {
      print("Location update error: $e");
    }
  }

  void startLocationUpdates() {
    updateLocation(); // immediately fetch on start

    _locationTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      updateLocation();
    });
  }

  void goToMyLocation() async {
    Position position = await GetLocation.determinePosition();
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 18,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _locationTimer.cancel();
    mapController?.dispose();
    super.dispose();
  }
}
