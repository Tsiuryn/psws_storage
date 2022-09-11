import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';

class IconWithTooltip extends StatefulWidget {
  final String message;
  final Widget icon;

  const IconWithTooltip({
    Key? key,
    required this.icon,
    required this.message,
  }) : super(key: key);

  @override
  State<IconWithTooltip> createState() => _IconWithTooltipState();
}

class _IconWithTooltipState extends State<IconWithTooltip> {
  final GlobalKey<TooltipState> tooltipKey = GlobalKey<TooltipState>();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      key: tooltipKey,
      message: widget.message,
      padding: const EdgeInsets.symmetric(
          vertical: AppDim.eight, horizontal: AppDim.eight),
      margin: const EdgeInsets.symmetric(horizontal: AppDim.eight),
      child: IconButton(
        onPressed: () {
          tooltipKey.currentState?.ensureTooltipVisible();
        },
        icon: widget.icon,
      ),
    );
  }
}
