import 'package:flutter/material.dart';

class PswsPasswordInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String placeHolder;
  final String? hintText;
  final TextEditingController? controller;

  const PswsPasswordInput(
      {Key? key,
      required this.placeHolder,
      required this.hintText,
      this.onChanged,
      this.controller})
      : super(key: key);

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
      decoration: InputDecoration(
          labelText: widget.placeHolder,
          isDense: true,
          hintText: widget.hintText,
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
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
