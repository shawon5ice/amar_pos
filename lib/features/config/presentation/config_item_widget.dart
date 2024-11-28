import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../data/model/config_item.dart';

class ConfigCard extends StatelessWidget {
  final ConfigItem item;

  const ConfigCard({Key? key, required this.item}) : super(key: key);

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