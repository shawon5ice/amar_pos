import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/responsive/pixel_perfect.dart';
import '../../../core/widgets/field_title.dart';
import '../data/models/notification_channel.dart' as nc;
import '../data/models/notification_model.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notification_screen';
  
  NotificationScreen({Key? key}) : super(key: key);

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Notifications'),
          centerTitle: true,
          actions: [
            Obx(() => Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: () => Get.to(() => NotificationSettingsScreen()),
                ),
                if (controller.unreadCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${controller.unreadCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            )),
          ],
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Channels'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllNotificationsTab(),
            _buildChannelsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllNotificationsTab() {
    return Obx(() {
      if (controller.notifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No notifications yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.loadNotifications(),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notification = controller.notifications[index];
            return _buildNotificationItem(notification);
          },
        ),
      );
    });
  }

  Widget _buildChannelsTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: nc.NotificationChannel.allChannels.map((channel) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: channel.color.withOpacity(0.2),
              child: Icon(
                channel.icon,
                color: channel.color,
              ),
            ),
            title: Text(
              channel.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              channel.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Obx(() {
                      final channelNotifications = 
                          controller.getNotificationsByChannel(channel.id);
                      
                      if (channelNotifications.isEmpty) {
                        return Container(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No ${channel.name} notifications',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Column(
                        children: channelNotifications
                            .take(3)
                            .map((n) => _buildCompactNotificationItem(n))
                            .toList(),
                      );
                    }),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => controller.sendTestNotification(channel.id),
                      icon: Icon(Icons.notifications_active),
                      label: Text('Send Test Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: channel.color,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    final channel = nc.NotificationChannel.allChannels.firstWhere(
      (c) => c.id == notification.channelId,
      orElse: () => nc.NotificationChannel.allChannels.first,
    );

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: notification.isRead ? 0 : 2,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              controller.markAsRead(notification.id);
            }
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: channel.color,
                  width: 4,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      channel.icon,
                      size: 20,
                      color: channel.color,
                    ),
                    SizedBox(width: 8),
                    Text(
                      channel.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: channel.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      _formatTime(notification.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: notification.isRead ? Colors.grey[700] : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                if (notification.imageUrl != null) ...[
                  SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactNotificationItem(NotificationModel notification) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  notification.body,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            _formatTime(notification.timestamp),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return DateFormat('MMM d').format(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  final NotificationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTitle(
                    'General Settings',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 16),
                  Obx(() => SwitchListTile(
                    title: Text('Sound'),
                    subtitle: Text('Play sound for notifications'),
                    value: controller.soundEnabled.value,
                    onChanged: controller.toggleSound,
                    secondary: Icon(Icons.volume_up),
                  )),
                  Obx(() => SwitchListTile(
                    title: Text('Vibration'),
                    subtitle: Text('Vibrate for notifications'),
                    value: controller.vibrationEnabled.value,
                    onChanged: controller.toggleVibration,
                    secondary: Icon(Icons.vibration),
                  )),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTitle(
                    'Notification Channels',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Choose which types of notifications you want to receive',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 16),
                  ...nc.NotificationChannel.allChannels.map((channel) {
                    return Obx(() => SwitchListTile(
                      title: Text(channel.name),
                      subtitle: Text(channel.description),
                      value: controller.channelStates[channel.id] ?? true,
                      onChanged: controller.isLoading.value
                          ? null
                          : (value) => controller.toggleChannel(channel.id, value),
                      secondary: CircleAvatar(
                        backgroundColor: channel.color.withOpacity(0.2),
                        child: Icon(
                          channel.icon,
                          color: channel.color,
                          size: 20,
                        ),
                      ),
                    ));
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(Icons.clear_all, color: Colors.red),
              title: Text('Clear All Notifications'),
              subtitle: Text('Remove all notifications from the list'),
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    title: Text('Clear All Notifications?'),
                    content: Text('This will remove all notifications. This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          controller.clearAllNotifications();
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'All notifications cleared',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Clear All'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}