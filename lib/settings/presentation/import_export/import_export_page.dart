import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/icon_with_tooltip.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/presentation/import_export/bloc/import_export_bloc.dart';
import 'package:psws_storage/settings/presentation/import_export/export/export_form.dart';
import 'package:psws_storage/settings/presentation/import_export/import/import_form.dart';

class ImportExportPage extends StatefulWidget {
  @QueryParam('page_type')
  final ImportExportPageType type;

  const ImportExportPage({Key? key, required this.type}) : super(key: key);

  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> with PswsSnackBar {
  bool get isImportPage => widget.type == ImportExportPageType.import;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImportExportBloc>(
      create: (context) => getIt.get<ImportExportBloc>(),
      child: BlocConsumer<ImportExportBloc, ImportExportState>(
        builder: _pageStateBuilder,
        listener: _pageStateListener,
      ),
    );
  }

  void _pageStateListener(BuildContext context, ImportExportState state) {
    final l10n = AppLocalizations.of(context);
    if (state.type == ImportExportStateType.error) {
      showRequestSnackBar(context, message: state.error ?? '');
    }
    if (state.type == ImportExportStateType.exportSuccess) {
      showRequestSnackBar(context,
          message: l10n?.export_form__export_success ?? '', isSuccess: true);
      context.popRoute();
    }
    if (state.type == ImportExportStateType.importSuccess) {
      getIt.get<MainBloc>().changeToDefaultState();
      showRequestSnackBar(context,
          message: l10n?.import_form__import_success ?? '', isSuccess: true);
      context.popRoute();
    }
  }

  Widget _pageStateBuilder(BuildContext context, ImportExportState state) {
    final l10n = AppLocalizations.of(context)!;
    final appTheme = AppTheme(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isImportPage
              ? l10n.import_export_page__import_appbar_title
              : l10n.import_export_page__export_appbar_title,
          style: appTheme.appTextStyles?.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: appTheme.appColors?.textColor,
          ),
          onPressed: context.popRoute,
        ),
        actions: [
          IconWithTooltip(
            message: isImportPage
                ? l10n.settings_page__import_tooltip
                : l10n.settings_page__export_tooltip,
            icon: SvgPicture.asset(
              AppIcons.icInformation,
              color: appTheme.appColors?.textColor,
            ),
          ),
        ],
        bottom: const PreferredSize(
          child: Divider(),
          preferredSize: Size.fromHeight(1),
        ),
      ),
      body: isImportPage ? ImportForm(state: state) : ExportForm(state: state),
    );
  }
}

enum ImportExportPageType { import, export }
