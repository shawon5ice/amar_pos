import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/home/presentation/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isExpanded = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff022213),
      drawer: CustomDrawer(),
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
          InkWell(
            onTap: (){
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              height: 36.ph(context),
              color: isExpanded? Color(0xff93B7A74D) : Colors.transparent,
              padding: EdgeInsets.all(8.0.ph(context)),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart),
                  Text('Sales', style: context.textTheme.bodyLarge?.copyWith(),),
                ],
              ),
            ),
          ),
          if(isExpanded)
            AnimatedContainer(duration: Duration(milliseconds: 500,), child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 24),
                  height: 60,
                  width: 1,
                  color: Colors.orange,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubMenuWidget(title: 'Recurring Sales', icon: Icons.qr_code,),
                    SubMenuWidget(title: 'Flicking Tut', icon: Icons.ac_unit,),
                  ],
                ),
              ],
            ),)
        ],
      ),
    );
  }
}


class SubMenuWidget extends StatelessWidget {
  const SubMenuWidget({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 20,
          height: 1,
          color: Colors.orange,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, left: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon),
              Text(title, style: const TextStyle(color: Colors.black),),
            ],
          ),
        )
      ],
    );
  }
}
