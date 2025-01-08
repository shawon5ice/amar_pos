import 'dart:io';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

import '../../constants/logger/logger.dart';


class FileDownloader {
  final Dio _dio = Dio();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String _channelId = 'basicNotification';

  FileDownloader() {
    _initializeNotifications();
  }

  Future<void> downloadFile(
      {required String url, required String fileName, String? token, required BuildContext context}) async {
    try {
      // Request necessary permissions
      await _requestPermissions();

      final directory = await _getDownloadDirectory();
      logger.e(directory);
      logger.e(token);
      final filePath = path.join(directory.path, fileName);

      logger.i(url);
      RandomLottieLoader().show(context);
      await _dio.download(
        url,
        filePath,
        options: token != null
            ? Options(headers: {
                'Authorization': 'Bearer $token',
                Headers.contentTypeHeader : 'multipart/form-data',
                // Headers.contentTypeHeader : fileName.contains('.pdf')? 'application/pdf' : 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
              })
            : null,
      );

      // Methods.hideLoading();

      await _showNotification(filePath, fileName);
    } catch (e) {
      RandomLottieLoader().hide(context);
      // Methods.hideLoading();
      print("Download failed: $e");
    }finally{
      // Methods.hideLoading();
      RandomLottieLoader().hide(context);
    }
  }

  Future<void> _initializeNotifications() async {
    const initializationSettingsAndroid =
    AndroidInitializationSettings('hrm_notification');
    const initializationSettingsDarwin = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // Initialize notifications
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        _handleNotificationTap(notificationResponse.payload);
      },
    );

    // Request notification permission
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request notification permission
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted) {
      // Permission granted, continue normal app flow
      print("Notification permission granted");
    } else if (status.isDenied) {
      // Permission denied but not permanently
      print("Notification permission denied");
    } else if (status.isPermanentlyDenied) {
      // Handle permanently denied permission
      print("Notification permission permanently denied, opening app settings...");
      openAppSettings();
    }
  }


  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    throw UnsupportedError("Unsupported platform");
  }

  Future<void> _showNotification(String filePath, String fileName) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'basicNotification',
      'Basic Notification',
      channelDescription: 'This is used for showing basic notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const darwinPlatformChannelSpecifics = DarwinNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'File $fileName has been downloaded',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  Future<void> _handleNotificationTap(String? payload) async {
    if (payload != null) {
      // Open the downloaded file
      const platform = MethodChannel('com.motionview.hrm/openfile');
      try {
        await platform.invokeMethod('openFile', {'filePath': payload});
      } on PlatformException catch (e) {
        print("Failed to open file: '${e.message}'.");
      }
    }
  }
}
