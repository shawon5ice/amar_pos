import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    this.hintText = "Search...",
    this.backgroundColor = Colors.white,
    this.onChanged,
    this.debounceTime = const Duration(milliseconds: 300), // Add debounce time
  });

  final String hintText;
  final Color backgroundColor;
  final void Function(String)? onChanged;
  final Duration debounceTime; // Duration for the debounce

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _textController = TextEditingController();
  final _textChanges = PublishSubject<String>();

  @override
  void initState() {
    super.initState();
    _textChanges
        .debounceTime(widget.debounceTime)
        .listen((value) {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _textChanges.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search),
          addW(12), // Use extension for SizedBox
          Expanded(
            child: TextField(
              controller: _textController,
              onChanged: (value) {
                _textChanges.add(value);
              },
              onEditingComplete: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.onChanged != null && _textController.text.isNotEmpty) {
                  widget.onChanged!(_textController.text);
                }
              },
              onSubmitted: (v) {
                FocusManager.instance.primaryFocus?.unfocus();
                if (widget.onChanged != null && v.isNotEmpty) {
                  widget.onChanged!(v);
                }
              },
              decoration: InputDecoration(
                hintText: widget.hintText,
                isDense: true,
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