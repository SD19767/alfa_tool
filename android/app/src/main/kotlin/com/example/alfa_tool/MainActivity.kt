package com.example.alfa_tool

import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.espressif.iot.esptouch2.provision.*

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.esptouch"
    private val TAG = "AlvinTest"

    private lateinit var provisioner: EspProvisioner
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        provisioner = EspProvisioner(this)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        sendEventToFlutter(EventType.CHANNEL_CREATE, "channel create")

        setMethodCallHandler()
    }

    private fun setMethodCallHandler() {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startProvisioning" -> {
                    val ssid = call.argument<String>("ssid")
                    val bssid = call.argument<String>("bssid")
                    val password = call.argument<String>("password")
                    val reservedData = call.argument<String>("reservedData")
                    val aseKey = call.argument<String>("aseKey")
                    if (ssid != null && bssid != null && password != null) {
                        Log.i(TAG, "Starting provisioning with SSID: $ssid, BSSID: $bssid")
                        startProvisioning(ssid, bssid, password, reservedData, aseKey)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "SSID, BSSID, or Password is null", null)
                    }
                }
                "startSync" -> {
                    startSync()
                    result.success(null)
                }
                "stopSync" -> {
                    stopSync()
                    result.success(null)
                }
                "isSyncing" -> {
                    result.success(isSyncing())
                }
                "stopProvisioning" -> {
                    stopProvisioning()
                    result.success(null)
                }
                "isProvisioning" -> {
                    result.success(isProvisioning())
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startProvisioning(ssid: String, bssid: String, password: String, reservedData: String?, aseKey: String?) {
        val parsedBSSID = verifyAndParseBSSID(bssid)
        if (parsedBSSID == null) {
            Log.e(TAG, "Invalid BSSID: $bssid")
            sendEventToFlutter(EventType.PROVISIONING_ERROR, "Invalid BSSID: $bssid")
            return
        }

        sendEventToFlutter(EventType.PROVISIONING_START, "BSSID verify pass")

        try {
            val request = EspProvisioningRequest.Builder(this)
                    .setSSID(ssid.toByteArray(Charsets.UTF_8))
                    .setBSSID(parsedBSSID)
                    .setPassword(password.toByteArray(Charsets.UTF_8))
                    .setReservedData(reservedData?.toByteArray(Charsets.UTF_8))
                    .setAESKey(aseKey?.toByteArray(Charsets.UTF_8))
                    .build()

            provisioner.startProvisioning(request, object : EspProvisioningListener {
                override fun onStart() {
                    Log.i(TAG, "onProvisioningStart")
                    sendEventToFlutter(EventType.PROVISIONING_START, "Provisioning started")
                }

                override fun onResponse(result: EspProvisioningResult) {
                    Log.i(TAG, "onProvisoningScanResult")
                    val address = result.address.hostAddress
                    val bssid = result.bssid
                    sendEventToFlutter(EventType.PROVISIONING_SCAN_RESULT, "address: $address, bssid: $bssid")
                }

                override fun onStop() {
                    Log.i(TAG, "Provisioning stopped")
                    sendEventToFlutter(EventType.PROVISIONING_STOP, "Provisioning stopped")
                }

                override fun onError(exception: Exception) {
                    Log.e(TAG, "Provisioning error: ${exception.message}", exception)
                    sendEventToFlutter(EventType.PROVISIONING_ERROR, exception.message)
                }
            })
        } catch (e: Exception) {
            Log.e(TAG, "Error creating provisioning request: ${e.message}", e)
            sendEventToFlutter(EventType.PROVISIONING_ERROR, "Error creating provisioning request: ${e.message}")
        }
    }


    private fun verifyAndParseBSSID(bssid: String): ByteArray? {
        val parts = bssid.split(":")
        if (parts.size != 6) {
            return null
        }
        return try {
            ByteArray(6) { Integer.parseInt(parts[it], 16).toByte() }
        } catch (e: NumberFormatException) {
            null
        }
    }

    private fun startSync() {
        provisioner.startSync(object : EspSyncListener {
            override fun onStart() {
                Log.i(TAG, "Sync started")
                sendEventToFlutter(EventType.SYNC_START, "Sync started")
            }

            override fun onStop() {
                Log.i(TAG, "Sync stopped")
                sendEventToFlutter(EventType.SYNC_STOP, "Sync stopped")
            }

            override fun onError(exception: Exception) {
                Log.e(TAG, "Sync error: ${exception.message}", exception)
                sendEventToFlutter(EventType.SYNC_ERROR, exception.message)
            }
        })
    }

    private fun stopSync() {
        provisioner.stopSync()
    }

    private fun isSyncing(): Boolean {
        return provisioner.isSyncing
    }

    private fun stopProvisioning() {
        provisioner.stopProvisioning()
    }

    private fun isProvisioning(): Boolean {
        return provisioner.isProvisioning
    }

    private fun sendEventToFlutter(event: EventType, message: String? = null) {
        runOnUiThread {
            Log.d(TAG, "sendEventToFlutter: ${event.methodName}, message: $message")
            try {
                methodChannel.invokeMethod(event.methodName, message)
            } catch (error: Error) {
                Log.d(TAG, "sendEventToFlutter error: ${event.methodName}, error: $error")
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        provisioner.close()
    }

    enum class EventType(val methodName: String) {
        CHANNEL_CREATE("channelCreate"),
        PROVISIONING_START("onProvisioningStart"),
        PROVISIONING_SCAN_RESULT("onProvisioningScanResult"),
        PROVISIONING_STOP("onProvisioningStop"),
        PROVISIONING_ERROR("onProvisioningError"),
        SYNC_START("onSyncStart"),
        SYNC_STOP("onSyncStop"),
        SYNC_ERROR("onSyncError")
    }
}