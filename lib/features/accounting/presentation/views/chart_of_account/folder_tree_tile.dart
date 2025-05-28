import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'chart_node.dart';

class FolderTreeTile extends StatefulWidget {
  final ChartNode node;
  final List<ChartNode> siblings;
  final int depth;
  final bool isExpanded;
  final ValueChanged<int> onToggle;
  final ValueChanged<ChartNode> onLeafTap;

  const FolderTreeTile({
    super.key,
    required this.node,
    required this.siblings,
    required this.depth,
    required this.isExpanded,
    required this.onToggle,
    required this.onLeafTap,
  });

  @override
  State<FolderTreeTile> createState() => _FolderTreeTileState();
}

class _FolderTreeTileState extends State<FolderTreeTile>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final hasChildren = node.children.isNotEmpty;
    final icon = hasChildren ? Icons.folder : Icons.insert_drive_file;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          selected: widget.isExpanded,
          selectedTileColor: const Color(0xFF2C4E42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.only(left: 16.0 * widget.depth, right: 8),
          leading: Icon(
            icon,
            size: 18,
            color: widget.isExpanded ? Colors.orange : Colors.white,
          ),
          title: Text(
            node.data.name,
            style: TextStyle(
              fontSize: 13,
              color: widget.isExpanded ? Colors.orange : Colors.white,
              fontWeight: widget.isExpanded ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () {
            if (hasChildren) {
              widget.onToggle(node.data.id);
            } else {
              widget.onLeafTap(node);
            }
          },
        ),
        // Animated container for children
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 300),
          crossFadeState: widget.isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(left: 16.0 + 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // vertical connector line
                Container(
                  width: 2,
                  color: Colors.orange,
                  height: math.max(0, 18 * widget.siblings.length - 24),
                ),
                const SizedBox(width: 6),
                // child items with horizontal connectors
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: node.children.map((child) {
                      return Row(
                        children: [
                          Container(
                            width: 20,
                            height: 1,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: FolderTreeTile(
                              node: child,
                              siblings: node.children,
                              depth: widget.depth + 1,
                              isExpanded: widget.isExpanded,
                              onToggle: widget.onToggle,
                              onLeafTap: widget.onLeafTap,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
