//
//  ESPTouchHelper.swift
//  Runner
//
//  Created by Alvin on 2024/7/4.
//

import Foundation

class ESPTouchHelper: NSObject, ESPProvisionerDelegate {
    static let shared = ESPTouchHelper()
    private let provisioner = ESPProvisioner.share()

    private override init() {
        super.init()
    }

    func startProvisioning(ssid: String, bssid: String, password: String) {
        let request = ESPProvisioningRequest()
        request.ssid = ssid.data(using: .utf8) ?? Data()
        request.password = password.data(using: .utf8) ?? Data()
        request.bssid = bssid.data(using: .utf8) ?? Data()
        
        provisioner.startProvisioning(request, with: self)
    }

    func startSync() {
        provisioner.startSync(with: self)
    }

    // ESPProvisionerDelegate methods
    func onSyncStart() {
        sendEventToFlutter(event: "onSyncStart")
    }

    func onSyncStop() {
        sendEventToFlutter(event: "onSyncStop")
    }

    func onSyncError(_ exception: NSException) {
        sendEventToFlutter(event: "onSyncError", message: exception.reason)
    }

    func onProvisioningStart() {
        sendEventToFlutter(event: "onProvisioningStart")
    }

    func onProvisioningStop() {
        sendEventToFlutter(event: "onProvisioningStop")
    }

    func onProvisoningScanResult(_ result: ESPProvisioningResult) {
        sendEventToFlutter(event: "onProvisoningScanResult", message: "address: \(result.address), bssid \(result.bssid)")
    }

    func onProvisioningError(_ exception: NSException) {
        sendEventToFlutter(event: "onProvisioningError", message: exception.reason)
    }

    private func sendEventToFlutter(event: String, message: String? = nil) {
        guard let controller = UIApplication.shared.keyWindow?.rootViewController as? FlutterViewController else {
            return
        }
        let channel = FlutterMethodChannel(name: "com.example.esptouch", binaryMessenger: controller.binaryMessenger)
        var arguments: [String: Any] = ["event": event]
        if let message = message {
            arguments["message"] = message
        }
        channel.invokeMethod("onEvent", arguments: arguments)
    }
}

