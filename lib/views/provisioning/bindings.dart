import 'package:get/get.dart';
import './controller.dart';

class ProvisioningBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProvisioningController());
  }
}
