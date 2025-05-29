import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'chart_node.dart';

class ChartTreeView extends StatefulWidget {
  final List<ChartNode> nodes;

  const ChartTreeView({super.key, required this.nodes});

  @override
  State<ChartTreeView> createState() => _ChartTreeViewState();
}


class _ChartTreeViewState extends State<ChartTreeView> {
  final Map<int, bool> _expanded = {};

  void _collapseDescendants(ChartNode node) {
    for (var child in node.children) {
      _expanded[child.data.id] = false;
      _collapseDescendants(child); // recursively clear child states
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.nodes.map((node) {
        return _buildNode(
          node,
          siblings: widget.nodes,
          depth: 0,
        );
      }).toList(),
    );

  }

  Widget _buildNode(
      ChartNode node, {
        required List<ChartNode> siblings,
        int depth = 0,
      }) {
    final isExpanded = _expanded[node.data.id] ?? false;
    final hasChildren = node.children.isNotEmpty;

    int multiLineCount =  0;

    siblings.forEach((e){
      if(e.data.business != null){
        multiLineCount++;
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          // onTap: hasChildren
          //     ? () {
          //   setState(() {
          //     for (var sibling in siblings) {
          //       if (sibling.data.id != node.data.id) {
          //         _expanded[sibling.data.id] = false;
          //       }
          //     }
          //     _expanded[node.data.id] = !isExpanded;
          //   });
          // }
          //     : null,
          onTap: hasChildren
              ? () {
            setState(() {
              final newState = !isExpanded;

              // Collapse all siblings
              for (var sibling in siblings) {
                if (sibling.data.id != node.data.id) {
                  _expanded[sibling.data.id] = false;
                  _collapseDescendants(sibling); // collapse their children too
                }
              }

              // Update current node state
              _expanded[node.data.id] = newState;

              // If collapsing, clear its own children
              if (!newState) {
                _collapseDescendants(node);
              }
            });
          }
              : null,

          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: hasChildren && isExpanded
                ? BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(12),
            )
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon( hasChildren && ! isExpanded ? Icons.folder  : hasChildren && isExpanded ? Icons.folder_open : Icons.insert_drive_file,
                  color: hasChildren && isExpanded ? Colors.white : Colors.orange.shade200,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        node.data.name,
                        style: TextStyle(
                          color: hasChildren && isExpanded ? Colors.white : Colors.grey.shade700,
                          fontWeight: hasChildren ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                      if(node.data.business != null )Row(
                        children: [
                          Text(
                            node.data.business!.name,
                            style: TextStyle(
                              color: hasChildren && isExpanded ? Colors.white : Colors.grey.shade700,
                              fontWeight: hasChildren ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                          if(node.data.store != null)Text(
                            "(${node.data.store!.name})",
                            style: TextStyle(
                              color: hasChildren && isExpanded ? Colors.white : Colors.grey.shade700,
                              fontWeight: hasChildren ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInCubic,
          alignment: Alignment.topCenter,
          child: (hasChildren && isExpanded)
              ? Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Stack(
              children: [
                // 🔶 Vertical Line
                Positioned(
                  left: 12,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    width: 2,
                    color: Colors.orange,
                  ),
                ),
                // 🔶 Children with horizontal connector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: node.children.map((child) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 36,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: const EdgeInsets.only(top: 24),
                              width: 24,
                              height: 2,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildNode(
                            child,
                            siblings: node.children,
                            depth: depth + 1,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }


}
