import 'package:flutter/material.dart';

enum NotificationChannelType {
  general,
  news,
  promotions,
  tips,
}

class NotificationChannel {
  final String id;
  final String name;
  final String description;
  final NotificationChannelType type;
  final IconData icon;
  final Color color;
  final String topicName;

  const NotificationChannel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.icon,
    required this.color,
    required this.topicName,
  });

  static List<NotificationChannel> get allChannels => [
        NotificationChannel(
          id: 'general',
          name: 'General',
          description: 'Important updates and announcements',
          type: NotificationChannelType.general,
          icon: Icons.notifications_outlined,
          color: Colors.blue,
          topicName: 'general',
        ),
        NotificationChannel(
          id: 'news',
          name: 'News',
          description: 'Latest news and updates about products',
          type: NotificationChannelType.news,
          icon: Icons.newspaper_outlined,
          color: Colors.teal,
          topicName: 'news',
        ),
        NotificationChannel(
          id: 'promotions',
          name: 'Promotions',
          description: 'Special offers and promotional deals',
          type: NotificationChannelType.promotions,
          icon: Icons.local_offer_outlined,
          color: Colors.orange,
          topicName: 'promotions',
        ),
        NotificationChannel(
          id: 'tips',
          name: 'Tips & Tricks',
          description: 'Helpful tips to use the app effectively',
          type: NotificationChannelType.tips,
          icon: Icons.lightbulb_outline,
          color: Colors.purple,
          topicName: 'tips_and_tricks',
        ),
      ];
}