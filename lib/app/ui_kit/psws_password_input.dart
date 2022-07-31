import 'package:flutter/material.dart';

class PswsPasswordInput extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String placeHolder;

  const PswsPasswordInput({
    Key? key,
    required this.placeHolder,
    this.onChanged,
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
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: widget.placeHolder,
          isDense: true,
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
