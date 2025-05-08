package com.motionsoft.amar_pos

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.motionsoft.amar_pos/openfile"
    private val APP_VERSION_INFO = "com.motionsoft.amar_pos/app_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "openFile") {
                val filePath = call.argument<String>("filePath")
                if (!filePath.isNullOrEmpty()) {
                    try {
                        openFile(filePath)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to open file: ${e.localizedMessage}", null)
                    }
                } else {
                    result.error("UNAVAILABLE", "File path not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_VERSION_INFO).setMethodCallHandler { call, result ->
            try {
                val packageInfo = packageManager.getPackageInfo(packageName, 0)
                when (call.method) {
                    "getAppVersion" -> result.success(packageInfo.versionName)
                    "getBuildNumber" -> {
                        val buildNumber = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                            packageInfo.longVersionCode.toString()
                        } else {
                            @Suppress("DEPRECATION")
                            packageInfo.versionCode.toString()
                        }
                        result.success(buildNumber)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("UNAVAILABLE", "App info not available: ${e.localizedMessage}", null)
            }
        }
    }

    private fun openFile(filePath: String) {
        val file = File(filePath)
        if (!file.exists()) throw IllegalArgumentException("File does not exist at path: $filePath")

        val uri: Uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", file)
        val mimeType: String? = contentResolver.getType(uri) ?: "*/*"

        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, mimeType)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        // Validate if there is an app to handle the intent
        if (intent.resolveActivity(packageManager) != null) {
            startActivity(intent)
        } else {
            throw UnsupportedOperationException("No app found to open this file type")
        }
    }
}
