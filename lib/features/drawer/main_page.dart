import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/widget/drawer_widget.dart';
import 'model/drawer_items.dart';

class MainPage extends StatelessWidget {
  static const String routeName = "/main";
  final DrawerMenuController menuController = Get.put(DrawerMenuController());

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ));
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (menuController.isDrawerOpened.value) {
          menuController.closeDrawer();
        } else if (menuController.selectedMenuItem.value?.parent !=
            DrawerItems.overview) {
          menuController.openDrawer();
        } else {
          // If on the Overview screen and the drawer is closed, show exit dialog
          showExitConfirmation(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkGreen,
        body: Stack(
          children: [
            buildDrawer(),
            GestureDetector(
              onTap: menuController.closeDrawer,
              onHorizontalDragStart: (DragStartDetails details) {
                menuController.isDragging = true;
              },
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                if (!menuController.isDragging) return;
                const delta = 1;
                if (details.delta.dx > delta) {
                  menuController.openDrawer();
                } else if (details.delta.dx < -delta) {
                  menuController.closeDrawer();
                }
                menuController.isDragging = false;
              },
              child: Obx(() => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    transform: Matrix4.translationValues(
                        menuController.xOffset.value,
                        menuController.yOffset.value,
                        0)
                      ..scale(menuController.scaleFactor.value),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(
                          menuController.isDrawerOpened.value ? 20 : 0)),
                      child: AbsorbPointer(
                        absorbing: menuController.isDrawerOpened.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: menuController.isDrawerOpened.value
                                ? Colors.white12
                                : AppColors.scaffoldBackground,
                          ),
                          child: Obx(() => menuController
                              .getSelectedPage()), // Dynamically show the selected page
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer() => DrawerWidget(
        // onSelectedItem: (value) {
        //   bool isSameItemSelected =
        //       value?.parent == menuController.selectedMenuItem.value?.parent &&
        //           value?.child == menuController.selectedMenuItem.value?.child;
        //
        //   if (isSameItemSelected) {
        //     menuController.closeDrawer();
        //   } else {
        //     bool isParentWithChildren = (value?.parent == DrawerItems.inventory) &&
        //         value?.child == null || (value?.parent == DrawerItems.returnAndExchange) &&
        //         value?.child == null || (value?.parent == DrawerItems.purchase) &&
        //         value?.child == null
        //     ;
        //     if (!isParentWithChildren) {
        //       menuController.selectParent(value!.parent);
        //       if (value.child != null) {
        //         menuController.selectChild(value.parent, value.child!);
        //       }
        //     }
        //     if (!isParentWithChildren || value?.child != null) {
        //       menuController.closeDrawer();
        //     }
        //   }
        // },
      );

  Future<bool> showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("You are going to exit the app."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
