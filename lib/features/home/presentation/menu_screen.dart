import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? selectedParent;
  String? selectedChild;

  bool isSalesPanelExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerItem(
            context,
            icon: Icons.dashboard,
            title: 'Overview',
            onTap: () {
              _setSelectedItem('Overview');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            title: 'Inventory',
            onTap: () {
              _setSelectedItem('Inventory');
            },
          ),
          _buildCustomExpandableItem(
            context,
            isExpanded: isSalesPanelExpanded,
            onTap: (){
              setState(() {
                isSalesPanelExpanded = !isSalesPanelExpanded;
              });
            },

            icon: Icons.shopping_cart,
            title: 'Sales',
            children: [
              _buildDrawerItem(
                context,
                icon: Icons.read_more,
                title: 'Retail Sale',
                onTap: () {
                  _setSelectedChildItem('Sales', 'Retail Sale');
                },
              ),
              _buildDrawerItem(
                context,
                icon: Icons.access_alarm,
                title: 'Whole Sale',
                onTap: () {
                  _setSelectedChildItem('Sales', 'Whole Sale');
                },
              ),
            ],
          ),
          _buildDrawerItem(
            context,
            icon: Icons.autorenew,
            title: 'Return & Exchange',
            onTap: () {
              _setSelectedItem('Return & Exchange');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Purchase',
            onTap: () {
              _setSelectedItem('Purchase');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.account_balance,
            title: 'Accounting',
            onTap: () {
              _setSelectedItem('Accounting');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.bar_chart,
            title: 'Reports',
            onTap: () {
              _setSelectedItem('Reports');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'Config',
            onTap: () {
              _setSelectedItem('Config');
            },
          ),
          Divider(),
          _buildDrawerItem(
            context,
            icon: Icons.feedback,
            title: 'Feedback',
            onTap: () {
              _setSelectedItem('Feedback');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.video_call,
            title: 'Training Session',
            onTap: () {
              _setSelectedItem('Training Session');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.group,
            title: 'Join Community',
            onTap: () {
              _setSelectedItem('Join Community');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.subscriptions,
            title: 'Subscription',
            onTap: () {
              _setSelectedItem('Subscription');
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              _setSelectedItem('Help & Support');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Function onTap,
      }) {
    final isSelected = selectedParent == title;
    return ListTile(
      leading: icon != null ? Icon(icon, color: isSelected ? Colors.orange : null) : null,
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.orange : null),
      ),
      onTap: () {
        onTap();
        Navigator.pop(context); // Close the drawer
      },
    );
  }

  Widget _buildExpandableItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required List<Widget> children,
      }) {
    final isExpanded = selectedParent == title;
    return ExpansionTile(
      leading: Icon(icon, color: isExpanded ? Colors.orange : null),
      title: Text(
        title,
        style: TextStyle(color: isExpanded ? Colors.orange : null),
      ),
      children: children,
      dense: true,

      visualDensity: VisualDensity.compact,
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      onExpansionChanged: (isExpanded) {
        setState(() {
          selectedParent = isExpanded ? title : null;
          selectedChild = null;
        });
      },
    );
  }

  Widget _buildCustomExpandableItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required bool isExpanded,
        required Function onTap,
        required List<Widget> children,
      }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            onTap();
          },
          child: Container(
            color: isExpanded ? Colors.black12 : Colors.transparent,
            child: ListTile(
              leading: Icon(icon, color: isExpanded ? Colors.orange : null),
              title: Text(
                title,
                style: TextStyle(color: isExpanded ? Colors.orange : null),
              ),
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: children.map((child) {
              return child;
            }).toList(),
          ),
      ],
    );
  }

  void _setSelectedItem(String title) {
    setState(() {
      selectedParent = title;
      selectedChild = null;
    });
  }

  void _setSelectedChildItem(String parent, String child) {
    setState(() {
      selectedParent = parent;
      selectedChild = child;
    });
  }
}