import 'package:flutter/material.dart';

class PswsInput extends StatelessWidget {
  final String placeholder;
  final String? hintText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool autofocus;
  final String? initialValue;

  const PswsInput(
      {Key? key,
      required this.placeholder,
      this.initialValue,
      this.onChanged,
      this.hintText,
      this.controller,
      this.validator,
      this.autofocus = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      autofocus: autofocus,
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        isDense: true,
        labelText: placeholder,
        hintText: hintText,
      ),
    );
  }
}
