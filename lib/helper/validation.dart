import 'package:get/get.dart';

enum ValidationType { ssid, password, bssid, reservedData, aesKey }

class Validation {
  Map<ValidationType, String? Function(String?)> validations = {
    ValidationType.ssid: (value) {
      if (value == null || value.isEmpty) {
        return 'ssid_empty'.tr;
      }
      return null;
    },
    ValidationType.password: (value) {
      if (value == null || value.isEmpty) {
        return 'password_empty'.tr;
      } else if (value.length < 8) {
        return 'password_length'.tr;
      }
      return null;
    },
    ValidationType.bssid: (value) {
      if (value == null || value.isEmpty) {
        return 'bssid_empty'.tr;
      } else if (!RegExp(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$')
          .hasMatch(value)) {
        return 'bssid_format_invalid'.tr;
      }
      return null;
    },
    ValidationType.reservedData: (value) {
      if (value != null && value.isNotEmpty && value.length >= 64) {
        return 'reservedData_length'.tr;
      }
      return null;
    },
    ValidationType.aesKey: (value) {
      if (value != null && value.isNotEmpty && value.length != 16) {
        return 'aesKey_length'.tr;
      }
      return null;
    },
  };
}
