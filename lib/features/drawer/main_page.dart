import 'dart:ffi';
import 'dart:io';

import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/model/drawer_item.dart';
import 'package:amar_pos/features/drawer/widget/drawer_widget.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late double xOffset = 230;
  late double yOffset = 150;
  late double scaleFactor = .6;
  bool isDrawerOpened = true;
  bool isDragging = false;

  void openDrawer(){
    setState(() {
      xOffset = 230;
      yOffset = 150;
      scaleFactor = .6;
      isDrawerOpened = true;
    });
  }

  void closeDrawer(){
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpened = false;
    });
  }

  @override
  void initState() {
    openDrawer();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(isDrawerOpened){
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

  Widget buildDrawer() => DrawerWidget(onSelectedItem: (DrawerItem){

  },);

  Widget buildPage() {


    return GestureDetector(
      onTap: closeDrawer,
      onHorizontalDragStart: (DragStartDetails details){
        isDragging = true;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details){
        if(!isDragging)
          return;
        const delta = 1;
        if(details.delta.dx > delta){
          openDrawer();
        }else if(details.delta.dx < -delta){
          closeDrawer();
        }
        isDragging = false;
      },
      child: AbsorbPointer(
        absorbing: isDrawerOpened,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(xOffset, yOffset, 0)..scale(scaleFactor),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(isDrawerOpened ? 20: 0)),
            child: Container(
                decoration: BoxDecoration(
                    color: isDrawerOpened ? Colors.white12 : AppColors.scaffoldBackground ,
                ),

                child: HomeScreen(openDrawer : openDrawer)),
          )),
      ),
    );
  }
}
