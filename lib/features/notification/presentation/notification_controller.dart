import 'package:get/get.dart';
import '../data/models/notification_channel.dart' as app_channel;
import '../data/models/notification_model.dart';
import '../data/models/notification_preferences.dart';
import '../data/services/awesome_notification_service.dart';

class NotificationController extends GetxController {
  final AwesomeNotificationService _notificationService = AwesomeNotificationService();
  
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final Rx<NotificationPreferences> preferences = NotificationPreferences().obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> channelStates = <String, bool>{}.obs;
  final RxBool soundEnabled = true.obs;
  final RxBool vibrationEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
    loadNotifications();
  }

  void loadPreferences() {
    preferences.value = _notificationService.getNotificationPreferences();
    
    // Initialize channel states
    for (final channel in app_channel.NotificationChannel.allChannels) {
      channelStates[channel.id] = preferences.value.isChannelEnabled(channel.id);
    }
    
    soundEnabled.value = preferences.value.soundEnabled;
    vibrationEnabled.value = preferences.value.vibrationEnabled;
  }

  void loadNotifications() {
    // Load notifications from local storage or API
    // For now, we'll use dummy data
    notifications.value = [
      NotificationModel(
        id: '1',
        title: 'Welcome to AmarPOS!',
        body: 'Thank you for using our app. Check out our latest features.',
        channelId: 'general',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '2',
        title: 'New Product Updates',
        body: 'We have added new products to our inventory. Check them out!',
        channelId: 'news',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: '50% Off on Selected Items',
        body: 'Limited time offer! Get 50% discount on selected products.',
        channelId: 'promotions',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: false,
        imageUrl: 'https://example.com/promo.jpg',
      ),
      NotificationModel(
        id: '4',
        title: 'Quick Tip: Barcode Scanning',
        body: 'Did you know you can scan barcodes directly in the sales screen?',
        channelId: 'tips',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isRead: true,
      ),
    ];
  }

  Future<void> toggleChannel(String channelId, bool value) async {
    isLoading.value = true;
    
    try {
      await _notificationService.updateChannelSubscription(channelId, value);
      channelStates[channelId] = value;
      
      // Reload preferences
      preferences.value = _notificationService.getNotificationPreferences();
      
      Get.snackbar(
        'Success',
        value 
          ? 'Subscribed to ${_getChannelName(channelId)} notifications'
          : 'Unsubscribed from ${_getChannelName(channelId)} notifications',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update notification preferences',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleSound(bool value) async {
    await _notificationService.updateSoundEnabled(value);
    soundEnabled.value = value;
    preferences.value = _notificationService.getNotificationPreferences();
  }

  Future<void> toggleVibration(bool value) async {
    await _notificationService.updateVibrationEnabled(value);
    vibrationEnabled.value = value;
    preferences.value = _notificationService.getNotificationPreferences();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
    }
  }

  void markAllAsRead() {
    notifications.value = notifications.map((n) => n.copyWith(isRead: true)).toList();
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
  }

  void clearAllNotifications() {
    notifications.clear();
    _notificationService.clearAllNotifications();
  }

  String _getChannelName(String channelId) {
    return app_channel.NotificationChannel.allChannels
        .firstWhere((c) => c.id == channelId, 
            orElse: () => app_channel.NotificationChannel.allChannels.first)
        .name;
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> getNotificationsByChannel(String channelId) {
    return notifications.where((n) => n.channelId == channelId).toList();
  }

  // Test notification
  Future<void> sendTestNotification(String channelId) async {
    final channel = app_channel.NotificationChannel.allChannels.firstWhere(
      (c) => c.id == channelId,
      orElse: () => app_channel.NotificationChannel.allChannels.first,
    );

    await _notificationService.showNotification(
      title: 'Test ${channel.name} Notification',
      body: 'This is a test notification for the ${channel.name} channel.',
      channelKey: channelId,
      payload: {'test': 'true'},
    );
  }
}