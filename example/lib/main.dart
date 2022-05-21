import 'dart:async';
import 'dart:io';

import 'package:device_plugin/device_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String? power;
  String? barnds;
  String? model;
  String? cpuModel;
  String? cpuCores;
  bool? isEmulator;
  Memory? memory;
  Space? space;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _getDevice();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await DevicePlugin.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(_platformVersion)),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(power ?? "")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(barnds ?? "")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(model ?? "")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(cpuModel ?? "")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(cpuCores ?? "")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(isEmulator == true
                      ? "is an emulator"
                      : "not an emulator")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                      "${memory?.freeMemory.toString() ?? ""}/${memory?.totalMemory.toString() ?? ""}")),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                      "${space?.freeSpace.toString() ?? ""}/${space?.totalSpace.toString() ?? ""}")),
            ],
          ),
        ),
      ),
    );
  }

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
}
