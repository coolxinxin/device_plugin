import 'dart:async';

import 'package:flutter/services.dart';

class DevicePlugin {
  static const MethodChannel _channel = MethodChannel('device_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void init() async {
    await _channel.invokeMethod("init");
  }

  /// only Android
  static Future<List<AppList>> getAppList() async {
    Iterable appLists =
        (await _channel.invokeListMethod("getAppList")) as Iterable;
    return appLists.map((m) => AppList.fromMap(m)).toList();
  }

  static Future<Map?> getDevice() async {
    return await _channel.invokeMapMethod("getDevice");
  }

  static Future<String> getPower() async {
    return await _channel.invokeMethod("getPower");
  }

  static Future<String> getBrands() async {
    return await _channel.invokeMethod("getBrands");
  }

  static Future<String> getModel() async {
    return await _channel.invokeMethod("getModel");
  }

  static Future<String> getCpuModel() async {
    return await _channel.invokeMethod("getCpuModel");
  }

  static Future<String> getCpuCores() async {
    return await _channel.invokeMethod("getCpuCores");
  }

  static Future<bool> isEmulator() async {
    return await _channel.invokeMethod("isEmulator");
  }

  static Future<Memory?> getMemory() async {
    return Memory.fromMap(await _channel.invokeMapMethod("getMemory"));
  }

  static Future<Space?> getSpace() async {
    return Space.fromMap(await _channel.invokeMapMethod("getSpace"));
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

class Memory {
  num? freeMemory, totalMemory;

  Memory.fromMap(Map? m) {
    freeMemory = m?["freeMemory"];
    totalMemory = m?["totalMemory"];
  }
}

class Space {
  num? freeSpace, totalSpace;

  Space.fromMap(Map? m) {
    freeSpace = m?["freeSpace"];
    totalSpace = m?["totalSpace"];
  }
}
