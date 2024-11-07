import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/category/presentation/category_screen.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';
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
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpened = false;
  bool isDragging = false;

  MenuSelection? selectedMenuItem;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedMenuItem = MenuSelection(parent: DrawerItems.overview);
      });
    });
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

  getDrawerPage() {
    // Check if the selected item is a parent with children and no child is selected
    if (selectedMenuItem?.parent == DrawerItems.sales && selectedMenuItem?.child == null) {
      return; // Do nothing if it's a parent with children but no child is selected
    }

    // Existing logic for navigation based on selected item
    switch (selectedMenuItem?.parent) {
      case DrawerItems.overview:
        return HomeScreen(openDrawer: openDrawer);
      case DrawerItems.inventory:
        return Scaffold(
          backgroundColor: AppColors.warning,
          body: Center(child: Text(selectedMenuItem!.parent.title)),
        );
      case DrawerItems.sales:
        return Scaffold(
          backgroundColor: AppColors.error,
          body: Center(child: Text('${selectedMenuItem!.parent.title} ${selectedMenuItem!.child!}')),
        );
      case DrawerItems.config:
        return CategoryScreen();
    }
    return Container(); // Fallback if no valid selection is made
  }

  Widget buildDrawer() => DrawerWidget(
    onSelectedItem: (value) {
      setState(() {
        // Check if the same item is tapped again
        bool isSameItemSelected = value?.parent == selectedMenuItem?.parent && value?.child == selectedMenuItem?.child;

        if (isSameItemSelected) {
          // Close the drawer if the item is already selected
          closeDrawer();
        } else {
          // Check if the item is a parent with children but no child is selected
          bool isParentWithChildren = value?.parent == DrawerItems.sales && value?.child == null;

          // Only update if it's not a parent with children without a child selected
          if (!isParentWithChildren) {
            selectedMenuItem = value;
          }

          // Close the drawer if a parent without children or a child is selected
          if (!isParentWithChildren || value?.child != null) {
            closeDrawer();
          }
        }
      });
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
        duration: const Duration(milliseconds: 250),
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
              child: getDrawerPage(),
            ),
          ),
        ),
      ),
    );
  }
}
