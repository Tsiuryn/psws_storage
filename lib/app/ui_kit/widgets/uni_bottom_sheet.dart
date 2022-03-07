import 'package:flutter/material.dart';
import 'package:psws_storage/app/ui_kit/widgets/bottom_sheet_header.dart';

/// RU: Класс [UniBottomSheet] - конфигурация bottom sheet;
///
/// EN: Class [UniBottomSheet] - bottom sheet configuration;
///
class UniBottomSheet extends StatelessWidget {
  const UniBottomSheet({
    Key? key,
    required this.content,
    required this.closeIcon,
    required this.title,
    required this.fullScreen,
    required this.onClose,
  }) : super(key: key);

  /// RU: аргумент [content] - виджет с контентом внутри bottom sheet.
  ///
  /// EN: the [content] argument is a widget with content inside the bottom sheet.
  ///
  final Widget content;

  /// RU: аргумент [closeIcon] - иконка закрытия.
  ///
  /// EN: the [closeIcon] argument is the close icon.
  ///
  final Widget closeIcon;

  /// RU: аргумент [title] - текст заголовка.
  ///
  /// EN: argument [title] - title text.
  ///
  final String title;

  /// RU: аргумент [fullScreen] - флаг, определяющий отображение bottom sheet во весь экран.
  ///
  /// EN: the [fullScreen] argument is a flag that specifies whether to display the bottom sheet in full screen.
  ///
  final bool fullScreen;

  /// RU: аргумент [onClose] - callback, вызываемый при нажатии на иконку закрытия.
  ///
  /// EN: the [onClose] argument is a callback called when the close icon is clicked.
  ///
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return fullScreen ? _buildFullScreenPage(context) : _buildPage(context);
  }

  Widget _buildFullScreenPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        title: BottomSheetHeader(
          title: title,
          closeIcon: closeIcon,
          onPressed: () => onClose(),
          topBorderRadius: const Radius.circular(30.0),
          maxLines: 1,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: content,
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return SafeArea(
      top: false, // TODO: Should be adaptive
      child: Wrap(
        children: [
          Column(
            children: [
              BottomSheetHeader(
                title: title,
                closeIcon: closeIcon,
                onPressed: () => onClose(),
                topBorderRadius: const Radius.circular(200.0),
                maxLines: 1,
              ),
              content,
            ],
          ),
        ],
      ),
    );
  }
}
