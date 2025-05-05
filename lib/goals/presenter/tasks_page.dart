import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:intl/intl.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/ui_kit/psws_dialogs.dart';
import 'package:psws_storage/app/utils/localization_extension.dart';
import 'package:psws_storage/app/utils/uuid_generator.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';
import 'package:psws_storage/goals/presenter/bloc/goals_bloc.dart';
import 'package:psws_storage/goals/presenter/widgets/add_button.dart';
import 'package:psws_storage/res/app_localizations.dart';

@RoutePage()
class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> with PswsDialogs {
  late List<Task> _tasks;
  late Goal _goal;

  @override
  void initState() {
    super.initState();
    _goal = widget.goal;
    _tasks = widget.goal.tasks;
  }

  void _showDeleteDialog(BuildContext context) {
    createOkDialog(
      context,
      title: context.l10n.tasks_page__delete_dialog_title,
      message: context.l10n.tasks_page__delete_dialog_message,
      tapNo: () {},
      tapOk: () async {
        await context.read<GoalsBloc>().deleteGoal(widget.goal);

        if (context.mounted) {
          context.maybePop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalsBloc, GoalsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_goal.title),
            actions: [
              IconButton(
                  onPressed: () => _showDeleteDialog(context),
                  icon: Icon(
                    Icons.delete,
                    color: context.appColors.negativeActionColor,
                  ))
            ],
          ),
          body: Stack(
            children: [
              if (_tasks.isEmpty)
                Center(
                  child: Text(context.l10n.tasks_page__empty_message),
                ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      _GoalDescriptionWidget(
                        goal: _goal,
                        onTap: () {
                          context
                              .pushRoute(EditGoalRoute(element: _goal))
                              .then((value) {
                            if (value is Goal && context.mounted) {
                              context.read<GoalsBloc>().updateGoal(value);
                              setState(() {
                                _goal = value;
                              });
                            }
                          });
                        },
                      ),
                      if (_tasks.isNotEmpty)
                        Expanded(
                          child: SafeArea(
                            child: ListView.separated(
                              itemCount: _tasks.length,
                              padding: EdgeInsets.only(bottom: 40),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  height: 8,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                final task = _tasks[index];
                                return _TaskItem(
                                  task: task,
                                  onChanged: (_) => _updateTask(context, task),
                                  onTapDelete: () => _deleteTask(context, task),
                                  onTapRename: () {
                                    context
                                        .pushRoute(
                                      EditGoalRoute(element: task),
                                    )
                                        .then((value) {
                                      if (value is Task && context.mounted) {
                                        setState(() async {
                                          await _updateTask(
                                            context,
                                            value,
                                            byCheckbox: false,
                                          );
                                        });
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: AddButton(
                    title: context.l10n.tasks_page__add_task,
                    onTap: () => _addTask(context),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTask(BuildContext context, Task task) async {
    await context.read<GoalsBloc>().deleteTask(task);

    final value =
        _tasks.indexed.firstWhereOrNull((element) => element.$2.id == task.id);
    if (value != null) {
      setState(() {
        _tasks.removeAt(value.$1);
      });
    }
  }

  Future _updateTask(BuildContext context, Task task,
      {bool byCheckbox = true}) async {
    final bloc = context.read<GoalsBloc>();
    final dbTask = await bloc.getTaskById(task.id);
    Task? updatedTask;
    if (byCheckbox) {
      final isFinished = dbTask.isFinished;
      updatedTask = dbTask.copyWith(isFinished: !isFinished);
    } else {
      updatedTask =
          dbTask.copyWith(title: task.title, description: task.description);
    }

    bloc.updateTask(updatedTask);
    _updateListTask(updatedTask);
  }

  void _updateListTask(Task updatedTask) {
    final updatedValue = _tasks.indexed
        .firstWhereOrNull((element) => element.$2.id == updatedTask.id);
    if (updatedValue != null) {
      _tasks[updatedValue.$1] = updatedTask;
    }
  }

  void _addTask(BuildContext context) {
    showInputDialog(
      context,
      title: context.l10n.tasks_page__add_task_dialog_title,
      onChanged: (title) {
        if (context.mounted) {
          final task = Task(
            rowId: -1,
            id: UuidGenerator.stringId(),
            parentId: widget.goal.id,
            createdDate: DateTime.now(),
            title: title,
            description: '',
            isFinished: false,
          );

          context.read<GoalsBloc>().addTask(task);

          setState(() {
            _tasks.add(task);
          });
        }
      },
    );
  }
}

class _GoalDescriptionWidget extends StatelessWidget {
  const _GoalDescriptionWidget({
    required this.goal,
    required this.onTap,
  });

  final Goal goal;
  final VoidCallback onTap;

  Widget _getItem(String title, String subtitle, {int maxLines = 2}) {
    return Row(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            subtitle,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final createdDate =
        '${DateFormat.yMEd('ru').format(goal.createdDate)} ${DateFormat.Hm('ru').format(goal.createdDate)}';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              spacing: 4,
              children: [
                _getItem(
                  context.l10n.tasks_page__name_title,
                  goal.title,
                ),
                _getItem(
                  context.l10n.tasks_page__description_title,
                  goal.description.isEmpty ? '...' : goal.description,
                  maxLines: 8,
                ),
                _getItem(
                  context.l10n.tasks_page__created_date_title,
                  createdDate,
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: onTap,
              icon: Icon(
                Icons.edit,
              ))
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.task,
    required this.onChanged,
    required this.onTapDelete,
    required this.onTapRename,
  });

  final Task task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTapDelete;
  final VoidCallback onTapRename;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final leadingActions = [
      SwipeAction(
        icon: _buildIcon(
          Icons.edit,
        ),
        title: context.l10n.tasks_page__edit_title,
        style: const TextStyle(fontSize: AppDim.eight, color: Colors.white),
        onTap: (CompletionHandler handler) async {
          await handler(false);
          onTapRename();
        },
        // color: context.appColors.positiveActionColor ?? Colors.green,
        color: Colors.transparent,
      ),
      SwipeAction(
        icon: _buildIcon(
          Icons.delete,
          color: context.appColors.negativeActionColor,
        ),
        title: l10n.item_widget__delete,
        style: TextStyle(
          fontSize: AppDim.eight,
          color: context.appColors.negativeActionColor,
        ),
        onTap: (CompletionHandler handler) async {
          await handler(false);
          onTapDelete();
        },
        // color: context.appColors.positiveActionColor ?? Colors.green,
        color: Colors.transparent,
      ),
    ];
    return GestureDetector(
      onTap: () => onChanged(!task.isFinished),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SwipeActionCell(
          backgroundColor: Colors.transparent,
          key: ValueKey(task.id),
          leadingActions: leadingActions,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
            padding: EdgeInsets.only(
              bottom: 8,
              top: 8,
            ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: Checkbox(
                    value: task.isFinished,
                    onChanged: onChanged,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme(context)
                                  .appTextStyles
                                  ?.titleMedium
                                  ?.copyWith(
                                    decoration: task.isFinished
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty)
                        Row(
                          spacing: 8,
                          children: [
                            Expanded(
                              child: Text(
                                '${context.l10n.tasks_page__description_title}${task.description}',
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme(context)
                                    .appTextStyles
                                    ?.titleMedium
                                    ?.copyWith(
                                      fontSize: 10,
                                      decoration: task.isFinished
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.chevron_right_sharp,
                    color: context.appColors.dividerColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDim.four),
      child: Icon(
        icon,
        color: color ?? Colors.white,
      ),
    );
  }
}
