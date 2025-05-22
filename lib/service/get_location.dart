import 'package:geolocator/geolocator.dart';
import 'package:practicing_google_map/utils/show_toast.dart';

class GetLocation{
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showToast("Location services are disabled.");
    }

    // Check permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showToast("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showToast("Location permissions are permanently denied.");
    }

    // Get the current position
    return await Geolocator.getCurrentPosition();
  }

}

