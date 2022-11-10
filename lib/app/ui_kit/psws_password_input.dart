import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PswsPasswordInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String placeholder;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const PswsPasswordInput({
    Key? key,
    required this.placeholder,
    this.keyboardType,
    this.inputFormatters,
    this.hintText,
    this.onChanged,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<PswsPasswordInput> createState() => _PswsPasswordInputState();
}

class _PswsPasswordInputState extends State<PswsPasswordInput> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      controller: widget.controller,
      validator: widget.validator,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
          labelText: widget.placeholder,
          isDense: true,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          )),
      obscureText: isObscure,
    );
  }
}
