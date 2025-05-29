import 'package:animated_tree_view/animated_tree_view.dart';

import '../../../data/models/chart_of_account/chart_of_account_list_response_model.dart';

class ChartNode {
  final ChartOfAccountItem data;
  final List<ChartNode> children;

  ChartNode({
    required this.data,
    List<ChartNode>? children,
  }) : children = children ?? [];
}


List<ChartNode> buildChartTree(List<ChartOfAccountItem> items) {
  final Map<int, ChartNode> nodeMap = {};
  final List<ChartNode> roots = [];

  for (final item in items) {
    nodeMap[item.id] = ChartNode(data: item);
  }

  for (final item in items) {
    final root = item.root;
    if (root != null && nodeMap.containsKey(root.id)) {
      nodeMap[root.id]!.children.add(nodeMap[item.id]!);
    } else {
      roots.add(nodeMap[item.id]!);
    }
  }

  return roots;
}

TreeNode<ChartOfAccountItem> buildChartTreeNode(List<ChartOfAccountItem> items) {
  final Map<int, ChartNode> nodeMap = {};
  final List<ChartNode> roots = [];

  for (final item in items) {
    nodeMap[item.id] = ChartNode(data: item);
  }

  for (final item in items) {
    final root = item.root;
    if (root != null && nodeMap.containsKey(root.id)) {
      nodeMap[root.id]!.children.add(nodeMap[item.id]!);
    } else {
      roots.add(nodeMap[item.id]!);
    }
  }

  return TreeNode();
}
