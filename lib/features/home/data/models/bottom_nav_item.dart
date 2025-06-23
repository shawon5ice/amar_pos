import 'package:flutter/cupertino.dart';

class BottomNavItem {
  final String label;
  final IconData? icon;
  final bool isProfile;
  final String? profileImage;
  final VoidCallback onPress;

  BottomNavItem({
    required this.label,
    this.icon,
    this.isProfile = false,
    this.profileImage,
    required this.onPress,
  });
}