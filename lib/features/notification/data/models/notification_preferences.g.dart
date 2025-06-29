// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferences _$NotificationPreferencesFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferences(
      channelStatus: (json['channelStatus'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as bool),
      ),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'channelStatus': instance.channelStatus,
      'soundEnabled': instance.soundEnabled,
      'vibrationEnabled': instance.vibrationEnabled,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
