import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Map"),
        actions: [
          IconButton(onPressed: _getLocation, icon: Icon(Icons.location_history)),
          IconButton(onPressed: _getLocationUpdate, icon: Icon(Icons.location_on))
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        trafficEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latlng) {
          print(latlng);
        },
        markers: {
          Marker(
            markerId: MarkerId('1'),
            position: LatLng(23.79262831053677, 90.4321189597249),
            draggable: true,
          ),
        },
      ),
    );
  }
  
  Future<void> _getLocation() async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        //return Future.error('Location permissions are denied');
        print('Location permissions are denied');
      }
    }
    print( await Geolocator.getCurrentPosition());
  }
  Future<void> _getLocationUpdate() async{
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        });
    print("position stream: $positionStream");
  }
}
