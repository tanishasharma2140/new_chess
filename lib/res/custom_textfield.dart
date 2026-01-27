import 'package:new_chess/res/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextStyle? hintStyle;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final Color? borderColor;
  final Color? filledColor;
  final Color? focusedBorderColor;
  final Color? iconColor;
  final double? height;
  final bool obscureText;
  final bool readOnly;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.borderColor,
    this.filledColor,
    this.focusedBorderColor,
    this.iconColor,
    this.height,
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 60.0,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(color: ChessColor.white),
        obscureText: isObscured,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: widget.hintStyle ??
              const TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: widget.iconColor ?? Colors.black)
              : null,
          suffixIcon: widget.suffixIcon != null
              ? GestureDetector(
                  onTap: widget.onSuffixTap ??
                      () {
                        setState(() {
                          isObscured = !isObscured;
                        });
                      },
                  child: Icon(
                    widget.suffixIcon,
                    color: widget.iconColor ?? Colors.black,
                  ),
                )
              : null,
          filled: true,
          fillColor: widget.filledColor ?? Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide:
                BorderSide(color: widget.borderColor ?? Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
                color: widget.focusedBorderColor ?? Colors.blue, width: 1),
          ),
        ),
      ),
    );
  }
}
