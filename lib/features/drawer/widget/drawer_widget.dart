import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/data/preference.dart';
import 'package:amar_pos/features/auth/data/model/hive/login_data_helper.dart';
import 'package:amar_pos/features/auth/presentation/ui/login_screen.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/drawer/model/menu_selection.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/data/model/hive/login_data.dart';
import '../model/drawer_item.dart';
import '../model/drawer_items.dart';

class DrawerWidget extends StatefulWidget {
  // final ValueChanged<MenuSelection?> onSelectedItem;

  const DrawerWidget(
      {super.key,});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DrawerMenuController  controller = Get.find();

  // bool parentItemChanged = false;
  // bool childItemChanged = false;
  @override
  void initState() {
    onParentTap(DrawerItems.overview);
    super.initState();
  }


  void onParentTap(DrawerItem item) {
    final hasChildren = controller.hasVisibleChildren(item);

    controller.selectParent(item);

    if (!hasChildren) {
      // Treat as a leaf — trigger immediate navigation and drawer close
      controller.selectedMenuItem.value = MenuSelection(parent: item, child: null);
      controller.closeDrawer();
    }
  }


  void onChildTap(DrawerItem parent, String child) {
    controller.selectChild(parent, child);
    controller.closeDrawer();
  }

  @override
  Widget build(BuildContext _) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: GetBuilder<DrawerMenuController>(
        id: 'drawer_menu',
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 100),
            child: SizedBox(
              width: 232,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      onParentTap(DrawerItems.profile);
                      // Get.to(()=> ProfileScreen());
                    },
                    child: GetBuilder<DrawerMenuController>(
                      id: 'profile_picture',
                      builder: (controller) {
                        return Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            color: controller.selectedParentItem == DrawerItems.profile ? AppColors.lightGreen.withOpacity(.3) : null
                          ),
                          child: ValueListenableBuilder<Box>(
                            valueListenable: controller.manager.listenable,
                            builder: (context, box, _) {
                              final loginData = LoginDataBoxManager().loginData;

                              return Row(
                                children: [
                                  (loginData?.photo != null && loginData!.photo!.contains('http')) ?ClipOval(child: CachedNetworkImage(imageUrl:loginData.photo!, fit: BoxFit.cover,width: 50,height: 50,)): const Icon(Icons.broken_image),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          loginData?.name ?? '--',
                                          style: context.textTheme.titleSmall?.copyWith(
                                              color: Colors.white, fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          loginData?.email ?? "--",
                                          style: context.textTheme.bodyLarge?.copyWith(
                                              color: AppColors.accent,
                                              fontWeight: FontWeight.normal),
                                          maxLines: 1,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),

                        );
                      }
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Divider(
                    color: AppColors.lightGreen,
                    indent: 20,
                    // endIndent: 20,
                  ),
                  SizedBox(
                    height: context.height * .75,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          buildDrawerItems(context, DrawerItems.overview),
                          if(controller.inventoryModule.isNotEmpty)ExpandableDrawerWidget(
                            item: DrawerItems.inventory,
                            children: controller.inventoryModule.toList(),
                            expanded: (bool isExpanded) {
                              setState(() {
                                if (isExpanded) controller.selectedParentItem = DrawerItems.inventory;
                              });
                            },
                            isExpanded: controller.isExpanded && controller.selectedParentItem == DrawerItems.inventory,
                            selectedChild: controller.selectedChildItem,
                            onParentTap: () => onParentTap(DrawerItems.inventory),
                            onChildTap: (child) => onChildTap(DrawerItems.inventory, child),
                          ),
                          if(controller.salesModule)buildDrawerItems(context, DrawerItems.sales),
                          // ExpandableDrawerWidget(
                          //   item: DrawerItems.sales,
                          //   children: const ["Retail Sale", "Whole Sale",],
                          //   expanded: (bool isExpanded) {
                          //     setState(() {
                          //       if (isExpanded) selectedParentItem = DrawerItems.sales;
                          //     });
                          //   },
                          //   isExpanded:
                          //       isExpanded && selectedParentItem == DrawerItems.sales,
                          //   selectedChild: selectedChildItem,
                          //   onParentTap: () => onParentTap(DrawerItems.sales),
                          //   onChildTap: (child) => onChildTap(DrawerItems.sales, child),
                          // ),
                          if(controller.returnAndExchangeModule.isNotEmpty)ExpandableDrawerWidget(
                            item: DrawerItems.returnAndExchange,
                            children: controller.returnAndExchangeModule.toList(),
                            expanded: (bool isExpanded) {
                              setState(() {
                                if (isExpanded) controller.selectedParentItem = DrawerItems.returnAndExchange;
                              });
                            },
                            isExpanded: controller.isExpanded && controller.selectedParentItem == DrawerItems.returnAndExchange,
                            selectedChild: controller.selectedChildItem,
                            onParentTap: () => onParentTap(DrawerItems.returnAndExchange),
                            onChildTap: (child) => onChildTap(DrawerItems.returnAndExchange, child),
                          ),
                          if(controller.purchaseModule.isNotEmpty)ExpandableDrawerWidget(
                            item: DrawerItems.purchase,
                            children: controller.purchaseModule.toList(),
                            expanded: (bool isExpanded) {
                              setState(() {
                                if (isExpanded) controller.selectedParentItem = DrawerItems.purchase;
                              });
                            },
                            isExpanded: controller.isExpanded && controller.selectedParentItem == DrawerItems.purchase,
                            selectedChild: controller.selectedChildItem,
                            onParentTap: () => onParentTap(DrawerItems.purchase),
                            onChildTap: (child) => onChildTap(DrawerItems.purchase, child),
                          ),
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
                            height: 16,
                          ),
                          ListTile(
                            selectedTileColor: AppColors.lightGreen.withOpacity(.3),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            dense: true,
                            onTap: (){
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  headerAnimationLoop: false,
                                  title: "Are you sure?",
                                  desc: "You are going to log out from AMAR POS.",
                                  btnCancelColor: Colors.green,
                                  btnOkColor: Colors.red,
                                  btnOkOnPress: () {
                                    LoginDataBoxManager().loginData = null;
                                    Preference.setLoggedInFlag(false);
                                    Get.offAndToNamed(LoginScreen.routeName);
                                  },
                                  btnCancelOnPress: (){
                                  }
                              ).show();
                            },
                            leading: SvgPicture.asset(AppAssets.logoutMenuIcon),
                            title: Text(
                              'Log Out',
                              style: context.textTheme.titleSmall?.copyWith(
                                  color: AppColors.error, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget buildDrawerItems(BuildContext context, DrawerItem item) {
    bool isSelected = controller.selectedParentItem == item;
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

  Widget buildProfileDrawerItems(BuildContext context, DrawerItem item) {
    bool isSelected = controller.selectedParentItem == item;
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
                                    Expanded(
                                      child: Text(
                                        child,
                                        style: TextStyle(
                                          color: widget.selectedChild == child
                                              ? AppColors.accent
                                              : AppColors.textDarkPrimary,
                                          fontSize: 12,
                                        ),
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
