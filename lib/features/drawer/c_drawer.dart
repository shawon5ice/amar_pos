import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

import '../../core/constants/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/drawer_c';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );
  late FocusNode? _scaffoldFocus;

  @override
  void initState() {
    _scaffoldFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _scaffoldFocus?.dispose();
    super.dispose();
  }

  int _selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 0) {

          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  buttonPadding: const EdgeInsets.all(5),
                  title: const Text('Are you sure?'),
                  content: const Text('Do you want to exit the application'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('No',style: TextStyle(color: Colors.grey),)),
                    TextButton(onPressed: () => SystemNavigator.pop(animated: true), child: const Text('Yes', style: TextStyle(color: Colors.red),)),
                  ],
                );
              }
          );
          // AwesomeDialog(
          //   context: context,
          //   dialogType: DialogType.QUESTION,
          //   headerAnimationLoop: false,
          //   animType: AnimType.BOTTOMSLIDE,
          //   title: "Exit",
          //   desc: "Are you sure?",
          //   btnCancelOnPress: () {},
          //   btnOkOnPress: () =>
          //       Platform.isIOS ? exit(0) : SystemNavigator.pop(),
          // ).show();
        } else {
          setState(() => _selectedIndex = 0);
        }
        return true;
      },
      child: Focus(
        focusNode: _scaffoldFocus,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              child: Icon(Icons.menu),
              onTap: ()=> ZoomDrawer.of(context)?.toggle(),
            ),
            leadingWidth: 64,
            actions: const [
              Stack(
                children: [
                  Icon(Icons.notifications_none),
                  Positioned(
                      right: 4,
                      top: 4,
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        radius: 3,
                      ))
                ],
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          body: SafeArea(
            child: Placeholder()
          ),
          // bottomNavigationBar: ClipRRect(
          //   // borderRadius: BorderRadius.only(),
          //   clipBehavior: Clip.hardEdge,
          //   child: Container(
          //     height: 72,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //         topRight: Radius.circular(24),
          //         topLeft: Radius.circular(24),
          //       ),
          //     ),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: [
          //         _buildNavItem(0, 'Home'),
          //         _buildNavItem(1, 'Search'),
          //         _buildNavItem(2, 'Bookmark'),
          //         _buildNavItem(3, 'Settings'),
          //       ],
          //     ),
          //   ),
          // ),
          // floatingActionButton: FloatingActionButton(
          //   shape: CircleBorder(),
          //   onPressed: () {},
          //   tooltip: 'Create',
          //   child: const Icon(Icons.add),
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  // Widget _buildNavItem(int index, String text) {
  //   return IconButton(
  //     icon: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SvgPicture.asset(
  //           index == _selectedIndex ? navIcons[index][1] : navIcons[index][0],
  //           width: 16,
  //           height: 16,
  //           color:
  //           index == _selectedIndex ? AppColors.primary : Colors.black,
  //         ),
  //         SizedBox(height: 2.5,),
  //         Text(
  //           text,
  //           style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //               color: index == _selectedIndex ? AppColors.primary : null),
  //         ),
  //       ],
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _scaffoldFocus?.requestFocus();
  //         _selectedIndex = index;
  //         _pageController.jumpToPage(_selectedIndex);
  //       });
  //       // _pageController.animateToPage(
  //       //   index,
  //       //   duration: const Duration(milliseconds: 500),
  //       //   curve: Curves.easeInOut,
  //       // );
  //     },
  //     tooltip: text,
  //   );
  // }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Test Page !"),
      ),
    );
  }
}
