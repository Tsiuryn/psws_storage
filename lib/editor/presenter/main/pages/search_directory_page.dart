import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.gr.dart';
import 'package:psws_storage/app/theme/app_colors_ext.dart';
import 'package:psws_storage/app/ui_kit/psws_input_search.dart';
import 'package:psws_storage/editor/domain/model/directory_model.dart';
import 'package:psws_storage/editor/presenter/main/widgets/item_widget.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';

class SearchDirectoryPage extends StatefulWidget {
  final List<DirectoryModel> directories;

  const SearchDirectoryPage({
    Key? key,
    required this.directories,
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
            .where((element) => element.name.toLowerCase().contains(_searchValue.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppColorsExt? appColors = Theme.of(context).extension<AppColorsExt>();

    return LifeCycleWidget(
      router: context.router,
      currentRouteName: SearchDirectoryRoute.name,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(AppDim.sixteen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PswsInputSearch(
                  controller: _controller,
                  prefixIcon: IconButton(
                    onPressed: context.popRoute,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: appColors?.textColor,
                      size: AppDim.twentyFour,
                    ),
                  ),
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
