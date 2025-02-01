import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerticalFieldTitleWithValue extends StatelessWidget {
  const VerticalFieldTitleWithValue({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xff7C7C7C), fontSize: 12),
        ),
        AutoSizeText(
          value,
          maxFontSize: 16,
          minFontSize: 12,
          style: context.textTheme.headlineSmall
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
