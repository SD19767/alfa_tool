package com.example.alfa_tool

import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.espressif.iot.esptouch2.provision.EspProvisioner
import com.espressif.iot.esptouch2.provision.EspProvisioningListener
import com.espressif.iot.esptouch2.provision.EspProvisioningRequest
import com.espressif.iot.esptouch2.provision.EspProvisioningResult
import com.espressif.iot.esptouch2.provision.EspSyncListener

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.esptouch"
    private val TAG = "MainActivity"

    private lateinit var methodChannel: MethodChannel
    private lateinit var provisioner: EspProvisioner

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        provisioner = EspProvisioner(this)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startProvisioning" -> {
                    val ssid = call.argument<String>("ssid")
                    val bssid = call.argument<String>("bssid")
                    val password = call.argument<String>("password")
                    if (ssid != null && bssid != null && password != null) {
                        Log.i(TAG, "Starting provisioning with SSID: $ssid, BSSID: $bssid")
                        startProvisioning(ssid, "123456", password)
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

    private fun startProvisioning(ssid: String, bssid: String, password: String) {
        val request = EspProvisioningRequest.Builder(this)
            .setSSID(ssid.toByteArray(Charsets.UTF_8))
            .setBSSID(bssid.toByteArray(Charsets.UTF_8))
            .setPassword(password.toByteArray(Charsets.UTF_8))
            .build()

        provisioner.startProvisioning(request, object : EspProvisioningListener {
            override fun onStart() {
                Log.i(TAG, "onProvisioningStart")
                sendEventToFlutter("onProvisioningStart", null)
            }

            override fun onResponse(result: EspProvisioningResult) {
                Log.i(TAG, "onProvisoningScanResult")
                val address = result.address.hostAddress
                val bssid = result.bssid
                sendEventToFlutter("onProvisoningScanResult", "address: $address, bssid: $bssid")
            }

            override fun onStop() {
                Log.i(TAG, "Provisioning stopped")
                sendEventToFlutter("onProvisioningStop", null)
            }

            override fun onError(exception: Exception) {
                Log.e(TAG, "Provisioning error: ${exception.message}", exception)
                sendEventToFlutter("onProvisioningError", exception.message)
            }
        })
    }

    private fun startSync() {
        provisioner.startSync(object : EspSyncListener {
            override fun onStart() {
                Log.i(TAG, "Sync started")
                sendEventToFlutter("onSyncStart", null)
            }

            override fun onStop() {
                Log.i(TAG, "Sync stopped")
                sendEventToFlutter("onSyncStop", null)
            }

            override fun onError(exception: Exception) {
                Log.e(TAG, "Sync error: ${exception.message}", exception)
                sendEventToFlutter("onSyncError", exception.message)
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

    private fun sendEventToFlutter(event: String, message: String?) {
        val eventMap = mutableMapOf<String, String>()
        eventMap["event"] = event
        if (message != null) {
            eventMap["message"] = message
        }
        methodChannel.invokeMethod("onEvent", eventMap)
    }

    override fun onDestroy() {
        super.onDestroy()
        provisioner.close()
    }
}