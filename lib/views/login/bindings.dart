import 'package:get/get.dart';
import 'package:alfa_tool/useCases/esp_event_handler_useCase.dart';
import 'package:alfa_tool/useCases/start_provisioning_useCase.dart';
import './controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ESPEventHandlerUseCase());
    Get.put(StartProvisioningUseCase());

    Get.put(LoginController());
  }
}
