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
  final bool isMandatory;
  final bool? noTitle;

  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.items,
    this.noTitle,
    required this.isMandatory,
    required this.title,
    required this.itemLabel,
    required this.onChanged,
    required this.hintText,
    this.validator,
    this.value,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.noTitle == null)Column(
          children: [
            addH(16.h),
            widget.isMandatory ? RichFieldTitle(text: widget.title,) : FieldTitle(widget.title,),
            addH(8.h),
          ],
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
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            validator: widget.validator,
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
              height: 56,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.inputBorderColor),
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
          ),
        ),
      ],
    );
  }
}
