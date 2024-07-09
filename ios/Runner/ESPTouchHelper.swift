import Foundation

class ESPTouchHelper: NSObject, ESPProvisionerDelegate {
    static let shared = ESPTouchHelper()
    private var channel: FlutterMethodChannel?
    private let provisioner = ESPProvisioner.share()

    private override init() {
        super.init()
    }
    
    func setupChannel(with controller: FlutterViewController) {
        channel = FlutterMethodChannel(name: "com.example.esptouch", binaryMessenger: controller.binaryMessenger)
        sendEventToFlutter(event: .channelCreate, message: "channelCreate")
        
        channel?.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            switch call.method {
            case "startProvisioning":
                guard let args = call.arguments as? [String: String],
                      let ssid = args["ssid"],
                      let bssid = args["bssid"],
                      let password = args["password"] else {
                    result(FlutterError(code: "INVALID_ARGUMENT", message: "Invalid arguments", details: nil))
                    return
                }
                self.startProvisioning(ssid: ssid, bssid: bssid, password: password)
                result("Provisioning started")
            case "startSync":
                self.startSync()
                result("Sync started")
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    func startProvisioning(ssid: String, bssid: String, password: String) {
        guard let parsedBSSID = verifyAndParseBSSID(bssid) else {
            sendEventToFlutter(event: .provisioningError, message: "Invalid BSSID: \(bssid)")
            return
        }

        let request = ESPProvisioningRequest()
        request.ssid = ssid.data(using: .utf8) ?? Data()
        request.password = password.data(using: .utf8) ?? Data()
        request.bssid = parsedBSSID

        provisioner.startProvisioning(request, with: self)
    }

    func startSync() {
        provisioner.startSync(with: self)
    }

    // ESPProvisionerDelegate methods
    func onSyncStart() {
        sendEventToFlutter(event: .syncStart, message: "Sync started")
    }

    func onSyncStop() {
        sendEventToFlutter(event: .syncStop, message: "Sync stopped")
    }

    func onSyncError(_ exception: NSException) {
        sendEventToFlutter(event: .syncError, message: exception.reason)
    }

    func onProvisioningStart() {
        sendEventToFlutter(event: .provisioningStart, message: "Provisioning started")
    }

    func onProvisioningStop() {
        sendEventToFlutter(event: .provisioningStop, message: "Provisioning stopped")
    }

    func onProvisoningScanResult(_ result: ESPProvisioningResult) {
        let message = "address: \(result.address), bssid: \(result.bssid)"
        sendEventToFlutter(event: .provisioningScanResult, message: message)
    }

    func onProvisioningError(_ exception: NSException) {
        sendEventToFlutter(event: .provisioningError, message: exception.reason)
    }

    private func verifyAndParseBSSID(_ bssid: String) -> Data? {
        let parts = bssid.split(separator: ":")
        guard parts.count == 6 else {
            return nil
        }
        var bssidData = Data()
        for part in parts {
            guard let byte = UInt8(part, radix: 16) else {
                return nil
            }
            bssidData.append(byte)
        }
        sendEventToFlutter(event: .provisioningStart, message: "BSSID verify pass")
        return bssidData
    }

    private func sendEventToFlutter(event: EventType, message: String? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            print("Alvin Test \(event.methodName)" )
            self.channel?.invokeMethod(event.methodName, arguments: message)
        }
    }
}

enum EventType: String {
    case channelCreate = "channelCreate"
    case provisioningStart = "onProvisioningStart"
    case provisioningScanResult = "onProvisioningScanResult"
    case provisioningStop = "onProvisioningStop"
    case provisioningError = "onProvisioningError"
    case syncStart = "onSyncStart"
    case syncStop = "onSyncStop"
    case syncError = "onSyncError"

    var methodName: String {
        return self.rawValue
    }
}
