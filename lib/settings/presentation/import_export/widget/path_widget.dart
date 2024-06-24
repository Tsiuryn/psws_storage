import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';

class PathWidget extends StatelessWidget {
  final String? path;
  final String btnTitle;
  final Widget btnSuffix;
  final VoidCallback? onTap;

  const PathWidget({
    Key? key,
    required this.btnTitle,
    required this.btnSuffix,
    this.onTap,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(context);
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDim.sixteen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.import_export_page__path,
            style: theme.appTextStyles?.titleMedium,
          ),
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: AppDim.eight),
                child: Text(
                  path ?? l10n.import_export_page__empty_path,
                  style: theme.appTextStyles?.subtitle,
                ),
              )),
            ],
          ),
          if (onTap != null)
            Row(
              children: [
                const Expanded(child: SizedBox()),
                TextButton(
                  onPressed: onTap,
                  child: Row(
                    children: [
                      Text(
                        btnTitle,
                        style: theme.appTextStyles?.subtitle,
                      ),
                      btnSuffix,
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
