import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/res/app_localizations.dart';

void showPathBottomSheet(BuildContext context, {required String path}) {
  final l10n = AppLocalizations.of(context);
  final pathPrefix = l10n.import_export_page__path;

  showModalBottomSheet(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      )),
      backgroundColor: AppTheme(context).appColors?.appBarColor,
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: pathPrefix,
                      style: AppTheme(context).appTextStyles?.titleMedium,
                    ),
                    TextSpan(
                      text: ' $path',
                      style: AppTheme(context).appTextStyles?.subtitle,
                    )
                  ]),
                ),
              ),
              const SizedBox(
                height: AppDim.eight,
              ),
            ],
          ),
        );
      });
}
