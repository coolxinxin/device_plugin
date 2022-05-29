@file:Suppress("DEPRECATION")

package com.leos.device_plugin

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.net.wifi.WifiManager
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.StatFs
import android.telephony.TelephonyManager
import android.text.format.Formatter
import android.util.DisplayMetrics
import android.util.Log
import android.view.WindowManager
import java.io.File
import java.io.FileFilter
import java.net.NetworkInterface
import java.text.SimpleDateFormat
import java.util.*

/**
 * @author: Leo
 * @time: 2022/5/10
 * @desc:
 */
@SuppressLint("SimpleDateFormat")
object DeviceUtils {

    /**
     * 获取设备品牌
     *
     * @return
     */
    fun getBrands(): String = Build.BRAND

    /**
     * 获取手机型号
     *
     * @return
     */
    fun getMobilModel(): String = Build.MODEL

    /**
     * CPU型号
     *
     * @return
     */
    fun getCpuModel(): String = Build.CPU_ABI


    /**
     * 获取当前手机系统版本号
     */
    fun getSystemVersion(): String = Build.VERSION.RELEASE

    /**
     * 屏幕分辨率
     * @return
     */
    fun getResolution(context: Context): String {
        val metric = DisplayMetrics()
        val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            windowManager.defaultDisplay.getRealMetrics(metric)
        }
        val width = metric.widthPixels
        val height = metric.heightPixels
        val densityDpi = metric.densityDpi
        return "$width×$height -$densityDpi"
    }

    /**
     * 获取wifi名称
     */
    fun getWifiName(context: Context): String {
        var ssid = ""
        try {
            val wifiMgr =
                context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val info = wifiMgr.connectionInfo
            val networkId = info.networkId
            val configuredNetworks = wifiMgr.configuredNetworks
            run breaking@{
                configuredNetworks.forEach {
                    if (it.networkId == networkId) {
                        ssid = it.SSID
                        return@breaking
                    }
                }
            }
            if (ssid.contains("\"")) {
                ssid = ssid.replace("\"", "")
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ssid
    }

    /**
     * 获取wifi mac 地址
     */
    fun getWifiMacAddress(): String {
        try {
            val networkInterfaces = NetworkInterface.getNetworkInterfaces()
            while (networkInterfaces.hasMoreElements()) {
                val element = networkInterfaces.nextElement()
                val address = element?.hardwareAddress ?: continue
                if (element.name == "wlan0") {
                    val builder = StringBuilder()
                    address.forEach {
                        builder.append(String.format("%02X:", it))
                    }
                    if (builder.isNotEmpty()) {
                        builder.deleteCharAt(builder.length - 1)
                    }
                    return builder.toString()
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return ""
    }

    /**
     * 获取wifi信号强度 state
     */
    fun getWifiState(context: Context): String {
        return try {
            val wifiMgr =
                context.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
            val info = wifiMgr.connectionInfo
            if (info.ssid != null) {
                val strength = WifiManager.calculateSignalLevel(info.rssi, 5)
                strength.toString()
            } else {
                ""
            }
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }


    /**
     * 打开App电量
     * @return [Int] 电量
     */
    var openAppBatteryLevel: Int? = 0

    /**
     * 获取电量
     * @return [Int] 电量
     */
    fun getBatteryLevel(context: Context): Int {
        val intent = ContextWrapper(context).registerReceiver(
            null,
            IntentFilter(Intent.ACTION_BATTERY_CHANGED)
        )
        return if (intent == null) {
            -1
        } else {
            intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
    }

    /**
     * 获取开启App时间
     */
    var openAppTime: String = ""


    fun formatTime(date: Date, format: String = "yyyy-MM-dd HH:mm:ss"): String =
        SimpleDateFormat(format).format(date)

    fun formatTime(time: Long, format: String = "yyyy-MM-dd HH:mm:ss"): String =
        SimpleDateFormat(format).format(time)

    /**
     * 获取当前时间
     */
    fun getCurrentTime(): String = formatTime(System.currentTimeMillis())


    /**
     * 获取RAM
     */
    fun getRAMInfo(context: Context): String {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        manager.getMemoryInfo(memoryInfo)
        val totalSize = memoryInfo.totalMem
        val availableSize = memoryInfo.availMem
        return (Formatter.formatFileSize(context, availableSize) + "/"
                + Formatter.formatFileSize(context, totalSize))
    }


    fun getMemory(context: Context): HashMap<String, Long> {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        manager.getMemoryInfo(memoryInfo)
        val totalMemory = memoryInfo.totalMem
        val freeMemory = memoryInfo.availMem
        val hashMap = HashMap<String, Long>()
        hashMap["freeMemory"] = freeMemory
        hashMap["totalMemory"] = totalMemory
        return hashMap
    }

    fun getSpace(): HashMap<String, Long> {
        val file = Environment.getExternalStorageDirectory()
        val statFs = StatFs(file.path)
        val blockSizeLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.blockSizeLong
        } else {
            statFs.blockSize.toLong()
        }
        val blockCountLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.blockCountLong
        } else {
            statFs.blockCount.toLong()
        }
        val availableBlocksLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.availableBlocksLong
        } else {
            statFs.availableBlocks.toLong()
        }
        val hashMap = HashMap<String, Long>()
        hashMap["freeSpace"] = availableBlocksLong * blockSizeLong
        hashMap["totalSpace"] = blockCountLong * blockSizeLong
        return hashMap
    }

    /**
     * 获取Rom
     *
     * @return
     */
    fun getRomInfo(context: Context): String {
        val file = Environment.getExternalStorageDirectory()
        val statFs = StatFs(file.path)
        val blockSizeLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.blockSizeLong
        } else {
            statFs.blockSize.toLong()
        }
        val blockCountLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.blockCountLong
        } else {
            statFs.blockCount.toLong()
        }
        val availableBlocksLong = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR2) {
            statFs.availableBlocksLong
        } else {
            statFs.availableBlocks.toLong()
        }
        return Formatter.formatFileSize(context, availableBlocksLong * blockSizeLong) + "/" +
                Formatter.formatFileSize(context, blockCountLong * blockSizeLong)
    }

    /**
     * CPU核数
     *
     * @return
     */
    fun getCpuCores(): String {
        val count = getNumberOfCPUCores()
        return count.toString() + ""
    }

    private fun getNumberOfCPUCores(): Int {
        return try {
            File("/sys/devices/system/cpu/").listFiles(CPU_FILTER)?.size ?: 0
        } catch (e: SecurityException) {
            0
        }
    }

    private val CPU_FILTER = FileFilter { pathname ->
        val path = pathname.name
        if (path.startsWith("cpu")) {
            for (i in 3 until path.length) {
                if (path[i] < '0' || path[i] > '9') {
                    return@FileFilter false
                }
            }
            return@FileFilter true
        }
        false
    }


    /**
     * 是否root或是否实体
     * 1是root机和虚拟机
     * 0是非root机和实体机
     */
    fun isSuEnableRoot(): Int {
        var file: File?
        val paths = arrayOf(
            "/system/bin/",
            "/system/xbin/",
            "/system/sbin/",
            "/sbin/",
            "/vendor/bin/",
            "/su/bin/"
        )
        try {
            for (path in paths) {
                file = File(path + "su")
                if (file.exists() && file.canExecute()) {
                    Log.i("TAG", "find su in : $path")
                    return 1
                }
            }
        } catch (x: Exception) {
            x.printStackTrace()
        }
        return 0
    }

    /**
     * 判断是否为模拟器
     */
    fun isEmulator(context: Context): Boolean {
        val checkProperty = (Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.toLowerCase(Locale.ROOT).contains("vbox")
                || Build.FINGERPRINT.toLowerCase(Locale.ROOT).contains("test-keys")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic")
                || "google_sdk" == Build.PRODUCT)
        if (checkProperty) return true
        val tm = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        val name = tm.networkOperatorName
        val checkOperatorName = name.toLowerCase(Locale.ROOT) == "android"
        if (checkOperatorName) return true
        val url = "tel:" + "123456"
        val intent = Intent()
        intent.data = Uri.parse(url)
        intent.action = Intent.ACTION_DIAL
        return intent.resolveActivity(context.packageManager) == null
    }

    /**
     * 判断是否是系统软件
     */
    fun isSystemApp(pInfo: PackageInfo): Boolean {
        return pInfo.applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM != 0
    }

    /**
     * 获取设备应用安装列表
     */
    fun getAppList(context: Context?): List<HashMap<String, Any?>> {
        val mapList = ArrayList<HashMap<String, Any?>>()
        context ?: return mapList
        val pm = context.packageManager
        val list = pm.getInstalledPackages(PackageManager.GET_UNINSTALLED_PACKAGES)
        for (packageInfo in list) {
            val appName = packageInfo.applicationInfo.loadLabel(context.packageManager).toString()
            val packageName = packageInfo.packageName
            val isSYS = isSystemApp(packageInfo)
            if (appName.isNotEmpty() && packageName.isNotEmpty()) {
                val map = HashMap<String, Any?>()
                map["firstTime"] = formatTime(packageInfo.firstInstallTime)
                map["lastTime"] = formatTime(packageInfo.lastUpdateTime)
                map["name"] = appName
                map["packageName"] = packageName
                map["versionCode"] = packageInfo.versionName
                map["systemApp"] = if (isSYS) "1" else "2"
                mapList.add(map)
            }
        }
        return mapList
    }

}