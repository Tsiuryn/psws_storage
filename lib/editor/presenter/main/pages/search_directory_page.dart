import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_input_search.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/const/constants.dart';
import 'package:psws_storage/editor/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';

@RoutePage()
class SearchDirectoryPage extends StatefulWidget {
  final List<DirectoryModel> directories;
  final SearchDestination searchDestination;

  const SearchDirectoryPage({
    Key? key,
    required this.directories,
    this.searchDestination = SearchDestination.search,
  }) : super(key: key);

  @override
  State<SearchDirectoryPage> createState() => _SearchDirectoryPageState();
}

class _SearchDirectoryPageState extends State<SearchDirectoryPage> {
  String _searchValue = '';
  late List<DirectoryModel> fullDirectories;
  late List<DirectoryModel> searchDirectories;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.searchDestination == SearchDestination.getPath) {
      searchDirectories =
          widget.directories.where((element) => !element.isFolder).toList();
      fullDirectories = searchDirectories;
    } else {
      searchDirectories = widget.directories;
      fullDirectories = searchDirectories;
    }
    _controller = TextEditingController();
    _controller.addListener(_handlerControl);
  }

  void _handlerControl() {
    _searchValue = _controller.text;
    setState(() {
      if (_searchValue.isEmpty) {
        searchDirectories = fullDirectories;
      } else {
        searchDirectories = fullDirectories
            .where((element) =>
                element.name.toLowerCase().contains(_searchValue.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppTheme appTheme = AppTheme(context);
    final AppColorsExt? appColors = appTheme.appColors;
    final textStyles = appTheme.appTextStyles;
    final iconSearch = Icon(
      Icons.search_rounded,
      color: appColors?.textColor,
      size: AppDim.twentyFour,
    );

    return LifeCycleWidget(
      routeData: context.routeData,
      child: SafeArea(
        child: Scaffold(
          appBar: widget.searchDestination != SearchDestination.move
              ? null
              : AppBar(
                  title: FittedBox(
                    child: Text(
                      AppLocalizations.of(context).search_directory__title,
                      style: textStyles?.titleLarge,
                    ),
                  ),
                  bottom: const PreferredSize(
                    preferredSize: Size.fromHeight(1),
                    child: Divider(),
                  ),
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: AppDim.sixteen,
                  top: AppDim.sixteen,
                  right: AppDim.sixteen,
                ),
                child: PswsInputSearch(
                  controller: _controller,
                  prefixIcon: widget.searchDestination != SearchDestination.move
                      ? IconButton(
                          onPressed: context.maybePop,
                          icon: Icon(
                            Icons.arrow_back_rounded,
                            color: appColors?.textColor,
                            size: AppDim.twentyFour,
                          ),
                        )
                      : iconSearch,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _searchValue = '';
                        _controller.text = _searchValue;
                      });
                    },
                    icon: Icon(
                      Icons.close_rounded,
                      color: appColors?.textColor,
                      size: AppDim.twentyFour,
                    ),
                  ),
                ),
              ),
              Visibility(
                  visible: widget.searchDestination == SearchDestination.move,
                  child: TextButton(
                      child: Text(
                        AppLocalizations.of(context).search_directory__text_btn,
                        style: textStyles?.titleMedium,
                      ),
                      onPressed: () {
                        context.maybePop(DirectoryModel.buildRootDirectory());
                      })),
              Expanded(
                child: ListView.separated(
                  itemCount: searchDirectories.length,
                  itemBuilder: (context, index) {
                    return ItemWidget(
                      model: searchDirectories[index],
                      canSwipe: false,
                      searchValue: _searchValue,
                      id: index,
                      onTap: () {
                        context.maybePop(searchDirectories[index]);
                      },
                      pathBuilder: () {
                        return _convertListToPathText(
                          _getPathByParentId(searchDirectories[index]),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppDim.sixteen),
                      child: Divider(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _convertListToPathText(List<String> path) {
    String pathString = '..';
    for (String element in path) {
      pathString += '/$element';
    }
    return pathString;
  }

  List<String> _getPathByParentId(DirectoryModel choosingDirectory) {
    List<String> path = [choosingDirectory.name];
    String searchParentId = choosingDirectory.parentId;
    while (searchParentId != rootDirectoryId) {
      final parentDirectory = widget.directories
          .firstWhereOrNull((element) => element.id == searchParentId);
      if (parentDirectory != null) {
        path.add(parentDirectory.name);
        searchParentId = parentDirectory.parentId;
      } else {
        searchParentId = rootDirectoryId;
      }
    }

    return path.reversed.toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

enum SearchDestination { search, move, getPath }
