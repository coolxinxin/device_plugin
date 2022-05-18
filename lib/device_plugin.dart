import 'dart:async';

import 'package:flutter/services.dart';

class DevicePlugin {
  static const MethodChannel _channel = MethodChannel('device_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void init() async {
    await _channel.invokeListMethod("init");
  }

  static Future<List<AppList>> getAppList() async {
    Iterable appLists =
        (await _channel.invokeListMethod("getAppList")) as Iterable;
    return appLists.map((m) => AppList.fromMap(m)).toList();
  }

  static Future<Map?> getDevice() async {
    return await _channel.invokeMapMethod("getDevice");
  }
}

class AppList {
  String? firstTime, lastTime, name, packageName, versionCode, systemApp;

  AppList(
      {this.firstTime,
        this.lastTime,
        this.name,
        this.packageName,
        this.versionCode,
        this.systemApp});

  AppList.fromMap(Map m) {
    firstTime = m["firstTime"];
    lastTime = m["lastTime"];
    name = m["name"];
    packageName = m["packageName"];
    versionCode = m["versionCode"];
    systemApp = m["systemApp"];
  }
}
