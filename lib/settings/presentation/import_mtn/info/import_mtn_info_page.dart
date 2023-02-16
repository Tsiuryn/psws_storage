import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/res/resources.dart';

class ImportMtnInfoPage extends StatelessWidget {
  const ImportMtnInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTheme = AppTheme(context);

    return LifeCycleWidget(
      router: context.router,
      currentRouteName: ImportMtnInfoRoute.name,
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(
            child: Text(
              l10n?.import_mtn_info_appbar_title ?? '',
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
          bottom: const PreferredSize(
            child: Divider(),
            preferredSize: Size.fromHeight(1),
          ),
        ),
        body: const ImportMtnInfoForm(),
      ),
    );
  }
}

class ImportMtnInfoForm extends StatelessWidget {
  const ImportMtnInfoForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appTheme = AppTheme(context);
    final defStyle = appTheme.appTextStyles?.titleMedium;
    final imageWidth = MediaQuery.of(context).size.width - 240;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDim.eight,
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _ImageWithTitle(
              title: '1. Открыть \'MyTreeNotes\'. Выделить все папки и файлы',
              imagePath: AppIcons.one,
            ),
            _ImageWithTitle(
              title:
                  '2. Нажать на три точки справа сверху. В меню выбрать пункт - Поделиться',
              imagePath: AppIcons.two,
            ),
            _ImageWithTitle(
              title:
                  '3. Выбрать \'Опции\' и заполнить как указано на рисунке ниже:',
              imagePath: AppIcons.three,
            ),
            _ImageWithTitle(
              title:
                  '4. Выбрать \'Предпросмотр\', выделить весь текст и скопировать',
              imagePath: AppIcons.four,
            ),
            _ImageWithTitle(
              title:
                  '5. Открыть приложение \'Storage\'. Выбрать Настройки - Открыть экран импорта из MTN. Вставить скопированный текст. Нажать кнопку \'Импортировать\'',
              imagePath: AppIcons.five,
            )
          ],
        ),
      ),
    );
  }
}

class _ImageWithTitle extends StatelessWidget {
  final String title;
  final String imagePath;

  const _ImageWithTitle({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(context);
    final defStyle = appTheme.appTextStyles?.titleMedium;
    final imageWidth =
        MediaQuery.of(context).size.width - AppDim.fourtyFour * 4;

    return Column(
      children: [
        const SizedBox(
          height: AppDim.sixteen,
        ),
        Text(
          title,
          //
          style: defStyle,
        ),
        const SizedBox(
          height: AppDim.eight,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(AppDim.eight)),
          child: Image.asset(
            imagePath,
            width: imageWidth,
          ),
        )
      ],
    );
  }
}
