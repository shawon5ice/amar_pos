import 'dart:ffi';
import 'dart:io';

import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/routes/router.dart';
import 'package:amar_pos/features/drawer/model/drawer_item.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/widget/drawer_widget.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double xOffset;
  late double yOffset;
  late double scaleFactor;
  bool isDrawerOpened = false;
  bool isDragging = false;
  DrawerItem? selectedDrawerItem;
  String? selectedChildItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void openDrawer() {
    setState(() {
      xOffset = context.width * .65;
      yOffset = context.height * .2;
      scaleFactor = .5;
      isDrawerOpened = true;
    });
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDrawerOpened) {
          closeDrawer();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.darkGreen,
        body: SafeArea(
          child: Stack(
            children: [
              buildDrawer(),
              buildPage(),
            ],
          ),
        ),
      ),
    );
  }

  void handleMenuItemTap(){
    switch(selectedDrawerItem){
      case DrawerItems.overview:
        print(selectedDrawerItem?.title);
    }
  }

  Widget buildDrawer() => DrawerWidget(
        onSelectedItem: (value) {
          selectedDrawerItem = value;
          handleMenuItemTap();
        },
        onSelectedChildItem: (value) {
          selectedChildItem = value;
          handleMenuItemTap();
        },
      );

  Widget buildPage() {
    return GestureDetector(
      onTap: closeDrawer,
      onHorizontalDragStart: (DragStartDetails details) {
        isDragging = true;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!isDragging) return;
        const delta = 1;
        if (details.delta.dx > delta) {
          openDrawer();
        } else if (details.delta.dx < -delta) {
          closeDrawer();
        }
        isDragging = false;
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor),
          child: ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(isDrawerOpened ? 20 : 0)),
            child: AbsorbPointer(
              absorbing: isDrawerOpened,
              child: Container(
                  decoration: BoxDecoration(
                    color: isDrawerOpened
                        ? Colors.white12
                        : AppColors.scaffoldBackground,
                  ),
                  child: HomeScreen(openDrawer: openDrawer)),
            ),
          )),
    );
  }
}
