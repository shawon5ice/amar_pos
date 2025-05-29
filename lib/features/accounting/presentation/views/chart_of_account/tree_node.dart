import 'package:animated_tree_view/animated_tree_view.dart';

import '../../../data/models/chart_of_account/chart_of_account_list_response_model.dart';

TreeNode<ChartOfAccountItem> buildTreeFromFlatList(List<ChartOfAccountItem> items) {
  // Map each item to a TreeNode
  final Map<int, TreeNode<ChartOfAccountItem>> nodeMap = {
    for (var item in items)
      item.id: TreeNode<ChartOfAccountItem>(
        key: item.id.toString(),
        data: item,
      )
  };

  // List to hold root nodes
  final List<TreeNode<ChartOfAccountItem>> rootNodes = [];

  // Establish parent-child relationships
  for (var item in items) {
    final currentNode = nodeMap[item.id]!;

    if (item.parentId != null && nodeMap.containsKey(item.parentId)) {
      nodeMap[item.parentId]!.add(currentNode); // Add as child
    } else {
      rootNodes.add(currentNode); // Add as root node
    }
  }

  // Create the root node
  final root = TreeNode<ChartOfAccountItem>(
    key: 'root',
    data: null,
  );

  // Add all root nodes to the root
  root.addAll(rootNodes);

  return root;
}
