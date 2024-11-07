import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/model/config_item.dart';

class ConfigCard extends StatelessWidget {
  final ConfigItem item;

  const ConfigCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.orangeAccent),
      ),
      child: InkWell(
        onTap: () {
          // Add navigation or functionality here
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(item.asset, width: 32, height: 32,),
              const SizedBox(width: 16.0),
              Text(
                item.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.px),
              ),
            ],
          ),
        ),
      ),
    );
  }
}