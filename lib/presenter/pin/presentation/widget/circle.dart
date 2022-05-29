import 'package:flutter/material.dart';

@immutable
class CircleUIConfig {
  static const _defaultCircleSize = 16.0;

  final Color filledColor;
  final Color emptyColor;
  final double circleSize;

  const CircleUIConfig({
    this.filledColor = Colors.blue,
    this.emptyColor = Colors.grey,
    this.circleSize = _defaultCircleSize,
  });
}

class Circle extends StatelessWidget {
  final bool filled;
  final CircleUIConfig circleUIConfig;
  final double extraSize;

  const Circle({
    Key? key,
    this.filled = false,
    required this.circleUIConfig,
    this.extraSize = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: circleUIConfig.circleSize,
      height: circleUIConfig.circleSize,
      child: Container(
        margin: EdgeInsets.only(bottom: extraSize),
        decoration: BoxDecoration(
          color:
              filled ? circleUIConfig.filledColor : circleUIConfig.emptyColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
      ),
    );
  }
}
