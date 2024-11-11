import 'dart:ui';

class ConfigItem {
  final String title;
  final String asset;
  final VoidCallback? onPress;

  ConfigItem({required this.title,required this.asset, required this.onPress});
}