import 'package:flutter/material.dart';
import 'package:psws_storage/app/theme/app_theme.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            color: context.appColors.positiveActionColor,
          ),
          Text(
            title,
            style: AppTheme(context).appTextStyles?.titleMedium?.copyWith(
                  color: context.appColors.positiveActionColor,
                ),
          ),
        ],
      ),
    );
  }
}
