import 'package:flutter/material.dart';


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
      padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
