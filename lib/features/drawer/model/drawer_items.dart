import 'package:amar_pos/core/constants/app_assets.dart';

import 'drawer_item.dart';
import 'package:flutter/material.dart';

class DrawerItems{
  static const DrawerItem overview = DrawerItem(title: 'Overview', icon: AppAssets.overviewMenuIcon);
  static const DrawerItem inventory = DrawerItem(title: 'Inventory', icon: AppAssets.inventoryMenuIcon);
  static const DrawerItem sales = DrawerItem(title: 'Sales', icon: AppAssets.salesMenuIcon);
  static const DrawerItem returnAndExchange = DrawerItem(title: 'Return & Exchange', icon: AppAssets.salesMenuIcon);
  static const DrawerItem purchase = DrawerItem(title: 'Purchase', icon: AppAssets.purchaseMenuIcon);
  static const DrawerItem accounting = DrawerItem(title: 'Accounting', icon: AppAssets.accountingMenuIcon);
  static const DrawerItem reports = DrawerItem(title: 'Reports', icon: AppAssets.reportsMenuIcon);
  static const DrawerItem config = DrawerItem(title: 'Config', icon: AppAssets.configMenuIcon);
  static const DrawerItem feedback = DrawerItem(title: 'Feedback', icon: AppAssets.feedbackMenuIcon);
  static const DrawerItem trainingSession = DrawerItem(title: 'Training Session', icon: AppAssets.trainingSessionMenuIcon);
  static const DrawerItem joinCommunity = DrawerItem(title: 'Join Community', icon: AppAssets.joinCommunityMenuIcon);
  static const DrawerItem subscription = DrawerItem(title: 'Subscription', icon: AppAssets.subscriptionMenuIcon);
  static const DrawerItem helpAndSupport = DrawerItem(title: 'Help & Support', icon: AppAssets.helpNSupportMenuIcon);

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