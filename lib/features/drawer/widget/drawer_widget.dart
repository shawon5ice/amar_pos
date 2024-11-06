import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../model/drawer_item.dart';
import '../model/drawer_items.dart';

class DrawerWidget extends StatefulWidget {
  final ValueChanged<DrawerItem?> onSelectedItem;
  final ValueChanged<String?> onSelectedChildItem;

  const DrawerWidget(
      {super.key, required this.onSelectedItem,required this.onSelectedChildItem});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  DrawerItem? selectedParentItem;
  String? selectedChildItem;
  bool isExpanded = false;

  bool parentItemChanged = false;
  bool childItemChanged = false;

  void onParentTap(DrawerItem item) {
    // Only update if the selection has actually changed
    if (selectedParentItem != item) {
      setState(() {
        selectedParentItem = item;
        selectedChildItem = null; // Reset child selection on parent change
        isExpanded = true; // Parent item should always expand when selected
      });

      // Update callbacks only when the parent item changes
      if (!parentItemChanged) {
        widget.onSelectedItem(selectedParentItem);
        widget.onSelectedChildItem(selectedChildItem);
        parentItemChanged = true; // Flag set to prevent redundant callback calls
      }
    }
  }

  void onChildTap(DrawerItem parent, String child) {
    // Update only if the child item has changed
    if (selectedChildItem != child) {
      setState(() {
        selectedParentItem = parent;
        selectedChildItem = child;
      });

      // Update callback only when child selection changes
      if (!childItemChanged) {
        widget.onSelectedItem(selectedParentItem);
        widget.onSelectedChildItem(selectedChildItem);
        childItemChanged = true; // Prevent redundant callback calls
      }
    }
  }

  @override
  Widget build(BuildContext _) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 100),
        child: SizedBox(
          width: context.width * .55,
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Arman Ahmed Shawon",
                          style: context.textTheme.titleSmall?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                        Text(
                          "Manager",
                          style: context.textTheme.titleSmall?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: AppColors.lightGreen,
                indent: 20,
                // endIndent: 20,
              ),
              buildDrawerItems(context, DrawerItems.overview),
              buildDrawerItems(context, DrawerItems.inventory),
              ExpandableDrawerWidget(
                item: DrawerItems.sales,
                children: const ["Retail Sale", "Whole Sale",],
                expanded: (bool isExpanded) {
                  setState(() {
                    if (isExpanded) selectedParentItem = DrawerItems.sales;
                  });
                },
                isExpanded:
                    isExpanded && selectedParentItem == DrawerItems.sales,
                selectedChild: selectedChildItem,
                onParentTap: () => onParentTap(DrawerItems.sales),
                onChildTap: (child) => onChildTap(DrawerItems.sales, child),
              ),
              buildDrawerItems(context, DrawerItems.returnAndExchange),
              buildDrawerItems(context, DrawerItems.purchase),
              buildDrawerItems(context, DrawerItems.accounting),
              buildDrawerItems(context, DrawerItems.reports),
              buildDrawerItems(context, DrawerItems.config),
              const SizedBox(
                height: 16,
              ),
              const Divider(
                color: AppColors.lightGreen,
                indent: 20,
                // endIndent: 20,
              ),
              const SizedBox(
                height: 16,
              ),
              buildDrawerItems(context, DrawerItems.feedback),
              buildDrawerItems(context, DrawerItems.trainingSession),
              buildDrawerItems(context, DrawerItems.joinCommunity),
              buildDrawerItems(context, DrawerItems.subscription),
              buildDrawerItems(context, DrawerItems.helpAndSupport),
              const SizedBox(
                height: 32,
              ),
              ListTile(
                leading: SvgPicture.asset(AppAssets.logoutMenuIcon),
                title: Text(
                  'Log Out',
                  style: context.textTheme.titleSmall?.copyWith(
                      color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context, DrawerItem item) {
    bool isSelected = selectedParentItem == item;
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.lightGreen.withOpacity(.3),
      shape: const RoundedRectangleBorder(
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
    super.key,
    required this.expanded,
    required this.item,
    required this.children,
    required this.isExpanded,
    required this.onParentTap,
    required this.onChildTap,
    this.selectedChild,
  });

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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          dense: true,
          title: Text(
            widget.item.title,
            style: TextStyle(
              color: widget.isExpanded
                  ? AppColors.accent
                  : AppColors.textDarkPrimary,
              fontSize: widget.isExpanded ? 14 : 12,
              fontWeight:
                  widget.isExpanded ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          horizontalTitleGap: 8,
          visualDensity: VisualDensity.compact,
          onTap: widget.onParentTap, // Toggle expansion on tap
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: widget.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vertical line with flexible height
                Container(
                  width: 1,
                  color: AppColors.accent,
                  height: 48 * widget.children.length.toDouble() - 24,
                ),
                // Column with child items
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.children
                        .map((child) => SizedBox(
                              height: 48,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12))),
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
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
