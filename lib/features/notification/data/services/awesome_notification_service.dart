import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/notification_channel.dart' as app_channel;
import '../models/notification_preferences.dart';

class AwesomeNotificationService {
  static final AwesomeNotificationService _instance = AwesomeNotificationService._internal();
  factory AwesomeNotificationService() => _instance;
  AwesomeNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GetStorage _storage = GetStorage();
  static const String _preferencesKey = 'notification_preferences';

  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'general',
          channelName: 'General Notifications',
          channelDescription: 'Important updates and announcements',
          defaultColor: Colors.blue,
          ledColor: Colors.blue,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          enableLights: true,
          enableVibration: true,
        ),
        NotificationChannel(
          channelKey: 'news',
          channelName: 'News',
          channelDescription: 'Latest news and updates',
          defaultColor: Colors.teal,
          ledColor: Colors.teal,
          importance: NotificationImportance.Default,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'promotions',
          channelName: 'Promotions',
          channelDescription: 'Special offers and deals',
          defaultColor: Colors.orange,
          ledColor: Colors.orange,
          importance: NotificationImportance.Default,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'tips',
          channelName: 'Tips & Tricks',
          channelDescription: 'Helpful tips to use the app',
          defaultColor: Colors.purple,
          ledColor: Colors.purple,
          importance: NotificationImportance.Low,
          channelShowBadge: true,
        ),
      ],
      debug: false,
    );

    await requestNotificationPermissions();
    await setupNotificationListeners();
    await initializeFirebaseTopics();
  }

  Future<bool> requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed = await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  Future<void> setupNotificationListeners() async {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    final Map<String, String?>? payload = receivedAction.payload;
    
    if (payload != null) {
      if (payload['url'] != null) {
        // Handle URL navigation
        // You can use url_launcher or webview here
      } else if (payload['route'] != null) {
        // Handle in-app navigation
        Get.toNamed(payload['route']!);
      }
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    // Handle notification created
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    // Handle notification displayed
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    // Handle notification dismissed
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String channelKey = 'general',
    Map<String, String>? payload,
    String? imageUrl,
    String? actionUrl,
    String? route,
  }) async {
    final preferences = getNotificationPreferences();
    
    if (!preferences.isChannelEnabled(channelKey)) {
      return;
    }

    final Map<String, String> notificationPayload = {};
    if (payload != null) notificationPayload.addAll(payload);
    if (actionUrl != null) notificationPayload['url'] = actionUrl;
    if (route != null) notificationPayload['route'] = route;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
        payload: notificationPayload,
        bigPicture: imageUrl,
        notificationLayout: imageUrl != null 
            ? NotificationLayout.BigPicture 
            : NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Message,
      ),
      actionButtons: actionUrl != null || route != null
          ? [
              NotificationActionButton(
                key: 'OPEN',
                label: 'Open',
                autoDismissible: true,
              ),
            ]
          : null,
    );
  }

  Future<void> handleFirebaseMessage(RemoteMessage message) async {
    final String channelKey = message.data['channel'] ?? 'general';
    final String? imageUrl = message.notification?.android?.imageUrl ?? 
                            message.notification?.apple?.imageUrl;
    
    await showNotification(
      title: message.notification?.title ?? 'Notification',
      body: message.notification?.body ?? '',
      channelKey: channelKey,
      payload: message.data.cast<String, String>(),
      imageUrl: imageUrl,
      actionUrl: message.data['url'],
      route: message.data['route'],
    );
  }

  // Topic Management
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> updateChannelSubscription(String channelId, bool isEnabled) async {
    final preferences = getNotificationPreferences();
    final updatedPreferences = preferences.copyWith(
      channelStatus: Map.from(preferences.channelStatus)..[channelId] = isEnabled,
      lastUpdated: DateTime.now(),
    );
    
    await saveNotificationPreferences(updatedPreferences);
    
    final channel = app_channel.NotificationChannel.allChannels.firstWhere(
      (c) => c.id == channelId,
      orElse: () => app_channel.NotificationChannel.allChannels.first,
    );
    
    if (isEnabled) {
      await subscribeToTopic(channel.topicName);
    } else {
      await unsubscribeFromTopic(channel.topicName);
    }
  }

  Future<void> initializeFirebaseTopics() async {
    final preferences = getNotificationPreferences();
    
    for (final channel in app_channel.NotificationChannel.allChannels) {
      if (preferences.isChannelEnabled(channel.id)) {
        await subscribeToTopic(channel.topicName);
      }
    }
  }

  // Preferences Management
  NotificationPreferences getNotificationPreferences() {
    final data = _storage.read(_preferencesKey);
    if (data != null) {
      return NotificationPreferences.fromJson(data);
    }
    return NotificationPreferences();
  }

  Future<void> saveNotificationPreferences(NotificationPreferences preferences) async {
    await _storage.write(_preferencesKey, preferences.toJson());
  }

  Future<void> updateSoundEnabled(bool enabled) async {
    final preferences = getNotificationPreferences();
    final updatedPreferences = preferences.copyWith(
      soundEnabled: enabled,
      lastUpdated: DateTime.now(),
    );
    await saveNotificationPreferences(updatedPreferences);
  }

  Future<void> updateVibrationEnabled(bool enabled) async {
    final preferences = getNotificationPreferences();
    final updatedPreferences = preferences.copyWith(
      vibrationEnabled: enabled,
      lastUpdated: DateTime.now(),
    );
    await saveNotificationPreferences(updatedPreferences);
  }

  Future<void> clearAllNotifications() async {
    await AwesomeNotifications().dismissAllNotifications();
  }

  Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  Future<void> cancelScheduledNotification(int id) async {
    await AwesomeNotifications().cancelSchedule(id);
  }
}