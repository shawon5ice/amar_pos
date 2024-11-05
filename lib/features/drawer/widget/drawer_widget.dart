import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/features/drawer/model/drawer_item.dart';
import 'package:amar_pos/features/drawer/model/drawer_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildDrawerItems(context, DrawerItems.overview),
          buildDrawerItems(context, DrawerItems.inventory),
          buildDrawerItems(context, DrawerItems.sales),
        ],
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context, DrawerItem item){
    return ListTile(
      leading: SvgPicture.asset(item.icon, width: 20, height: 20,),
      dense: true,
      title: Text(item.title, style: TextStyle(color: AppColors.textDarkPrimary, fontSize: 12),),
      horizontalTitleGap: 8,
      visualDensity: VisualDensity.compact,
    );
  }
}
