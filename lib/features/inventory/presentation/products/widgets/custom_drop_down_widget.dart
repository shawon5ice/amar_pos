import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel; // A function to extract display text
  final void Function(T?) onChanged;
  final String hintText;
  final String title;
  final String searchHintText;
  final TextEditingController searchController;
  // final String? Function()? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.title,
    required this.itemLabel,
    required this.onChanged,
    required this.hintText,
    required this.searchHintText,
    this.value,
    required this.searchController,
    // this.validator,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        hint: Text(
          widget.hintText,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              widget.itemLabel(item),
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        )
            .toList(),
        value: widget.value,
        onChanged: widget.onChanged,
        buttonStyleData: ButtonStyleData(
          height: 58,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
        dropdownSearchData: DropdownSearchData(
          searchController: widget.searchController,
          searchInnerWidgetHeight: 58,
          searchInnerWidget: Container(
            height: 58,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: widget.searchController,
              validator: (value){
                if (widget.value == null) {
                  return "Please select a category";
                }
                return null;
              },
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: widget.searchHintText,
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return widget.itemLabel(item.value!)
                .toLowerCase()
                .contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            widget.searchController.clear();
          }
        },
      ),
    );
  }
}
