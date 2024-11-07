import 'package:amar_pos/features/drawer/model/drawer_item.dart';

class MenuSelection {
  final DrawerItem parent;
  final String? child; // Nullable if no child is selected

  MenuSelection({required this.parent, this.child});
}
