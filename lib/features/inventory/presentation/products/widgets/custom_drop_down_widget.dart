import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/field_title.dart';

class CustomDropdownWithSearchWidget<T> extends StatefulWidget {
  final List<T> items;
  final T? value;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final String hintText;
  final String title;
  final String searchHintText;
  final bool isMandatory;
  final bool noTitle;
  final String? Function(T?)? validator;

  const CustomDropdownWithSearchWidget({
    super.key,
    required this.items,
    required this.isMandatory,
    required this.title,
    required this.itemLabel,
    required this.onChanged,
    required this.hintText,
    required this.searchHintText,
    this.validator,
    this.value,
    this.noTitle = false,
  });

  @override
  State<CustomDropdownWithSearchWidget<T>> createState() =>
      _CustomDropdownWithSearchWidgetState<T>();
}

class _CustomDropdownWithSearchWidgetState<T>
    extends State<CustomDropdownWithSearchWidget<T>> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
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
        if (!widget.noTitle)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: widget.isMandatory
                ? RichFieldTitle(text: widget.title)
                : FieldTitle(widget.title),
          ),
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<T>(
            isExpanded: true,
            hint: Text(
              widget.hintText,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).hintColor,
              ),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.inputBorderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: AppColors.inputBorderColor,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red, // Red border for error state
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.red,
                ),
              ),
            ),
            validator: widget.isMandatory
                ? widget.validator ??
                    (value) {
                  if (value == null) {
                    return "This field is required.";
                  }
                  return null;
                }
                : widget.validator,
            items: widget.items
                .map(
                  (item) => DropdownMenuItem<T>(
                    alignment: Alignment.centerLeft,
                value: item,
                child: Text(
                  widget.itemLabel(item),
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.visible,
                ),
              ),
            )
                .toList(),

            value: widget.value,
            onChanged: (value) {
              widget.onChanged(value);
            },
            buttonStyleData: ButtonStyleData(
              height: 48,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorderColor),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300,
              // width: context.width - 100,
              // offset: Offset(0, 48),
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
              searchInnerWidgetHeight: 48,
              searchInnerWidget: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
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
                _textEditingController.clear();
              }
            },
          ),
        ),
      ],
    );
  }
}
