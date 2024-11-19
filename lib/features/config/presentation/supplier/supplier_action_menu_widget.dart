import 'package:flutter/material.dart';

class ActionMenu extends StatelessWidget {
  final Function(String) onSelected;

  const ActionMenu({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
        width: 28,
      child: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        menuPadding: EdgeInsets.zero,
        icon: const Icon(Icons.more_vert, color: Colors.black54),
        offset: const Offset(-24, 0), // Position to the left of the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        popUpAnimationStyle: AnimationStyle(curve: Curves.fastOutSlowIn),
        splashRadius: 12,
        onSelected: (value) {
          // Handle menu item selection
          switch (value) {
            case 'repair':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Repair selected for Item=')),
              );
              break;
            case 'replace':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Replace Request selected for Item =')),
              );
              break;
            case 'reject':
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Reject selected for Item=')),
              );
              break;
          }
        },
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem<String>(
              value: 'repair',
              child: Row(
                children: const [
                  Icon(Icons.build, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Repair"),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'replace',
              child: Row(
                children: const [
                  Icon(Icons.sync, color: Colors.black54),
                  SizedBox(width: 8),
                  Text("Replace Request"),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'reject',
              child: Row(
                children: const [
                  Icon(Icons.cancel, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Reject",
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