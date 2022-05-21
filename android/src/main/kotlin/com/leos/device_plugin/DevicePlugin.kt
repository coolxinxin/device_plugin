package com.leos.device_plugin

import android.app.Activity
import android.os.Build
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DevicePlugin */
class DevicePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_plugin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
            "init" -> {
                init()
                result.success("init")
            }
            "getPower" -> result.success(activity?.let { DeviceUtils.getBatteryLevel(it).toString() })
            "getBrands" -> result.success(DeviceUtils.getBrands())
            "getModel" -> result.success(DeviceUtils.getMobilModel())
            "getCpuModel" -> result.success(DeviceUtils.getCpuModel())
            "getCpuCores" -> result.success(DeviceUtils.getCpuCores())
            "isEmulator" -> result.success(activity?.let { DeviceUtils.isEmulator(it) })
            "getMemory" -> result.success(activity?.let { DeviceUtils.getMemory(it) })
            "getSpace" -> result.success(DeviceUtils.getSpace())
            "getAppList" -> result.success(DeviceUtils.getAppList(activity))
            "getDevice" -> getDevices(result)
            else -> result.notImplemented()
        }
    }

    private fun init() {
        DeviceUtils.openAppBatteryLevel = activity?.let { DeviceUtils.getBatteryLevel(it) }
        DeviceUtils.openAppTime = DeviceUtils.getCurrentTime()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun getDevices(result: Result) {
        val hashMap = HashMap<String, Any?>()
        hashMap["brands"] = DeviceUtils.getBrands()
        hashMap["mobile_model"] = DeviceUtils.getMobilModel()
        hashMap["cpu_model"] = DeviceUtils.getCpuModel()
        hashMap["cpu_cores"] = DeviceUtils.getCpuCores()
        hashMap["ram"] = activity?.let { DeviceUtils.getRAMInfo(it) }
        hashMap["rom"] = activity?.let { DeviceUtils.getRomInfo(it) }
        hashMap["resolution"] = activity?.let { DeviceUtils.getResolution(it) }
        hashMap["open_power"] = activity?.let { DeviceUtils.openAppBatteryLevel?.toString() }
        hashMap["open_time"] = activity?.let { DeviceUtils.openAppTime }
        hashMap["version"] = DeviceUtils.getSystemVersion()
        hashMap["complete_apply_power"] =
            activity?.let { DeviceUtils.getBatteryLevel(it).toString() }
        hashMap["complete_apply_time"] = DeviceUtils.formatTime(System.currentTimeMillis())
        hashMap["back_num"] = "0"
        hashMap["root"] = DeviceUtils.isSuEnableRoot().toString()
        hashMap["wifi_name"] = activity?.let { DeviceUtils.getWifiName(it) }
        hashMap["wifi_mac"] = DeviceUtils.getWifiMacAddress()
        hashMap["wifi_state"] = activity?.let { DeviceUtils.getWifiState(it) }
        hashMap["real_machine"] = activity?.let { DeviceUtils.isEmulator(it) }
        hashMap["hit_num"] = "0"
        result.success(hashMap)
    }
}
