import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/utils/localization_extension.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';
import 'package:psws_storage/goals/presenter/widgets/add_button.dart';
import 'bloc/goals_bloc.dart';

@RoutePage()
class GoalsPage extends StatelessWidget with PswsDialogs {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        return Scaffold(
          body: GoalsPageViewWidget(
            state: state,
            onCreateGoal: () => _addGoal(context),
          ),
        );
      },
    );
  }

  void _addGoal(BuildContext context) {
    showInputDialog(context, title: context.l10n.goals_page__dialog_title,
        onChanged: (title) {
      if (context.mounted) {
        context.read<GoalsBloc>().addGoal(title);
      }
    });
  }
}

class GoalsPageViewWidget extends StatefulWidget {
  const GoalsPageViewWidget({
    super.key,
    required this.state,
    required this.onCreateGoal,
  });

  final GoalsState state;
  final VoidCallback onCreateGoal;

  @override
  State<GoalsPageViewWidget> createState() => _GoalsPageViewWidgetState();
}

class _GoalsPageViewWidgetState extends State<GoalsPageViewWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TabsRow(
                    tabController: _tabController,
                    tabs: [
                      Tab(
                        text: context.l10n.goals_page__tab_current,
                      ),
                      Tab(
                        text: context.l10n.goals_page__tab_done,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              Stack(
                children: [
                  ListGoals(
                    goals: widget.state.model.currentGoals,
                    emptyListText: context.l10n.goals_page__empty_current,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AddButton(
                      title: context.l10n.goals_page__add_button,
                      onTap: widget.onCreateGoal,
                    ),
                  ),
                ],
              ),
              ListGoals(
                goals: widget.state.model.finishedGoals,
                emptyListText: context.l10n.goals_page__empty_done,
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ListGoals extends StatelessWidget {
  const ListGoals({
    super.key,
    required this.goals,
    required this.emptyListText,
  });

  final List<Goal> goals;
  final String emptyListText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (goals.isEmpty) Center(child: Text(emptyListText)),
        if (goals.isNotEmpty)
          Positioned.fill(
            child: ListView.separated(
              padding: EdgeInsets.only(
                bottom: 32,
                top: 16,
              ),
              itemCount: goals.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 12,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final goal = goals[index];

                return _GoalItem(goal: goal);
              },
            ),
          ),
      ],
    );
  }
}

class _GoalItem extends StatelessWidget {
  const _GoalItem({
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    final finishedTask =
        goal.tasks.where((element) => element.isFinished).length;

    return GestureDetector(
      onTap: () {
        context.pushRoute(TasksRoute(goal: goal));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.appColors.appBarColor,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 4,
              color: const Color.fromARGB(255, 89, 85, 85),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: Text(
                          goal.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme(context).appTextStyles?.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  if (goal.tasks.isNotEmpty)
                    Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Text(
                            '${context.l10n.goals_page__done} $finishedTask ${context.l10n.goals_page__from} ${goal.tasks.length}',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_sharp,
              color: context.appColors.dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

class TabsRow extends StatefulWidget {
  final TabController tabController;

  final List<Tab> tabs;

  const TabsRow({
    super.key,
    required this.tabController,
    this.tabs = const [],
  });

  @override
  State<TabsRow> createState() => _TabsRowState();
}

class _TabsRowState extends State<TabsRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.0,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.appColors.bodyColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: context.appColors.cardColor ?? Colors.grey,
        ),
      ),
      child: TabBar(
        controller: widget.tabController,
        // give the indicator a decoration (color and border radius)
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(
            22.0,
          ),
          color: context.appColors.dividerColor,
        ),
        labelStyle: context.appTextStyles.titleMedium,
        labelColor: context.appColors.negativeActionColor ?? Colors.red,
        unselectedLabelColor: context.appColors.cardColor ?? Colors.grey,
        tabs: widget.tabs,
      ),
    );
  }
}
