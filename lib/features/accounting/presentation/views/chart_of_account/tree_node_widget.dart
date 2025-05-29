// import 'package:flutter/material.dart';
// import 'chart_node.dart';
//
// class TreeNodeWidget extends StatelessWidget {
//   final ChartNode node;
//   final List<ChartNode> siblings;
//   final int depth;
//   final bool isExpanded;
//   final Function(int id) onToggle;
//   final Function(ChartNode node) onLeafTap;
//   final Map<int, bool> expandedState;
//
//   const TreeNodeWidget({
//     super.key,
//     required this.node,
//     required this.siblings,
//     required this.depth,
//     required this.isExpanded,
//     required this.onToggle,
//     required this.onLeafTap,
//     required this.expandedState,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final hasChildren = node.children.isNotEmpty;
//     final icon = hasChildren
//         ? (isExpanded ? Icons.folder_open : Icons.folder)
//         : Icons.insert_drive_file;
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: hasChildren ? () => onToggle(node.data.id) : () => onLeafTap(node),
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: hasChildren && isExpanded
//                 ? BoxDecoration(
//               color: const Color(0xFF2C4E42),
//               borderRadius: BorderRadius.circular(12),
//             )
//                 : null,
//             child: Row(
//               children: [
//                 Icon(
//                   icon,
//                   color: hasChildren && isExpanded ? Colors.orange : Colors.orange.shade200,
//                   size: 18,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   node.data.name,
//                   style: TextStyle(
//                     color: hasChildren && isExpanded ? Colors.orange : Colors.grey.shade700,
//                     fontWeight: hasChildren ? FontWeight.bold : FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         AnimatedSize(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInCubic,
//           child: (hasChildren && isExpanded)
//               ? Padding(
//             padding: const EdgeInsets.only(left: 24),
//             child: Column(
//               children: node.children.map((child) {
//                 return TreeNodeWidget(
//                   node: child,
//                   siblings: node.children,
//                   depth: depth + 1,
//                   isExpanded: expandedState[child.data.id] ?? false,
//                   onToggle: onToggle,
//                   onLeafTap: onLeafTap,
//                   expandedState: expandedState,
//                 );
//               }).toList(),
//             ),
//           )
//               : const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }
// }
