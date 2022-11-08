import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';

class PswsInputSearch extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool autofocus;

  const PswsInputSearch({
    Key? key,
    this.onChanged,
    this.hintText,
    this.controller,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.autofocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return TextFormField(
      autofocus: autofocus,
      onChanged: onChanged,
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors?.textColor ?? Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppDim.thirtyTwo)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors?.textColor ?? Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppDim.thirtyTwo)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: appColors?.textColor ?? Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(AppDim.thirtyTwo)),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        isDense: true,
        hintText: hintText,
      ),
    );
  }
}
