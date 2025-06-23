import 'dart:ui';

class QuickAccessItemModel {
  final String title;
  final String asset;
  final VoidCallback onPress;
  final bool isLoading;

  QuickAccessItemModel({
    required this.title,
    required this.asset,
    required this.onPress,
    this.isLoading = false,
  });
}
