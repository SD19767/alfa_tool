import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/services/ESPTouch_Service.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/useCases/start_provisioning_useCase.dart';

// Mock 類別
class MockESPTouchService implements ESPTouchServiceInterface {
  Future<void> Function(String ssid, String bssid, String password,
      String? reservedData, String? aesKey)? onStartProvisioning;

  @override
  Future<void> startProvisioning(String ssid, String bssid, String password,
      String? reservedData, String? aesKey) {
    return Future.value();
  }

  @override
  Future<void> startSync() {
    return Future.value();
  }

  @override
  void setEventHandler(Function(MethodCall) callback) {}
}

class MockProvisioningStateManager
    implements ProvisioningStateManagerInterface {
  ProvisioningState? lastProvisioningState;
  BackgroundState? lastBackgroundState;

  @override
  Rx<ProvisioningState> get provisioningState =>
      Rx<ProvisioningState>(ProvisioningState.idle);

  @override
  Rx<BackgroundState> get backgroundState =>
      Rx<BackgroundState>(BackgroundState.purple);

  @override
  void updateProvisioningState(ProvisioningState state) {
    lastProvisioningState = state;
  }

  @override
  void updateBackgroundState(BackgroundState state) {
    lastBackgroundState = state;
  }
}

void main() {
  late MockESPTouchService? mockService;
  late MockProvisioningStateManager? mockStateManager;
  late StartProvisioningUseCase? useCase;

  setUp(() {
    mockService = MockESPTouchService();
    mockStateManager = MockProvisioningStateManager();
    // Inject the mocks into GetX
    Get.put<ESPTouchServiceInterface>(mockService!);
    Get.put<ProvisioningStateManagerInterface>(mockStateManager!);

    useCase = StartProvisioningUseCase();
  });

  tearDown(() {
    mockService = null;
    mockStateManager = null;
    useCase = null;
    Get.reset();
  });

  test('startProvisioning should call startProvisioning on ESPTouchService',
      () async {
    // Set up the mocks
    mockService!.onStartProvisioning =
        (ssid, bssid, password, reservedData, aesKey) {
      expect(ssid, 'testSSID');
      expect(bssid, '');
      expect(password, 'testPassword');
      expect(reservedData, '');
      expect(aesKey, '');
      return Future.value();
    };

    // Call the method
    await useCase!.startProvisioning(
      ssid: 'testSSID',
      bssid: '',
      password: 'testPassword',
      customData: '',
      aesKey: '',
    );

    // Verify state changes
    expect(
        mockStateManager!.lastProvisioningState, ProvisioningState.inProgress);
  });

  test('startProvisioning should throw exception if ssid is empty', () async {
    expect(
      () async {
        await useCase!.startProvisioning(
          ssid: '',
          password: 'testPassword',
        );
      },
      throwsA(isA<Exception>()
          .having((e) => e.toString(), 'message', 'SSID is required')),
    );
  });

  test('startProvisioning should throw exception if password is empty',
      () async {
    expect(
      () async {
        await useCase!.startProvisioning(
          ssid: 'testSSID',
          password: '',
        );
      },
      throwsA(isA<Exception>()
          .having((e) => e.toString(), 'message', 'Password is required')),
    );
  });

  test('startProvisioning should throw exception if aesKey length is not 16',
      () async {
    expect(
      () async {
        await useCase!.startProvisioning(
          ssid: 'testSSID',
          password: 'testPassword',
          aesKey: 'shortKey',
        );
      },
      throwsA(isA<Exception>().having((e) => e.toString(), 'message',
          'AES key should be 16 characters long')),
    );
  });

  test(
      'startProvisioning should not throw exception if aesKey is exactly 16 characters',
      () async {
    await useCase!.startProvisioning(
      ssid: 'testSSID',
      password: 'testPassword',
      aesKey: '1234567890123456',
    );
  });

  test('startProvisioning should handle empty customData correctly', () async {
    // Set up the mocks
    mockService!.onStartProvisioning =
        (ssid, bssid, password, reservedData, aesKey) {
      expect(ssid, 'testSSID');
      expect(bssid, '');
      expect(password, 'testPassword');
      expect(reservedData, '');
      expect(aesKey, '');
      return Future.value();
    };

    // Create an instance of the UseCase

    // Call the method
    await useCase!.startProvisioning(
      ssid: 'testSSID',
      bssid: '',
      password: 'testPassword',
      customData: '', // Test empty customData
      aesKey: '',
    );

    // Verify the method was called with the expected parameters
    expect(
        mockStateManager!.lastProvisioningState, ProvisioningState.inProgress);
  });

  test('startProvisioning should handle non-empty customData correctly',
      () async {
    // Set up the mocks
    mockService!.onStartProvisioning =
        (ssid, bssid, password, reservedData, aesKey) {
      expect(ssid, 'testSSID');
      expect(bssid, '');
      expect(password, 'testPassword');
      expect(reservedData, 'customDataValue'); // Test with non-empty customData
      expect(aesKey, '');
      return Future.value();
    };

    // Create an instance of the UseCase

    // Call the method
    await useCase!.startProvisioning(
      ssid: 'testSSID',
      bssid: '',
      password: 'testPassword',
      customData: 'customDataValue',
      aesKey: '',
    );

    // Verify the method was called with the expected parameters
    expect(
        mockStateManager!.lastProvisioningState, ProvisioningState.inProgress);
  });
}
