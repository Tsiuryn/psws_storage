import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/ui_kit/snack_bar.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_bloc.dart';
import 'package:psws_storage/editor/presenter/main/bloc/main_model.dart';
import 'package:psws_storage/editor/presenter/main/widgets/sort_dialog_content.dart';
import 'package:psws_storage/res/resources.dart';

class ExpandableFABWidget extends StatefulWidget {
  const ExpandableFABWidget({
    super.key,
    required this.state,
  });

  final MainModelState state;

  @override
  State<ExpandableFABWidget> createState() => _ExpandableFABWidgetState();
}

class _ExpandableFABWidgetState extends State<ExpandableFABWidget>
    with PswsSnackBar, PswsDialogs {
  final _key = GlobalKey<ExpandableFabState>();

  void _toggle() {
    _key.currentState?.toggle();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainBloc>();
    final l10n = AppLocalizations.of(context);
    final folderName = l10n.main_appbar_dialog_folder;
    final fileName = l10n.main_appbar_dialog_note;
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return ExpandableFab(
      key: _key,
      duration: const Duration(milliseconds: 500),
      distance: 140.0,
      type: ExpandableFabType.fan,
      pos: ExpandableFabPos.right,
      // childrenOffset: const Offset(0, 20),
      childrenAnimation: ExpandableFabAnimation.rotate,
      fanAngle: 100,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.menu),
        fabSize: ExpandableFabSize.regular,
        foregroundColor: context.appColors.textColor,
        backgroundColor: context.appColors.cardColor,
        shape: const CircleBorder(),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        child: const Icon(Icons.close),
        fabSize: ExpandableFabSize.small,
        foregroundColor: context.appColors.textColor,
        backgroundColor: context.appColors.cardColor,
        shape: const CircleBorder(),
      ),
      children: [
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: appColors?.cardColor,
          onPressed: () {
            _toggle();
            createFileDialog(context, title: fileName, isFolder: false,
                value: (fileName) {
              bloc.addFile(fileName).then((value) {
                if (value.$2.idHiveObject != -1) {
                  context.pushRoute(EditNotesRoute(
                      idHive: value.$2.idHiveObject,
                      path: widget.state.getPathString(),
                      directories: value.$1));
                }
              });
            });
          },
          child: SvgPicture.asset(
            AppIcons.icFile,
            width: 24,
            height: 24,
            color: appColors?.textColor,
          ),
        ),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: appColors?.cardColor,
          onPressed: () {
            _toggle();
            createFileDialog(context, title: folderName, value: (folderName) {
              bloc.addFolder(folderName).then((value) {
                bloc.openFolder(value.$2);
              });
            });
          },
          child: SvgPicture.asset(
            AppIcons.icFolder,
            width: 24,
            height: 24,
            color: appColors?.textColor,
          ),
        ),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: appColors?.cardColor,
          onPressed: () {
            _toggle();
            context
                .pushRoute(SearchDirectoryRoute(
                    directories: widget.state.directoriesWithoutLink))
                .then((value) {
              final dir = value;
              if (dir is DirectoryModel) {
                context.read<MainBloc>().addLink('${dir.name}.link', dir.id);
              }
            });
          },
          child: Icon(
            Icons.add_link,
            color: appColors?.textColor,
            size: AppDim.twentyFour,
          ),
        ),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: appColors?.cardColor,
          onPressed: () {
            _toggle();
            showSortDialog(context);
          },
          child: Icon(
            Icons.sort,
            color: appColors?.textColor,
            size: AppDim.twentyFour,
          ),
        ),
        FloatingActionButton.small(
          heroTag: null,
          backgroundColor: appColors?.cardColor,
          onPressed: () {
            _toggle();
            context.router
                .push(SearchDirectoryRoute(
                    directories: widget.state.directoriesWithoutLink))
                .then((directory) {
              if (directory != null && directory is DirectoryModel) {
                if (directory.isFolder) {
                  context.read<MainBloc>().openFolderFromSearch(directory);
                } else {
                  final path = widget.state.convertListToPathText(
                      widget.state.getPathByParentId(directory));
                  context
                      .pushRoute(EditNotesRoute(
                        idHive: directory.idHiveObject,
                        path: path,
                        directories: widget.state.directories,
                      ))
                      .then(
                        (value) => context
                            .read<MainBloc>()
                            .updateDirectoryAfterChanging(
                                directory.idHiveObject),
                      );
                  Future.delayed(const Duration(seconds: 1)).then((value) {
                    final parentFolder = widget.state.directories
                        .firstWhereOrNull(
                            (dir) => dir.id == directory.parentId);
                    if (parentFolder != null) {
                      context
                          .read<MainBloc>()
                          .openFolderFromSearch(parentFolder);
                    }
                  });
                }
              }
            });
          },
          child: Icon(
            Icons.search_rounded,
            color: appColors?.textColor,
            size: AppDim.twentyFour,
          ),
        ),
      ],
    );
  }

  void showSortDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appColors = AppTheme(context).appColors;
    final appTextStyles = AppTheme(context).appTextStyles;
    final appBloc = getIt.get<AppBloc>();
    final mainBloc = context.read<MainBloc>();
    final key = GlobalKey<SortDialogContentState>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.sort_dialog__title),
        content: SortDialogContent(
          key: key,
          sort: appBloc.state.sort,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.common_dialog_cancel,
              style: TextStyle(
                color: appColors?.textColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final sort = key.currentState?.changedSort;
              if (sort != null) {
                appBloc.changeSort(sort);
                mainBloc.updatedSortList(sort);
              }
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.common_dialog_confirm,
              style: appTextStyles?.titleMedium?.copyWith(
                color: appColors?.textColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class MainAppBar extends StatelessWidget
//     with PswsSnackBar, PswsDialogs
//     implements PreferredSizeWidget {
//   final MainModelState state;

//   const MainAppBar({
//     Key? key,
//     required this.state,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bloc = context.read<MainBloc>();
//     final l10n = AppLocalizations.of(context);
//     final folderName = l10n.main_appbar_dialog_folder;
//     final fileName = l10n.main_appbar_dialog_note;
//     final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

//     return AppBar(
//       automaticallyImplyLeading: false,
//       titleSpacing: AppDim.zero,
//       bottom: const PreferredSize(
//         preferredSize: Size.fromHeight(1),
//         child: Divider(),
//       ),
//       title: Row(children: [
//         const SizedBox(
//           width: AppDim.eight,
//         ),
//         IconButton(
//           onPressed: () {
//             createFileDialog(context, title: fileName, isFolder: false,
//                 value: (fileName) {
//               bloc.addFile(fileName).then((value) {
//                 if (value.$2.idHiveObject != -1) {
//                   context.pushRoute(EditNotesRoute(
//                       idHive: value.$2.idHiveObject,
//                       path: state.getPathString(),
//                       directories: value.$1));
//                 }
//               });
//             });
//           },
//           icon: SvgPicture.asset(
//             AppIcons.icFile,
//             color: appColors?.textColor,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             createFileDialog(context, title: folderName, value: (folderName) {
//               bloc.addFolder(folderName).then((value) {
//                 bloc.openFolder(value.$2);
//               });
//             });
//           },
//           icon: SvgPicture.asset(
//             AppIcons.icFolder,
//             color: appColors?.textColor,
//           ),
//         ),
//         IconButton(
//           onPressed: () {
//             context
//                 .pushRoute(SearchDirectoryRoute(
//                     directories: state.directoriesWithoutLink))
//                 .then((value) {
//               final dir = value;
//               if (dir is DirectoryModel) {
//                 context.read<MainBloc>().addLink('${dir.name}.link', dir.id);
//               }
//             });
//           },
//           icon: Icon(
//             Icons.add_link,
//             color: appColors?.textColor,
//             size: AppDim.thirtyTwo,
//           ),
//         ),
//         const Expanded(
//           child: SizedBox(),
//         ),
//         IconButton(
//             onPressed: () {
//               showSortDialog(context);
//             },
//             icon: Icon(
//               Icons.sort,
//               color: appColors?.textColor,
//               size: AppDim.thirtyTwo,
//             )),
//         IconButton(
//           onPressed: () async {
//             context.router
//                 .push(SearchDirectoryRoute(
//                     directories: state.directoriesWithoutLink))
//                 .then((directory) {
//               if (directory != null && directory is DirectoryModel) {
//                 if (directory.isFolder) {
//                   context.read<MainBloc>().openFolderFromSearch(directory);
//                 } else {
//                   final path = state.convertListToPathText(
//                       state.getPathByParentId(directory));
//                   context
//                       .pushRoute(EditNotesRoute(
//                         idHive: directory.idHiveObject,
//                         path: path,
//                         directories: state.directories,
//                       ))
//                       .then(
//                         (value) => context
//                             .read<MainBloc>()
//                             .updateDirectoryAfterChanging(
//                                 directory.idHiveObject),
//                       );
//                   Future.delayed(const Duration(seconds: 1)).then((value) {
//                     final parentFolder = state.directories.firstWhereOrNull(
//                         (dir) => dir.id == directory.parentId);
//                     if (parentFolder != null) {
//                       context
//                           .read<MainBloc>()
//                           .openFolderFromSearch(parentFolder);
//                     }
//                   });
//                 }
//               }
//             });
//           },
//           icon: Icon(
//             Icons.search_rounded,
//             color: appColors?.textColor,
//             size: AppDim.thirtyTwo,
//           ),
//         ),
//       ]),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(60);

//   void showSortDialog(BuildContext context) {
//     final l10n = AppLocalizations.of(context);
//     final appColors = AppTheme(context).appColors;
//     final appTextStyles = AppTheme(context).appTextStyles;
//     final appBloc = getIt.get<AppBloc>();
//     final mainBloc = context.read<MainBloc>();
//     final key = GlobalKey<SortDialogContentState>();
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(l10n.sort_dialog__title),
//         content: SortDialogContent(
//           key: key,
//           sort: appBloc.state.sort,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               l10n.common_dialog_cancel,
//               style: TextStyle(
//                 color: appColors?.textColor,
//               ),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               final sort = key.currentState?.changedSort;
//               if (sort != null) {
//                 appBloc.changeSort(sort);
//                 mainBloc.updatedSortList(sort);
//               }
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               l10n.common_dialog_confirm,
//               style: appTextStyles?.titleMedium?.copyWith(
//                 color: appColors?.textColor,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
