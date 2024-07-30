import Flutter
import UIKit
import SystemConfiguration.CaptiveNetwork
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupLocationManager()
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        GeneratedPluginRegistrant.register(with: self)
        ESPTouchHelper.shared.setupChannel(with: controller)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func currentWifiInfo() -> NSDictionary? {
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interfaces in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interfaces as! CFString) as NSDictionary? {
                    return interfaceInfo
                }
            }
        }
        return nil
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            let currentWifiInfo = currentWifiInfo()
            print(currentWifiInfo ?? "nill")
        } else {
            print("位置權限未授權")
        }
    }
}

