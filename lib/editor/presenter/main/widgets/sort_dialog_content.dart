import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SortDialogContent extends StatefulWidget {
  final Sort sort;

  const SortDialogContent({
    Key? key,
    required this.sort,
  }) : super(key: key);

  @override
  State<SortDialogContent> createState() => SortDialogContentState();
}

class SortDialogContentState extends State<SortDialogContent> {
  SortBy _sortBy = SortBy.date;
  bool _includeFolder = false;
  SortType _sortType = SortType.desc;

  Sort get changedSort => Sort(
        folderInclude: _includeFolder,
        sortBy: _sortBy,
        sortType: _sortType,
      );

  @override
  void initState() {
    super.initState();
    _sortBy = widget.sort.sortBy;
    _sortType = widget.sort.sortType;
    _includeFolder = widget.sort.folderInclude;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RadioListTile<SortBy>(
            title: Text(l10n.sort_dialog__by_name),
            value: SortBy.name,
            groupValue: _sortBy,
            onChanged: (sortBy) {
              if (sortBy != null) {
                setState(() {
                  _sortBy = sortBy;
                });
              }
            }),
        RadioListTile<SortBy>(
            title: Text(l10n.sort_dialog__by_date),
            value: SortBy.date,
            groupValue: _sortBy,
            onChanged: (sortBy) {
              if (sortBy != null) {
                setState(() {
                  _sortBy = sortBy;
                });
              }
            }),
        CheckboxListTile(
            title: Text(l10n.sort_dialog__include_folder),
            controlAffinity: ListTileControlAffinity.leading,
            value: _includeFolder,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _includeFolder = value;
                });
              }
            }),
        Row(
          children: [
            Expanded(
              child: CupertinoSlidingSegmentedControl<SortType>(
                  children: {
                    SortType.desc: Text(
                      l10n.sort_dialog__type_desc,
                      textAlign: TextAlign.center,
                    ),
                    SortType.asc: Text(
                      l10n.sort_dialog__type_asc,
                      textAlign: TextAlign.center,
                    ),
                  },
                  groupValue: _sortType,
                  onValueChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _sortType = value;
                      });
                    }
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
