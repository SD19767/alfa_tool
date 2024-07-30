import 'package:alfa_tool/helper/validation.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/use_cases/esp_event_handler_useCase.dart';
import 'package:alfa_tool/use_cases/start_provisioning_useCase.dart';
import './controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ESPEventHandlerUseCase());
    Get.put(StartProvisioningUseCase());
    Get.put(Validation());

    Get.put(LoginController());
  }
}
