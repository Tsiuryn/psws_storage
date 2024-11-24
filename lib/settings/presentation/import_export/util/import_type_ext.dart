import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';

extension ImportTypeExt on ImportType {
  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case ImportType.rewrite:
        return l10n.import_form__type_rewrite;
      case ImportType.add:
        return l10n.import_form__type_add;
    }
  }
}
