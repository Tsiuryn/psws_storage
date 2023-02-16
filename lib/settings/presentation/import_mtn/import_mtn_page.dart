import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_button.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/res/resources.dart';
import 'package:psws_storage/settings/presentation/import_mtn/bloc/import_mtn_bloc.dart';

class ImportMtnPage extends StatefulWidget {
  const ImportMtnPage({Key? key}) : super(key: key);

  @override
  State<ImportMtnPage> createState() => _ImportMtnPageState();
}

class _ImportMtnPageState extends State<ImportMtnPage> with PswsSnackBar {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTheme = AppTheme(context);

    return LifeCycleWidget(
      router: context.router,
      currentRouteName: ImportMtnRoute.name,
      child: BlocProvider(
        create: (context) => getIt.get<ImportMtnBloc>(),
        child: BlocConsumer<ImportMtnBloc, ImportMtnState>(
          builder: (BuildContext context, ImportMtnState state) {
            return Scaffold(
              appBar: AppBar(
                title: FittedBox(
                  child: Text(
                    l10n?.import_mtn_appbar_title ?? '',
                    style: appTheme.appTextStyles?.titleLarge,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: appTheme.appColors?.textColor,
                  ),
                  onPressed: context.popRoute,
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      context.pushRoute(const ImportMtnInfoRoute());
                    },
                    icon: SvgPicture.asset(
                      AppIcons.icInformation,
                      color: appTheme.appColors?.textColor,
                    ),
                  )
                ],
                bottom: const PreferredSize(
                  child: Divider(),
                  preferredSize: Size.fromHeight(1),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: PswsButton(
                content: ButtonText(l10n?.import_mtn_btn_title ?? ''),
                onPressed: () async {
                  final sourceText = _controller.text;
                  if (sourceText.isNotEmpty) {
                    context.read<ImportMtnBloc>().convertMtnText(sourceText);
                  }
                },
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controller,
                      maxLines: null,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                        errorBorder:
                            OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(
                      height: AppDim.fourtyFour,
                    )
                  ],
                ),
              ),
            );
          },
          listener: (BuildContext context, ImportMtnState state) {
            switch (state.type) {
              case ImportMtnStateType.initial:
                context.loaderOverlay.hide();
                return;
              case ImportMtnStateType.loading:
                context.loaderOverlay.show();
                return;
              case ImportMtnStateType.error:
                context.loaderOverlay.hide();
                context.popRoute();
                showRequestSnackBar(context,
                    message: l10n?.import_mtn_error_message ?? '',
                    isSuccess: false);
                return;

              case ImportMtnStateType.importSuccess:
                context.loaderOverlay.hide();
                getIt.get<MainBloc>().initBloc();
                context.popRoute();
                showRequestSnackBar(context,
                    message: l10n?.import_mtn_success_message ?? '',
                    isSuccess: true);
                return;
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
