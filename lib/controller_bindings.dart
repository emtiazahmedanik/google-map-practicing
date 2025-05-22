import 'package:get/get.dart';
import 'package:practicing_google_map/controller/location_update_controller.dart';

class ControllerBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(LocationUpdateController());
  }

}