import 'package:flutter/material.dart';

import 'widgets/uni_bottom_sheet.dart';
import 'widgets/uni_draggable_scrollable_sheet.dart';

/// RU: Функция [showModalUniBottomSheet] - показывает bottom sheet [UniBottomSheet].
///
/// EN: Function [showModalUniBottomSheet] - shows bottom sheet [UniBottomSheet].
///
Future<T?> showModalUniBottomSheet<T>({
  /// RU: аргумент [context] - дескриптор местоположения виджета в дереве виджетов.
  ///
  /// EN: argument [context] - a handle to the location of a widget in the widget tree.
  ///
  required BuildContext context,

  /// RU: аргумент [title] - текст заголовка bottom sheet.
  ///
  /// EN: argument [title] - bottom sheet title text.
  ///
  required String title,

  /// RU: аргумент [content] - виджет с контентом внутри bottom sheet.
  ///
  /// EN: the [content] argument is a widget with content inside the bottom sheet.
  ///
  required Widget content,

  /// RU: аргумент [closeIcon] - иконка закрытия.
  ///
  /// EN: the [closeIcon] argument is the close icon.
  ///
  required Widget closeIcon,

  /// RU: аргумент [onClose] - callback, вызываемый при нажатии на иконку закрытия.
  ///
  /// EN: the [onClose] argument is a callback called when the close icon is clicked.
  ///
  required Function() onClose,

  /// RU: аргумент [fullScreen] - флаг, определяющий отображение bottom sheet во весь экран.
  ///
  /// EN: the [fullScreen] argument is a flag that specifies whether to display the bottom sheet in full screen.
  ///
  bool fullScreen = false,
}) async {
  return showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (BuildContext context) {
      return UniBottomSheet(
        title: title,
        closeIcon: closeIcon,
        content: content,
        fullScreen: fullScreen,
        onClose: onClose,
      );
    },
  );
}

/// RU: Функция [showUniDraggableScrollableSheet] - показывает bottom sheet [UniDraggableScrollableSheet].
///
/// EN: Function [showUniDraggableScrollableSheet] - shows bottom sheet [UniDraggableScrollableSheet].
///
showUniDraggableScrollableSheet({
  /// RU: аргумент [context] - дескриптор местоположения виджета в дереве виджетов.
  ///
  /// EN: argument [context] - a handle to the location of a widget in the widget tree.
  ///
  required BuildContext context,

  /// RU: аргумент [title] - текст заголовка bottom sheet.
  ///
  /// EN: argument [title] - bottom sheet title text.
  ///
  required String title,

  /// RU: аргумент [actionButtonText] - текст кнопки с действием.
  ///
  /// EN: argument [actionButtonText] - the text of the action button.
  ///
  required String actionButtonText,

  /// RU: аргумент [content] - виджет с контентом внутри bottom sheet.
  ///
  /// EN: the [content] argument is a widget with content inside the bottom sheet.
  ///
  required Widget content,

  /// RU: аргумент [closeIcon] - иконка закрытия.
  ///
  /// EN: the [closeIcon] argument is the close icon.
  ///
  required Widget closeIcon,

  /// RU: аргумент [initialChildSize] — это начальное дробное значение высоты родительского контейнера,
  /// используемое при отображении виджета.
  ///
  /// EN: the [initialChildSize] argument is the initial fractional value of the parent container's height
  /// to use when displaying the widget.
  ///
  required double initialChildSize,

  /// RU: аргумент [minChildSize] — это минимальное дробное значение высоты родительского контейнера, используемое при
  /// отображение виджета.
  ///
  /// EN: the [minChildSize] argument is the minimum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  required double minChildSize,

  /// RU: аргумент [maxChildSize] — это максимальное дробное значение высоты родительского контейнера, используемое при
  /// отображение виджета.
  ///
  /// EN: the [maxChildSize] argument is the maximum fractional value of the parent container's height to use when
  /// displaying the widget.
  ///
  required double maxChildSize,

  /// RU: аргумент [onClose] - callback, вызываемый при нажатии на иконку закрытия.
  ///
  /// EN: the [onClose] argument is a callback called when the close icon is clicked.
  ///
  required void Function() onClose,

  /// RU: аргумент [onActionButtonPressed] - callback, вызываемый при нажатии на кнопку с действием.
  ///
  /// EN: the [onActionButtonPressed] argument is a callback called when the action button is clicked.
  ///
  required void Function() onActionButtonPressed,

  /// RU: аргумент [onActionButtonPressed] - callback, вызываемый при изменении позиции скролла.
  ///
  /// EN: the [onActionButtonPressed] argument is a callback called when the scroll position changes.
  ///
  required NotificationListenerCallback<DraggableScrollableNotification>?
  onNotification,
}) {
  showBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
    ),
    builder: (builderContext) =>
        NotificationListener<DraggableScrollableNotification>(
          onNotification: onNotification,
          child: SafeArea(
            child: UniDraggableScrollableSheet(
              title: title,
              actionButtonText: actionButtonText,
              content: content,
              initialChildSize: initialChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              closeIcon: closeIcon,
              onClose: onClose,
              onActionButtonPressed: onActionButtonPressed,
            ),
          ),
        ),
  );
}
