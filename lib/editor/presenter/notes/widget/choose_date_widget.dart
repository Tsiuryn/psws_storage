import 'package:flutter/cupertino.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseDateWidget extends StatefulWidget {
  final Function(String) onSelectedDate;

  const ChooseDateWidget({
    Key? key,
    required this.onSelectedDate,
  }) : super(key: key);

  @override
  State<ChooseDateWidget> createState() => _ChooseDateWidgetState();
}

class _ChooseDateWidgetState extends State<ChooseDateWidget> {
  late DateTime _currentDate;
  static const String _format = 'dd-MM-yyyy  HH:mm';

  static const _formatters = [
    _format,
    'dd-MM-yyyy',
    'dd MMM yyyy',
    'MMM yyyy',
    'HH:mm:ss',
    'HH:mm',
  ];

  String get _dateLocale => AppLocalizations.of(context)?.localeName ?? '';

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme(context);
    final colors = appTheme.appColors;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppDim.sixteen),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.choose_date_widget__current_date_time,
            style: appTheme.appTextStyles?.titleMedium,
          ),
          Row(
            children: [
              Expanded(
                  child:
                      Text(DateFormat(_formatters.first).format(_currentDate))),
              IconButton(
                  onPressed: () {
                    _showDateTimePicker();
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                  )),
            ],
          ),
          Divider(
            color: colors?.textColor,
          ),
          const SizedBox(
            height: AppDim.sixteen,
          ),
          Text(
            l10n.choose_date_widget__choose_date_title,
            style: appTheme.appTextStyles?.titleMedium,
          ),
          const SizedBox(
            height: AppDim.sixteen,
          ),
          ..._formatters.map((format) {
            final textDate =
                DateFormat(format, _dateLocale).format(_currentDate);
            return ListTile(
              visualDensity: const VisualDensity(
                vertical: VisualDensity.minimumDensity,
              ),
              title: Text(
                textDate,
                textAlign: TextAlign.center,
              ),
              onTap: () {
                widget.onSelectedDate(textDate);
                Navigator.pop(context);
              },
            );
          })
        ],
      ),
    );
  }

  void _showDateTimePicker() {
    final appTheme = AppTheme(context);
    DatePicker.showDatePicker(
      context,
      initialDateTime: _currentDate,
      dateFormat: _format,
      pickerTheme: DateTimePickerTheme(
        backgroundColor: appTheme.appColors?.bodyColor ?? Colors.white,
        showTitle: false,
        itemTextStyle: TextStyle(
          color: appTheme.appColors?.textColor,
        ),
      ),
      pickerMode: DateTimePickerMode.datetime,
      onChange: (dateTime, List<int> index) {
        setState(() {
          _currentDate = dateTime;
        });
      },
    );
  }
}
