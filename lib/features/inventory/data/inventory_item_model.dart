import 'dart:ui';

class InventoryItem {
  final String title;
  final String asset;
  final VoidCallback? onPress;

  InventoryItem({required this.title,required this.asset, required this.onPress});
}