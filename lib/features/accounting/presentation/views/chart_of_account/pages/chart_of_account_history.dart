// import 'package:flutter/material.dart';
// import 'package:animated_tree_view/animated_tree_view.dart';
//
// import '../../../../data/models/chart_of_account/chart_of_account_list_response_model.dart' as ca;
// import '../../../../data/models/chart_of_account/chart_of_account_list_response_model.dart';
// import '../tree_node.dart';
//
// class ChartTreeView extends StatelessWidget {
//   final List<ca.ChartOfAccountItem> items;
//
//   const ChartTreeView({Key? key, required this.items}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final tree = buildTreeFromFlatList(items);
//
//     return TreeView.simpleTyped<ChartOfAccountItem, TreeNode<ChartOfAccountItem>>(
//       tree: tree, // This must be of type TreeNode<ChartOfAccountItem>
//       showRootNode: false,
//       indentation: const Indentation(
//         style: IndentStyle.roundJoint,
//         width: 24,
//         color: Colors.orange,
//         thickness: 2,
//       ),
//       // expansionIndicatorBuilder: (context, node) {
//         // if (!node.hasChildren) return ExpansionIndicator.none();
//         // return ExpansionIndicator.icon(
//         //   icon: node.isExpanded ? Icons.expand_more : Icons.chevron_right,
//         // );
//       // },
//       builder: (context, node) {
//         final item = node.data!;
//         final isLeaf = node.children.isNotEmpty;
//
//         return ListTile(
//           leading: Icon(isLeaf ? Icons.insert_drive_file : Icons.folder),
//           title: Text(item.name),
//           subtitle: item.business != null ? Text(item.business!.name) : null,
//         );
//       },
//     );
//   }
// }
