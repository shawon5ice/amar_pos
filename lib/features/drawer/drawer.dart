//
//
// import 'package:amar_pos/core/constants/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
// import 'package:get/get.dart';
// // import 'package:hive_flutter/hive_flutter.dart';
// //
// // import '../../core/core.dart';
// // import '../../core/hive/boxes.dart';
// // import '../home/home_screen.dart';
// import '../home/presentation/home_screen.dart';
// import 'menu_screen.dart';
//
// class DrawerSetup extends StatefulWidget {
//   static String routeName = '/drawer';
//   const DrawerSetup({super.key});
//
//   @override
//   State<DrawerSetup> createState() => _DrawerSetupState();
// }
//
// class _DrawerSetupState extends State<DrawerSetup> {
//   bool shouldRefresh = false;
//
//   @override
//   void initState() {
//     if(Get.arguments != null){
//       shouldRefresh = true;
//     }
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return ZoomDrawer(
//       duration: const Duration(milliseconds: 400),
//       angle: 0,
//       moveMenuScreen: true,
//       borderRadius: 40,
//       showShadow: true,
//       mainScreenTapClose: true,
//       style: DrawerStyle.defaultStyle,
//       mainScreenScale: .2,
//       disableDragGesture: false,
//       shadowLayer2Color: context.isDarkMode
//           ? AppColors.textSecondary
//           :  AppColors.textPrimary,
//       shadowLayer1Color: context.isDarkMode
//           ? AppColors.textDarkSecondary
//           : AppColors.textDarkPrimary,
//       menuScreen: const MenuScreen(),
//       mainScreen: HomeScreen(),
//     );
//   }
// }
