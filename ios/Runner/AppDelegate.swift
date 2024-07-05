import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        GeneratedPluginRegistrant.register(with: self)
        let channel = FlutterMethodChannel(name: "com.example.esptouch", binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { (call, result) in
            if call.method == "startProvisioning" {
                guard let args = call.arguments as? [String: String],
                      let ssid = args["ssid"],
                      let bssid = args["bssid"],
                      let password = args["password"] else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                ESPTouchHelper.shared.startProvisioning(ssid: ssid, bssid: bssid, password: password)
                result("Provisioning started")
            } else if call.method == "startSync" {
                ESPTouchHelper.shared.startSync()
                result("Sync started")
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
