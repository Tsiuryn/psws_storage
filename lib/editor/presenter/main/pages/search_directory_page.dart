import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_input_search.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';

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
  late List<DirectoryModel> searchDirectories;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    searchDirectories = widget.directories;
    _controller = TextEditingController();
    _controller.addListener(_handlerControl);
  }

  void _handlerControl() {
    _searchValue = _controller.text;
    setState(() {
      if (_searchValue.isEmpty) {
        searchDirectories = widget.directories;
      } else {
        searchDirectories = widget.directories
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
      router: context.router,
      currentRouteName: SearchDirectoryRoute.name,
      child: SafeArea(
        child: Scaffold(
          appBar: widget.searchDestination == SearchDestination.search
              ? null
              : AppBar(
                  title: FittedBox(
                    child: Text(
                      AppLocalizations.of(context)?.search_directory__title ??
                          '',
                      style: textStyles?.titleLarge,
                    ),
                  ),
                  bottom: const PreferredSize(
                    child: Divider(),
                    preferredSize: Size.fromHeight(1),
                  ),
                ),
          body: Padding(
            padding: const EdgeInsets.all(AppDim.sixteen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PswsInputSearch(
                  controller: _controller,
                  prefixIcon:
                      widget.searchDestination == SearchDestination.search
                          ? IconButton(
                              onPressed: context.popRoute,
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
                Visibility(
                    visible: widget.searchDestination == SearchDestination.move,
                    child: TextButton(
                        child: Text(
                          AppLocalizations.of(context)
                                  ?.search_directory__text_btn ??
                              '',
                          style: textStyles?.titleMedium,
                        ),
                        onPressed: () {
                          context.popRoute(DirectoryModel.buildRootDirectory());
                        })),
                Expanded(
                  child: ListView.builder(
                      itemCount: searchDirectories.length,
                      itemBuilder: (context, index) {
                        return ItemWidget(
                          model: searchDirectories[index],
                          canSwipe: false,
                          searchValue: _searchValue,
                          id: index,
                          onTap: () {
                            context.popRoute(searchDirectories[index]);
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
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

enum SearchDestination { search, move }
