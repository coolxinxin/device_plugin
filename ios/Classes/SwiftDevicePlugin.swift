import Flutter
import UIKit
import Foundation

public class SwiftDevicePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "device_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftDevicePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    var openTime = ""
    var batteryLevel = ""

  func currentTime() -> String {
      let dateformatter = DateFormatter()
      dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"// 自定义时间格式
      return dateformatter.string(from: Date())
  }

  func battery() -> String {
      //开启isBatteryMonitoringEnabled
      UIDevice.current.isBatteryMonitoringEnabled = true
      //获得电量（返回的是Float格式，范围是0-1，这里乘以100并且转换成整数形式）
      let batterylevel = Int(UIDevice.current.batteryLevel * 100)
      //将电量作为返回值
      return String(batterylevel)
  }

  func screen() -> String{
    let screenBounds:CGRect = UIScreen.main.bounds
      let w = screenBounds.width
      let h = screenBounds.height
    return "\(w)\("x")\(h)"
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method.elementsEqual("getPlatformVersion")){
           result("iOS " + UIDevice.current.systemVersion)
       }else if(call.method.elementsEqual("init")){
           self.openTime = currentTime()
           self.batteryLevel = battery()
       }
       else if(call.method.elementsEqual("getDevice")){
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
       }

  }

}
