package com.droppingride.driver

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Point
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.math.ceil
import kotlin.random.Random

val NOTIFICATION_ID = Random.nextInt(0, 10000)

class MainActivity : FlutterActivity() {

    private lateinit var channel: MethodChannel
    private var density: Float = 0.0f
    private var screenHeightLP: Double? = 0.0
    private var navigationBarHeight: Double = 0.0
    private var screenWidth: Int = 0
    private var chatHeadIcon: String? = ""
    private var notificationIcon: String? = ""
    private var notificationTitle: String? = ""
    private var notificationBody: String? = ""
    private var notificationCircleHexColor: Long? = 0
    private var serviceStarted: Boolean = false

    private var ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 1237

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        channel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "package name here")
        channel.setMethodCallHandler(object : MethodCallHandler {
            @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
            override fun onMethodCall(call: MethodCall, result: Result) {
                when (call.method) {
                    "initService" -> {
                        stopChatHeadService()
                        density = resources.displayMetrics.density
                        screenHeightLP = call.argument("screenHeight")
                        chatHeadIcon = call.argument("chatHeadIcon")
                        notificationIcon = call.argument("notificationIcon")
                        notificationTitle = call.argument("notificationTitle")
                        notificationBody = call.argument("notificationBody")
                        notificationCircleHexColor = call.argument("notificationCircleHexColor")
                        screenWidth = resources.displayMetrics.widthPixels
                        if (screenHeightLP == null) {
                            result.error("INVALID", "Screen height is null", null)
                            return
                        }
                        navigationBarHeight = ceil(getRealScreenHeight() / density.toDouble() - screenHeightLP!!.toDouble())

                        println("[FROM ANDROID NATIVE SIDE]=> screenHeight $screenHeightLP, screenWidth $screenWidth, density $density, navigationBarHeight $navigationBarHeight")
                        serviceStarted = true
                        result.success(true)
                    }
                    "startService" -> {
                        if (!serviceStarted) {
                            result.error("INVALID", "You MUST initialize the service first :D", null)
                            return
                        }
                        val newNotificationTitle: String? = call.argument("notificationTitle")

                        if (checkPermission()) {
                            if (newNotificationTitle != null) {
                                notificationTitle = newNotificationTitle
                            }

                            navigationBarHeight = ceil(getRealScreenHeight() / density.toDouble() - screenHeightLP!!.toDouble())
                            stopChatHeadService()
                            if (screenHeightLP == null) {
                                result.error("INVALID", "Screen height is null", null)
                                return
                            }
                            startChatHeadService()
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    }
                    "checkPermission" -> {
                        val hasPermission = checkPermission()
                        result.success(hasPermission)
                    }
                    "askPermission" -> {
                        val askedForPermission = askPermission()
                        Toast.makeText(applicationContext, "Allow display over other apps permission first", Toast.LENGTH_SHORT).show()
                        result.success(askedForPermission)
                    }
                    "stopService" -> {
                        if (!serviceStarted) {
                            result.error("INVALID", "You MUST initialize the service first :D", null)
                            return
                        }
                        cancelNotification()
                        stopChatHeadService()
                        result.success(true)
                    }
                    "clearServiceNotification" -> {
                        cancelNotification()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
        })
    }

    private fun cancelNotification() {
        NotificationManagerCompat.from(applicationContext).cancel(NOTIFICATION_ID)
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun checkPermission(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            Settings.canDrawOverlays(applicationContext)
        } else {
            false
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun askPermission(): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(applicationContext)) {
                val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION, Uri.parse("package:" + packageName))
                startActivityForResult(intent, ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE)
            } else {
                return true
            }
        }
        return false
    }

    private fun stopChatHeadService() {
        try {
            val intent = Intent(applicationContext, ChatHeadService::class.java)
            stopService(intent)
            println("ChatHeadService stopped successfully.")
        } catch (e: Exception) {
            e.printStackTrace()
            println("Error stopping ChatHeadService: ${e.localizedMessage}")
        }
    }

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun startChatHeadService() {
        val i = Intent(applicationContext, ChatHeadService::class.java)
        i.putExtra("height", getRealScreenHeight())
        i.putExtra("width", screenWidth.toDouble())
        i.putExtra("density", density.toDouble())
        i.putExtra("navigationBarHeight", navigationBarHeight)
        i.putExtra("chatHeadIcon", chatHeadIcon)
        i.putExtra("notificationIcon", notificationIcon)
        i.putExtra("notificationTitle", notificationTitle)
        i.putExtra("notificationBody", notificationBody)
        i.putExtra("notificationCircleHexColor", notificationCircleHexColor)
        i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        i.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        applicationContext.startService(i)
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    private fun getRealScreenHeight(): Double {
        val windowManager = applicationContext.getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = windowManager.defaultDisplay
        val screenResolution = Point()

        display.getRealSize(screenResolution)

        return screenResolution.y.toDouble()
    }
}
