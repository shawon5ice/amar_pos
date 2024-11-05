import 'package:amar_pos/core/constants/app_assets.dart';

import 'drawer_item.dart';
import 'package:flutter/material.dart';

class DrawerItems{
  static DrawerItem overview = DrawerItem(title: 'Overview', icon: AppAssets.overviewMenuIcon);
  static DrawerItem inventory = DrawerItem(title: 'Inventory', icon: AppAssets.inventoryMenuIcon);
  static DrawerItem sales = DrawerItem(title: 'Sales', icon: AppAssets.salesMenuIcon);
  static DrawerItem returnAndExchange = DrawerItem(title: 'Return & Exchange', icon: AppAssets.salesMenuIcon);
  static DrawerItem purchase = DrawerItem(title: 'Purchase', icon: AppAssets.purchaseMenuIcon);
  static DrawerItem accounting = DrawerItem(title: 'Accounting', icon: AppAssets.accountingMenuIcon);
  static DrawerItem reports = DrawerItem(title: 'Reports', icon: AppAssets.reportsMenuIcon);
  static DrawerItem config = DrawerItem(title: 'Config', icon: AppAssets.configMenuIcon);

  static DrawerItem feedback = DrawerItem(title: 'Feedback', icon: AppAssets.feedbackMenuIcon);
  static DrawerItem trainingSession = DrawerItem(title: 'Training Session', icon: AppAssets.trainingSessionMenuIcon);
  static DrawerItem joinCommunity = DrawerItem(title: 'Join Community', icon: AppAssets.joinCommunityMenuIcon);
  static DrawerItem subscription = DrawerItem(title: 'Subscription', icon: AppAssets.subscriptionMenuIcon);
  static DrawerItem helpAndSupport = DrawerItem(title: 'Help & Support', icon: AppAssets.helpNSupportMenuIcon);

  static List<DrawerItem> all = [
    overview,
    inventory,
    sales,
    returnAndExchange,
    purchase,
    accounting,
    reports,
    config,
  ];
}