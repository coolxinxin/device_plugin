# device_plugin

### 使用

```
flutter pub add device_plugin
```
```
dependencies:
  device_plugin: any
```

### 一个获取设备信息的flutter插件,支持获取Android设备信息和App列表 适配Android10以上 [Android具体实现](https://github.com/coolxinxin/device_plugin/blob/master/android/src/main/kotlin/com/leos/device_plugin/DeviceUtils.kt)

### iOS 适配至iPhone13 [iOS具体实现](https://github.com/coolxinxin/device_plugin/blob/master/ios/Classes/DeviceUtils.swift)

#### 使用示例
```
  _getDevice() async {
    DevicePlugin.init();
    if (Platform.isAndroid) {
      DevicePlugin.getAppList().then((value) {
        for (var element in value) {
          var firstTime = element.firstTime ?? "";
          var lastTime = element.lastTime ?? "";
          var name = element.name ?? "";
          var packageName = element.packageName ?? "";
          var versionCode = element.versionCode ?? "";
          var systemApp = element.systemApp ?? "";
          debugPrint("firstTime:" + firstTime);
          debugPrint("lastTime:" + lastTime);
          debugPrint("name:" + name);
          debugPrint("packageName:" + packageName);
          debugPrint("versionCode:" + versionCode);
          debugPrint("systemApp:" + systemApp);
        }
      });
    }
    DevicePlugin.getPower().then((value) => _refresh(power, value));
    DevicePlugin.getBrands().then((value) => _refresh(barnds, value));
    DevicePlugin.getModel().then((value) => _refresh(model, value));
    DevicePlugin.getCpuModel().then((value) => _refresh(cpuModel, value));
    DevicePlugin.getCpuCores().then((value) => _refresh(cpuCores, value));
    DevicePlugin.isEmulator().then((value) => _refresh(isEmulator, value));
    DevicePlugin.getMemory().then((value) => _refresh(memory, value));
    DevicePlugin.getSpace().then((value) => _refresh(space, value));
    Map? device = await DevicePlugin.getDevice();
    device?.forEach((key, value) {
      debugPrint("key:" + key);
      debugPrint("value:" + value.toString());
    });
  }
  
  void _refresh(newValue, oldValue) {
    setState(() {
      newValue = oldValue;
    });
  }
```

