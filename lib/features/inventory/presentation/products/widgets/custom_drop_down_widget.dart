import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/responsive/pixel_perfect.dart';
import '../../../../../core/widgets/field_title.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel; // A function to extract display text
  final void Function(T?) onChanged;
  final String hintText;
  final String title;
  final String searchHintText;
  final bool isMandatory;

  // final String? Function()? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.title,
    required this.itemLabel,
    required this.onChanged,
    required this.hintText,
    required this.searchHintText,
    required this.isMandatory,
    this.value,
    // this.validator,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        addH(16.h),
        widget.isMandatory ? RichFieldTitle(text: widget.title,) : FieldTitle(widget.title,),
        addH(8.h),
        DropdownButtonHideUnderline(
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
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: _textEditingController,
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
                  controller: _textEditingController,
                  validator: (value) {
                    if (widget.value == null && widget.isMandatory) {
                      return "Please select a ${widget.title}";
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
                return widget
                    .itemLabel(item.value!)
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                _textEditingController.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}
