import 'package:get/get.dart';
import './controller.dart';
import 'package:alfa_tool/use_cases/start_provisioning_useCase.dart';

class ProvisioningBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(StartProvisioningUseCase());
    Get.put(ProvisioningController());
  }
}
