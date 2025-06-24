import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';

class StockTransferItemActionMenu extends StatelessWidget {
  final Function(String) onSelected;

  final bool enableEdit;
  final bool enableReceive;
  const StockTransferItemActionMenu({super.key, required this.onSelected,required this.enableEdit,required this.enableReceive});

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
            if(enableReceive) const PopupMenuItem<String>(
              value: 'receive',
              child: Row(
                children: const [
                  Icon(Icons.check_circle_outline, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text("Receive",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            if(enableEdit) const PopupMenuItem<String>(
              value: 'edit',
              child: Row(
                children: const [
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