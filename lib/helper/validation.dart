enum ValidationType { ssid, password, bssid, aesKey }

class Validation {
  Map<ValidationType, String? Function(String?)> validations = {
    ValidationType.ssid: (value) {
      if (value == null || value.isEmpty) {
        return 'SSID cannot be empty';
      }
      return null;
    },
    ValidationType.password: (value) {
      if (value == null || value.isEmpty) {
        return 'Password cannot be empty';
      } else if (value.length < 8) {
        return 'Password must be at least 8 characters long';
      }
      return null;
    },
    ValidationType.bssid: (value) {
      if (value == null || value.isEmpty) {
        return 'BSSID cannot be empty';
      } else if (!RegExp(r'^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$')
          .hasMatch(value)) {
        return 'BSSID format is invalid';
      }
      return null;
    },
    ValidationType.aesKey: (value) {
      if (value != null && value.isNotEmpty && value.length != 16) {
        return 'AES Key must be 16 characters long';
      }
      return null;
    },
  };
}
