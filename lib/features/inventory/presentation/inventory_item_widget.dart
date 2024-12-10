import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/inventory_item_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class InventoryCard extends StatelessWidget {
  final InventoryItem item;

  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: Colors.orangeAccent),
      ),
      child: InkWell(
        onTap: item.onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(item.asset, width: 32.pw(context), height: 32.ph(context),),
              addW(16.pw(context)),
              AutoSizeText(
                item.title,
                maxFontSize: 16,
                maxLines: 1,
                style: context.textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}