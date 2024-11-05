import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: buildDrawer(),
    );
  }

  Widget buildDrawer() => SafeArea(child: DrawerWidget());
}
