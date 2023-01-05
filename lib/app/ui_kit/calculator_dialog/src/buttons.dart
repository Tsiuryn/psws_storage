import 'package:flutter/material.dart';

// creating Stateless Widget for buttons
class MyButton extends StatelessWidget {
// declaring variables
  final Color color;
  final Color textColor;
  final String buttonText;
  final VoidCallback? onPressed;

//Constructor
  const MyButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.zero,
        height: 30,
        width: 30,
        color: color,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 25,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
