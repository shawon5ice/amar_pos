import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/widgets.dart';
import '../constants/app_colors.dart';
import '../constants/logger/logger.dart';
import '../../features/notification/data/services/awesome_notification_service.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Process the background notification message
  logger.d('Handling background message: ${message.data}');
  
  // Handle the message with AwesomeNotificationService
  await AwesomeNotificationService().handleFirebaseMessage(message);
}

@pragma('vm:entry-point')
Future<void> handleOnActionReceived(ReceivedAction action) async {
  // Log received action for debugging
  logger.d("Notification action received: ${action.toMap()}");

  // Initialize Hive if required for data storage
  if (!Hive.isBoxOpen('notifications')) {
    await Hive.initFlutter();
  }

  // Safely extract payload and type
  final payload = action.payload ?? {};
  final type = payload['type'] ?? '';
  final refNo = payload['ref_no'];

  // Define navigation logic based on notification type
  Future<void> navigateToTargetPage() async {
    // if (type == 'leave') {
    //   Get.toNamed(ManageLeaveScreen.routeName, arguments: refNo);
    // } else if (type == 'late coming' || type == 'early out') {
    //   Get.toNamed(ManageLateEarlyScreen.routeName, arguments: refNo);
    // } else if (type == 'loan') {
    //   Get.toNamed(LoanScreen.routeName, arguments: refNo);
    // } else if (type == 'notice') {
    //   Get.toNamed(NoticeScreen.routeName, arguments: refNo);
    // }
  }

  // Ensure app is ready before navigation
  if (Get.isRegistered<GetMaterialController>()) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await navigateToTargetPage();
    });
  }

  // Handle badge count for iOS
  if (action.channelKey == 'basic_channel' && Platform.isIOS) {
    final currentBadge = await AwesomeNotifications().getGlobalBadgeCounter();
    await AwesomeNotifications().setGlobalBadgeCounter(currentBadge - 1);
  }
}


@pragma('vm:entry-point')
Future<void> handleInitialFirebaseMessage(RemoteMessage message) async {
  logger.d('Initial Message Data: ${message.data}');
  print("Handling initial notification (killed app).");

  // try {
  //   final String? page = message.data['pages'];
  //   final dynamic arguments = message.data['arguments'];
  //
  //   if (page != null) {
  //     if (page == ProductView.routeName) {
  //       Get.toNamed(
  //         ProductView.routeName,
  //         arguments: [arguments, 0],
  //       );
  //     } else {
  //       Get.toNamed(
  //         page,
  //         arguments: arguments,
  //       );
  //     }
  //   } else {
  //     Log.logger.w('No page found in initial notification.');
  //   }
  // } catch (e, stack) {
  //   Log.logger.e('Error handling initial notification: $e\n$stack');
  //   print('Error parsing initial notification data: $e');
  // }
}


class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  @pragma('vm:entry-point')
  Future<void> initializeLocalNotificationChannel() async {
    // Define vibration pattern
    List<int> vibrationPattern = [2000, 100, 2500, 100, 3000, 100];
    Int64List longVibrationPattern = Int64List.fromList(vibrationPattern);

    // Initialize Awesome Notifications
    AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          defaultColor: AppColors.primary,
          channelShowBadge: true,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          vibrationPattern: longVibrationPattern,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupName: 'Basic group',
          channelGroupKey: 'basic_channel_group',
        ),
      ],
    );

    // Configure iOS foreground notification behavior
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: handleOnActionReceived,
    );
  }

  @pragma('vm:entry-point')
  Future<void> initNotification() async {
    // Request permissions for notifications
    final permission = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (permission.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('Notifications authorized');
    } else {
      logger.w('Notifications not authorized');
    }

    // Get and log the FCM token
    final fcmToken = await _firebaseMessaging.getToken();
    logger.i('FCM Token: $fcmToken');

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // Initialize notification channels
    await initializeLocalNotificationChannel();
  }
}
