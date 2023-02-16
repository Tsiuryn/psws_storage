import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// The default size of the icon of a button.
const double kDefaultIconSize = 18;

// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    required this.icon,
    required this.onPressed,
    this.afterPressed,
    this.size = kDefaultIconSize,
    this.fillColor,
    this.hoverElevation = 1,
    this.highlightElevation = 1,
    this.borderRadius = 4,
    this.iconTheme,
    Key? key,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? afterPressed;
  final IconData icon;
  final double size;
  final Color? fillColor;
  final double hoverElevation;
  final double highlightElevation;
  final double borderRadius;
  final QuillIconTheme? iconTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = iconTheme?.iconUnselectedColor ?? theme.iconTheme.color;
    final iconFillColor =
        iconTheme?.iconUnselectedFillColor ?? (fillColor ?? theme.canvasColor);
    final rightSize = size * kIconButtonFactor;

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: rightSize, height: rightSize),
      child: RawMaterialButton(
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        fillColor: iconFillColor,
        elevation: 0,
        hoverElevation: hoverElevation,
        highlightElevation: hoverElevation,
        onPressed: () {
          onPressed?.call();
          afterPressed?.call();
        },
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
