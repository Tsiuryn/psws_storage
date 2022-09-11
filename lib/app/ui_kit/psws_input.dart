import 'package:flutter/material.dart';

class PswsInput extends StatelessWidget {
  final String placeholder;
  final String? hintText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;

  const PswsInput({
    Key? key,
    required this.placeholder,
    this.onChanged,
    this.hintText,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: placeholder,
        hintText: hintText,
      ),
    );
  }
}
