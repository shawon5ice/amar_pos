import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../model/drawer_item.dart';
import '../model/drawer_items.dart';

class DrawerWidget extends StatefulWidget {
  final ValueChanged<DrawerItem> onSelectedItem;
  const DrawerWidget({super.key, required this.onSelectedItem});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  DrawerItem? selectedParentItem;
  String? selectedChildItem;
  bool isExpanded = false;

  void onParentTap(DrawerItem item) {
    setState(() {
      // Toggle the expanded state if the same parent item is tapped again
      if (selectedParentItem == item && isExpanded) {
        isExpanded = false;
        selectedParentItem = null;
      } else {
        isExpanded = true;
        selectedParentItem = item;
        selectedChildItem = null; // Clear child selection when a new parent is selected
      }
    });
    // Navigate to the corresponding page based on `item`, if needed
  }

  void onChildTap(DrawerItem parent, String child) {
    setState(() {
      selectedParentItem = parent;
      selectedChildItem = child;
    });
    // Navigate to the unique page based on `parent` and `child`
  }

  @override
  Widget build(BuildContext _) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 100),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: Colors.white, radius: 25,),
              SizedBox(width: 12,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Arman Ahmed Shawon", style: context.textTheme.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                  Text("Manager", style: context.textTheme.titleSmall?.copyWith(color: AppColors.accent, fontWeight: FontWeight.bold),)
                ],
              )
            ],),
            SizedBox(height: 18,),
            Divider(
              color: AppColors.lightGreen,
              indent: 20,
              endIndent: 20,
            ),
            buildDrawerItems(context, DrawerItems.overview),
            buildDrawerItems(context, DrawerItems.inventory),
            ExpandableDrawerWidget(
              item: DrawerItems.sales,
              children: ["Retail Sale", "Whole Sale"],
              expanded: (bool isExpanded) {
                setState(() {
                  if (isExpanded) selectedParentItem = DrawerItems.sales;
                });
              },
              isExpanded: isExpanded && selectedParentItem == DrawerItems.sales,
              selectedChild: selectedChildItem,
              onParentTap: () => onParentTap(DrawerItems.sales),
              onChildTap: (child) => onChildTap(DrawerItems.sales, child),
            ),
            buildDrawerItems(context, DrawerItems.returnAndExchange),
            buildDrawerItems(context, DrawerItems.purchase),
            buildDrawerItems(context, DrawerItems.accounting),
            buildDrawerItems(context, DrawerItems.reports),
            buildDrawerItems(context, DrawerItems.config),
            Divider(
              color: AppColors.lightGreen,
              indent: 20,
              endIndent: 20,
            ),

            buildDrawerItems(context, DrawerItems.feedback),
            buildDrawerItems(context, DrawerItems.trainingSession),
            buildDrawerItems(context, DrawerItems.joinCommunity),
            buildDrawerItems(context, DrawerItems.subscription),
            buildDrawerItems(context, DrawerItems.helpAndSupport),
            SizedBox(height: 32,),
            ListTile(
              leading: SvgPicture.asset(AppAssets.logoutMenuIcon),
              title: Text('Log Out', style: context.textTheme.titleSmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }


  Widget buildDrawerItems(BuildContext context, DrawerItem item) {
    bool isSelected = selectedParentItem == item;
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.lightGreen.withOpacity(.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      onTap: () => onParentTap(item),
      leading: SvgPicture.asset(item.icon, width: 20, height: 20),
      dense: true,
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? AppColors.accent : AppColors.textDarkPrimary,
          fontSize: isSelected ? 14 : 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      horizontalTitleGap: 8,
      visualDensity: VisualDensity.compact,
    );
  }
}

class ExpandableDrawerWidget extends StatefulWidget {
  const ExpandableDrawerWidget({
    Key? key,
    required this.expanded,
    required this.item,
    required this.children,
    required this.isExpanded,
    required this.onParentTap,
    required this.onChildTap,
    this.selectedChild,
  }) : super(key: key);

  final Function(bool isExpanded) expanded;
  final DrawerItem item;
  final List<String> children;
  final bool isExpanded;
  final VoidCallback onParentTap;
  final void Function(String child) onChildTap;
  final String? selectedChild;

  @override
  State<ExpandableDrawerWidget> createState() => _ExpandableDrawerWidgetState();
}

class _ExpandableDrawerWidgetState extends State<ExpandableDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: SvgPicture.asset(
            widget.item.icon,
            width: 20,
            height: 20,
            color: widget.isExpanded ? AppColors.accent : null,
          ),
          selected: widget.isExpanded,
          selectedTileColor: AppColors.lightGreen.withOpacity(.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          dense: true,
          title: Text(
            widget.item.title,
            style: TextStyle(
              color: widget.isExpanded ? AppColors.accent : AppColors.textDarkPrimary,
              fontSize: widget.isExpanded ? 14 : 12,
              fontWeight: widget.isExpanded ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          horizontalTitleGap: 8,
          visualDensity: VisualDensity.compact,
          onTap: widget.onParentTap, // Toggle expansion on tap
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: widget.isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: IntrinsicHeight( // Ensure the row height adapts to its children
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vertical line with flexible height
                  Container(
                    width: 1,
                    color: AppColors.accent,
                    height: 36 * widget.children.length.toDouble(),
                  ),
                  // Column with child items
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.children
                          .map((child) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        dense: true,
                        title: Row(
                          children: [
                            // Small horizontal line for each child
                            Container(
                              width: 20,
                              height: 1,
                              color: AppColors.accent,
                              margin: const EdgeInsets.only(right: 4),
                            ),
                            Text(
                              child,
                              style: TextStyle(
                                color: widget.selectedChild == child
                                    ? AppColors.accent
                                    : AppColors.textDarkPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        selected: widget.selectedChild == child,
                        onTap: () => widget.onChildTap(child),
                      ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ],
    );
  }
}
