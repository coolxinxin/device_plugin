# device_plugin

A new Device Flutter plugin

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### 一个获取设备信息的flutter插件,支持获取Android设备信息和App列表 适配Android10以上 [Android具体实现](https://github.com/coolxinxin/device_plugin/blob/master/android/src/main/kotlin/com/leos/device_plugin/DeviceUtils.kt)

```
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
```
### iOS 适配至iPhone13 [iOS具体实现](https://github.com/coolxinxin/device_plugin/blob/master/ios/Classes/DeviceUtils.swift)
```
result([
                "brands":"Apple",
                "mobile_model":UIDevice.current.modelName,
                "cpu_model":UIDevice.current.getCPUName(),
                "cpu_cores":"6",
                "freeMem":UIDevice.memoryUsage().free,
                "totalMem":UIDevice.physicalMemory(),
                "freeSpace":UIDevice.diskFreeSpace(),
                "totalSpace":UIDevice.diskTotalSpace(),
                "open_power":self.batteryLevel,
                "open_time":self.openTime,
                "version":UIDevice.current.systemVersion,
                "complete_apply_power":battery(),
                "complete_apply_time":currentTime(),
                "back_num":"0",
                "real_machine":UIDevice.Platform.isSimulator,
                "resolution":screen()
            ])
```

