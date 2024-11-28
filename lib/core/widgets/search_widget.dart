import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
    this.hintText = "Search...",
    this.backgroundColor = Colors.white,
    this.onChanged,
  });

  final String hintText;
  final Color backgroundColor;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12,bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search),
          addW(12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                isDense: true,

                // prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                fillColor: Colors.white,

              ),
              style: context.textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
