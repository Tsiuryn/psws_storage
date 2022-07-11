import 'package:flutter/material.dart';

mixin PswsSnackBar {
  void showRequestSnackBar(
    BuildContext context, {
    required String message,
    bool isSuccess = false,
  }) {
    var mainColor =
        isSuccess ? const Color(0xFF5AA580) : const Color(0xFFDD6952);
    var mainIcon = isSuccess ? Icons.check : Icons.close;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        children: [
          Icon(
            mainIcon,
            color: mainColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: mainColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.only(bottom: 12.0, left: 16.0, right: 16.0),
      behavior: SnackBarBehavior.floating,
    ));
  }
}
