import 'dart:async';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textCon;
  final TextInputAction? textInputAction;
  final String? prefixIcon;
  final String? initialValue;
  final Widget? suffixWidget;
  final String hintText;
  final Widget? prefixWidget;
  final bool isPassField;
  final bool readOnly;
  final TextInputType inputType;
  final double width, height;
  final FontWeight txtFontWeight;
  final Color fillClr, brdrClr, txtClr, disableClr;
  final double brdrRadius, txtSize, contentPadding;
  final bool enabledFlag;
  final String? errorText;
  final int maxLine;
  final int? maxLength;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool isCenterAlign;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted; // Updated to pass value
  final void Function()? onTap;
  final void Function(String)? onEditStop;
  final bool? noInputBorder;

  final Duration debounceDuration; // New property for debounce duration

  const CustomTextField({
    super.key,
    this.initialValue,
    required this.textCon,
    this.textInputAction,
    this.contentPadding = 15,
    required this.hintText,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixWidget,
    this.isPassField = false,
    this.readOnly = false,
    this.inputType = TextInputType.text,
    this.width = double.infinity,
    this.height = 56,
    this.txtFontWeight = FontWeight.normal,
    this.fillClr = Colors.white,
    this.brdrClr = AppColors.inputBorderColor,
    this.txtClr = Colors.black,
    this.disableClr = const Color(0xfff6f6f6),
    this.brdrRadius = 8.0,
    this.txtSize = 16,
    this.enabledFlag = true,
    this.errorText,
    this.maxLine = 1,
    this.maxLength,
    this.focusNode,
    this.inputFormatters,
    this.isCenterAlign = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onEditStop,
    this.noInputBorder,
    this.debounceDuration = const Duration(milliseconds: 300), // Default debounce duration
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool obscureText;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassField;
  }

  @override
  void dispose() {
    _debounce?.cancel();

    super.dispose();
  }

  void _onChangedDebounced(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        controller: widget.textCon,
        readOnly: widget.readOnly,
        enabled: widget.enabledFlag,
        focusNode: widget.focusNode,
        keyboardType: widget.inputType,
        maxLength: widget.maxLength,
        maxLines: widget.maxLine,
        obscureText: obscureText,
        cursorColor: AppColors.primary,
        textAlign: widget.isCenterAlign ? TextAlign.center : TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontSize: widget.txtSize,
          fontWeight: widget.txtFontWeight,
          color: widget.enabledFlag ? widget.txtClr : Colors.grey.shade800,
        ),
        validator: widget.validator,
        inputFormatters: widget.inputFormatters,
        onChanged: _onChangedDebounced,
        onTap: widget.onTap ?? () {
          if (widget.textCon.text == "0") {
            widget.textCon.clear();
          }
        },

        onFieldSubmitted: (value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value); // Trigger feedback callback
          }
        },
        decoration: _buildInputDecoration(),
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: widget.enabledFlag ? widget.fillClr : widget.disableClr,
      contentPadding: EdgeInsets.all(widget.contentPadding),
      border: _getInputBorder(),
      enabledBorder: _getInputBorder(),
      focusedBorder: _getInputBorder(),
      prefixIcon: widget.prefixWidget != null ? widget.prefixWidget! : widget.prefixIcon != null
          ? Padding(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          'assets/icon/${widget.prefixIcon!}.svg',
          fit: BoxFit.cover,
          color: AppColors.accent,
        ),
      )
          : null,
      hintText: widget.hintText,
      hintStyle: TextStyle(
        fontSize: widget.txtSize,
        color: const Color(0xff909090),
        fontWeight: widget.txtFontWeight,
      ),
      suffixIcon: widget.suffixWidget ??
          (widget.isPassField
              ? IconButton(
            onPressed: () => setState(() => obscureText = !obscureText),
            icon: Icon(
              obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey.shade600,
            ),
          )
              : null),
    );
  }

  InputBorder _getInputBorder() {
    if(widget.noInputBorder != null){
      return InputBorder.none;
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.brdrRadius),
      borderSide: BorderSide(
        color: widget.enabledFlag ? widget.brdrClr : Colors.transparent,
        width: widget.enabledFlag ? 1 : 0,
      ),
    );
  }
}
