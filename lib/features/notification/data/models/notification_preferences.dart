import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences.g.dart';

@JsonSerializable()
class NotificationPreferences {
  final Map<String, bool> channelStatus;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final DateTime? lastUpdated;

  NotificationPreferences({
    Map<String, bool>? channelStatus,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.lastUpdated,
  }) : channelStatus = channelStatus ?? {
          'general': true,
          'news': true,
          'promotions': true,
          'tips': true,
        };

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);

  NotificationPreferences copyWith({
    Map<String, bool>? channelStatus,
    bool? soundEnabled,
    bool? vibrationEnabled,
    DateTime? lastUpdated,
  }) {
    return NotificationPreferences(
      channelStatus: channelStatus ?? this.channelStatus,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  bool isChannelEnabled(String channelId) {
    return channelStatus[channelId] ?? true;
  }
}