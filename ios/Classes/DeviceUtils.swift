import UIKit

public extension UIDevice{

    public enum Unit: Double {
            // For going from byte to -
            case byte = 1
            case kilobyte = 1024
            case megabyte = 1048576
            case gigabyte = 1073741824
        }
    /// pares the device name as the standard name
        var modelName: String {

            #if targetEnvironment(simulator)
                let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
            #else
                var systemInfo = utsname()
                uname(&systemInfo)
                let machineMirror = Mirror(reflecting: systemInfo.machine)
                let identifier = machineMirror.children.reduce("") { identifier, element in
                    guard let value = element.value as? Int8, value != 0 else { return identifier }
                    return identifier + String(UnicodeScalar(UInt8(value)))
                }
            #endif

            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPhone13,1":                              return "iPhone 12 mini"
            case "iPhone13,2":                              return "iPhone 12"
            case "iPhone13,3":                              return "iPhone 12 Pro"
            case "iPhone13,4":                              return "iPhone 12 Pro Max"
            case "iPhone14,1":                              return "iPhone 13 mini"
            case "iPhone14,2":                              return "iPhone 13"
            case "iPhone14,3":                              return "iPhone 13 Pro"
            case "iPhone14,4":                              return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            default:                                        return identifier
            }
        }

     func getCPUName() -> String
        {
            let processorNames = Array(CPUinfo().keys)
            return processorNames[0]
        }

    private func CPUinfo() -> Dictionary<String, String> {
        #if targetEnvironment(simulator)
        let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else

        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        #endif

         switch identifier {
    //        iphone
            case "iPod5,1":                                 return ["A5":"800 MHz"]
            case "iPod7,1":                                 return ["A8":"1.4 GHz"]
            case "iPod9,1":                                 return ["A10":"1.63 GHz"]
    //            iphone
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return ["A4":"800 MHz"]
            case "iPhone4,1":                               return ["A5":"800 MHz"]
            case "iPhone5,1", "iPhone5,2":                  return ["A6":"1.3 GHz"]
            case "iPhone5,3", "iPhone5,4":                  return ["A6":"1.3 GHz"]
            case "iPhone6,1", "iPhone6,2":                  return ["A7":"1.3 GHz"]
            case "iPhone7,2":                               return ["A8":"1.4 GHz"]
            case "iPhone7,1":                               return ["A8":"1.4 GHz"]
            case "iPhone8,1":                               return ["A9":"1.85 GHz"]
            case "iPhone8,2":                               return ["A9":"1.85 GHz"]
            case "iPhone9,1", "iPhone9,3":                  return ["A10":"2.34 GHz"]
            case "iPhone9,2", "iPhone9,4":                  return ["A10":"2.34 GHz"]
            case "iPhone8,4":                               return ["A9":"1.85 GHz"]
            case "iPhone10,1", "iPhone10,4":                return ["A11":"2.39 GHz"]
            case "iPhone10,2", "iPhone10,5":                return ["A11":"2.39 GHz"]
            case "iPhone10,3", "iPhone10,6":                return ["A11":"2.39 GHz"]
            case "iPhone11,2", "iPhone11,4",
                 "iPhone11,6",  "iPhone11,8":               return ["A12":"2.5 GHz"]
            case "iPhone12,1","iPhone12,3"
                 ,"iPhone12,5":                             return ["A13":"2650 GHz"]
            case "iPhone12,8":                              return ["A13":"2.65 GHz"]
            case "iPhone13,2","iPhone13,1","iPhone13,3":    return ["A14":"2.99 GHz"]
            case "iPhone13,4":                              return ["A14":"3.1 GHz"]
            case "iPhone14,2","iPhone14,1","iPhone14,3":    return ["A15":"2.2 GHz"]
            case "iPhone14,4":                              return ["A15":"3.23 GHz"]
    //            ipad
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return ["A5":"1.0 GHz"]
            case "iPad3,1", "iPad3,2", "iPad3,3":           return ["A5X":"1.0 GHz"]
            case "iPad3,4", "iPad3,5", "iPad3,6":           return ["A6X":"1.4 GHz"]
            case "iPad4,1", "iPad4,2", "iPad4,3":           return ["A7":"1.4 GHz"]
            case "iPad5,3", "iPad5,4":                      return ["A8X":"1.5 GHz"]
            case "iPad6,11", "iPad6,12":                    return ["A9":"1.85 GHz"]
            case "iPad2,5", "iPad2,6", "iPad2,7":           return ["A5":"1.0 GHz"]
            case "iPad4,4", "iPad4,5", "iPad4,6":           return ["A7":"1.3 GHz"]
            case "iPad4,7", "iPad4,8", "iPad4,9":           return ["A7":"1.3 GHz"]
            case "iPad5,1", "iPad5,2":                      return ["A8":"1.5 GHz"]
            case "iPad6,3", "iPad6,4":                      return ["A9X":"2.16 GHz"]
            case "iPad6,7", "iPad6,8":                      return ["A9X":"2.24 GHz"]
            case "iPad7,1", "iPad7,2",
                 "iPad7,3", "iPad7,4":                      return ["A10X":"2.34 GHz"]
            case "iPad8,1", "iPad8,2",
                 "iPad8,3", "iPad8,4":                      return ["A12X":"2.5 GHz"]
            case "iPad8,5", "iPad8,6",
                 "iPad8,7", "iPad8,8",
                 "iPad8,9", "iPad8,10",
                 "iPad8,11", "iPad8,12":                    return ["A12Z":"2.5 GHz"]

            default:                                        return ["N/A":"N/A"]
            }
        }

    fileprivate static func getHostBasicInfo() -> host_basic_info? {
        let host_port: host_t = mach_host_self()

        var size: mach_msg_type_number_t =
            UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)

        var returnedData = host_basic_info.init()

        let status = withUnsafeMutablePointer(to: &returnedData) {
            (p: UnsafeMutablePointer<host_basic_info>) -> Bool in p.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                (pp: UnsafeMutablePointer<integer_t>) -> Bool in
                let retvalue = host_info(host_port, HOST_BASIC_INFO, pp, &size)

                return retvalue == KERN_SUCCESS
            }
        }
        return status ? returnedData : nil
    }

    /// Wraps `host_statistics64`, and provides info on virtual memory
    ///
    /// - Returns: a `vm_statistics64`, or nil if the kernel reported an error
    ///
    /// Relevant: https://opensource.apple.com/source/xnu/xnu-3789.51.2/osfmk/mach/vm_statistics.h.auto.html
    fileprivate static func getVMStatistics64() -> vm_statistics64? {
        // the port number of the host (the current machine)  http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/mach_host_self.html
        let host_port: host_t = mach_host_self()

        // size of a vm_statistics_data in integer_t's
        var host_size = mach_msg_type_number_t(UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size))

        var returnData = vm_statistics64.init()
        let succeeded = withUnsafeMutablePointer(to: &returnData) {
            (p: UnsafeMutablePointer<vm_statistics64>) -> Bool in

            // host_statistics64() gives us a vm_statistics64 value, but it
            // returns this via an out pointer of type integer_t, so we need to rebind our
            // UnsafeMutablePointer<vm_statistics64> in order to use the function
            p.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                (pp: UnsafeMutablePointer<integer_t>) -> Bool in

                let retvalue = host_statistics64(host_port, HOST_VM_INFO64,
                                                 pp, &host_size)
                return retvalue == KERN_SUCCESS
            }
        }

        return succeeded ? returnData : nil
    }

    /// Wrapper for `host_page_size`
    ///
    /// - Returns: system's virtual page size, in bytes
    ///
    /// Reference: http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/host_page_size.html
    fileprivate static func getPageSize() -> UInt {
        // the port number of the host (the current machine)  http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/mach_host_self.html
        let host_port: host_t = mach_host_self()
        // the page size of the host, in bytes http://web.mit.edu/darwin/src/modules/xnu/osfmk/man/host_page_size.html
        var pagesize: vm_size_t = 0
        host_page_size(host_port, &pagesize)
        // assert: pagesize is initialized
        return UInt(pagesize)
    }

    /// Size of physical memory on this machine
    public static func physicalMemory(_ unit: Unit = .megabyte) -> Double {
        if let basicInfo = getHostBasicInfo() {
            return (Double(basicInfo.max_mem)) / unit.rawValue
        }
        return 0
    }

    public static func memoryUsage(_ unit: Unit = .megabyte) -> (free: Double, active: Double, inactive: Double, wired: Double, compressed: Double)
    {
        guard let stats = getVMStatistics64() else {
            return (0, 0, 0, 0, 0)
        }

        let pageSizeBytes = Double(getPageSize())

        let free = Double(stats.free_count) * pageSizeBytes / unit.rawValue

        let active = Double(stats.active_count) * pageSizeBytes / unit.rawValue

        let inactive = Double(stats.inactive_count) * pageSizeBytes / unit.rawValue
        let wired = Double(stats.wire_count) * pageSizeBytes / unit.rawValue

        // Result of the compression. This is what you see in Activity Monitor
        let compressed = Double(stats.compressor_page_count) * pageSizeBytes / unit.rawValue

        return (free, active, inactive, wired, compressed)
    }

    public static func memoryUsedByApp(_ unit: Unit = .megabyte) -> Double {
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard
            kr == KERN_SUCCESS,
            count >= TASK_VM_INFO_REV1_COUNT
        else { return 0 }

        return Double(info.phys_footprint) / unit.rawValue
    }

    public static func diskTotalSpace(_ unit: Unit = .megabyte) -> Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space / Int64(unit.rawValue)
    }

    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    public static func diskFreeSpace(_ unit: Unit = .megabyte) -> Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space / Int64(unit.rawValue)
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
            {
                return freeSpace / Int64(unit.rawValue)
            } else {
                return 0
            }
        }
    }

    public static func diskUsedSpace(_ unit: Unit = .megabyte) -> Int64 {
        return (diskTotalSpace() - diskFreeSpace()) / Int64(unit.rawValue)
    }

    struct Platform {
        static let isSimulator: Bool = {
            var isSim = false
            #if arch(i386) || arch(x86_64)
                isSim = true
            #endif
            return isSim
        }()
    }

}
