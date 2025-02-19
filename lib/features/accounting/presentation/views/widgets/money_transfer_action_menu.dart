import 'package:flutter/material.dart';

class MoneyTransferActionMenu extends StatelessWidget {
  final Function(String) onSelected;
  final int status;

  const MoneyTransferActionMenu({super.key, required this.onSelected, required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      width: 28,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.more_vert, color: Colors.black54),
        offset: const Offset(-24, 0), // Position to the left of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        popUpAnimationStyle: AnimationStyle(curve: Curves.fastOutSlowIn),
        splashRadius: 12,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) {
          return [
            const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Edit"),
                ],
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_forever, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ];
        },
        color: Colors.white, // Background color of the dropdown
        elevation: 8, // Elevation of the dropdown
      ),
    );
  }
}