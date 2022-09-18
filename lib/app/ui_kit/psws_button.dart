import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';

class PswsButton extends StatelessWidget {
  final bool enabled;
  final Widget content;
  final VoidCallback onPressed;
  final Color? enableColor;
  final Color? disableColor;

  const PswsButton({
    Key? key,
    required this.content,
    required this.onPressed,
    this.enabled = true,
    this.enableColor,
    this.disableColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(context);
    const defaultSize = Size(208, 40);

    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      child: content,
      style: TextButton.styleFrom(
          backgroundColor: _getBackGroundColor(appTheme),
          elevation: enabled ? AppDim.four : 0,
          minimumSize: defaultSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDim.sixteen),
          )),
    );
  }

  Color? _getBackGroundColor(AppTheme appTheme) {
    final enableColorButton =
        enableColor ?? appTheme.appColors?.positiveActionColor;
    final disableColorButton = disableColor ?? appTheme.appColors?.cardColor;

    return enabled ? enableColorButton : disableColorButton;
  }
}

class ButtonText extends StatelessWidget {
  final bool enabled;
  final String data;
  final TextStyle? enableStyle;
  final TextStyle? disableStyle;

  const ButtonText(
    this.data, {
    Key? key,
    this.enabled = true,
    this.enableStyle,
    this.disableStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(context);

    return Text(
      data,
      style: _getTextStyle(appTheme),
    );
  }

  TextStyle? _getTextStyle(AppTheme appTheme) {
    final disableStyleText = enableStyle ??
        appTheme.appTextStyles?.titleMedium?.copyWith(
          color: appTheme.appColors?.dividerColor,
        );
    final enableStyleText = disableStyle ??
        appTheme.appTextStyles?.titleMedium?.copyWith(
          color: const Color(0xFFFFFFFF),
        );
    return enabled ? enableStyleText : disableStyleText;
  }
}
