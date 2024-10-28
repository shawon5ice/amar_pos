import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E"),
        actions: [
          IconButton(onPressed: (){
            Get.changeThemeMode(Get.isDarkMode? ThemeMode.light : ThemeMode.dark);
          }, icon: Get.isDarkMode? Icon(Icons.sunny): Icon(Icons.nightlight))
        ],
      ),
      body: Column(
        children: [
          Text("HELLO WORLD", style: context.textTheme.bodyLarge,)
        ],
      ),
    );
  }
}
