import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/common/base_page.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/habit/domain/entity/habit.dart';
import 'package:psws_storage/habit/domain/repo/habit_repository.dart';
import 'package:psws_storage/habit/domain/repo/statistics_repository.dart';
import 'package:psws_storage/habit/presenter/bloc/habit_tracker_bloc.dart';
import 'package:psws_storage/habit/presenter/widgets/habit_tile.dart';
import 'package:psws_storage/habit/presenter/widgets/month_summary.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:psws_storage/habit/presenter/widgets/my_result_box.dart';

@RoutePage()
class HabitTrackerPage
    extends StatelessBasePage<HabitTrackerBloc, HabitTrackerState>
    with PswsDialogs {
  const HabitTrackerPage({super.key});

  void _showDialog(
    BuildContext context, {
    Habit? habit,
  }) {
    final l10n = AppLocalizations.of(context);
    final title = habit == null
        ? l10n.habit_tracker__habit_create
        : l10n.habit_tracker__habit_edit;
    createFileDialog(context,
        title: title,
        initialTextValue: habit?.title,
        placeholder: l10n.habit_tracker__dialog_placeholder, value: (title) {
      final bloc = context.read<HabitTrackerBloc>();

      if (habit != null) {
        bloc.updateHabit(habit.copyWith(title: title));
      } else {
        bloc.addHabit(title);
      }

      context.maybePop();
    });
  }

  void _showDialogDateHabits(BuildContext context, {List<Habit>? habits}) {
    showDialog(
      context: context,
      builder: (context) {
        return MyResultBox(
          list: habits,
        );
      },
    );
  }

  @override
  void onListener(BuildContext context, HabitTrackerState state) {
    if (state.state == TrackerState.showStatisticDialog) {
      _showDialogDateHabits(context, habits: state.statisticHabits);
    }
  }

  @override
  Widget? buildFloatingAction(BuildContext context, HabitTrackerState state) {
    return FloatingActionButton(
      onPressed: () => _showDialog(context),
      child: Icon(Icons.add_rounded),
    );
  }

  @override
  Widget buildBody(BuildContext context, HabitTrackerState state) {
    final bloc = context.read<HabitTrackerBloc>();
    return ListView(
      children: [
        MonthlySummary(
          datasets: state.statistics,
          startDate: state.getStartDate(),
          onClick: bloc.showStatisticDialog,
        ),

        // list of habits
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.habits.length,
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDim.sixteen,
              ),
              child: Divider(),
            );
          },
          itemBuilder: (context, index) {
            final habit = state.habits[index];

            return HabitTile(
              habit: habit,
              onTap: () {
                bloc.updateHabit(habit.copyWith(completed: !habit.completed));
              },
              onEdit: () {
                _showDialog(context, habit: habit);
              },
              onDelete: () {
                bloc.deleteHabit(habit.id);
              },
            );
          },
        )
      ],
    );
  }

  @override
  HabitTrackerBloc createBloc(BuildContext context) {
    return HabitTrackerBloc(
      habitRepository: getIt.get<HabitRepository>(),
      statisticsRepository: getIt.get<StatisticsRepository>(),
    )..updateFlow();
  }
}
