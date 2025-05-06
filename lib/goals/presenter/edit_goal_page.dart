import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/app/utils/localization_extension.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';
import 'package:psws_storage/goals/domain/models/goal.dart';

@RoutePage()
class EditGoalPage extends StatelessWidget {
  const EditGoalPage({
    super.key,
    required this.element,
  });

  final dynamic element;

  @override
  Widget build(BuildContext context) {
    return LifeCycleWidget(
      routeData: context.routeData,
      child: Builder(
        builder: (context) {
          if (element is Goal) {
            return _EditGoalForm(goal: element);
          }

          if (element is Task) {
            return _EditTaskForm(
              task: element,
            );
          }

          return Scaffold(
            body: Center(
              child: Text('${element.runtimeType} не поддерживается'),
            ),
          );
        },
      ),
    );
  }
}

class _EditGoalForm extends StatefulWidget {
  const _EditGoalForm({required this.goal});

  final Goal goal;

  @override
  State<_EditGoalForm> createState() => _EditGoalFormState();
}

class _EditGoalFormState extends State<_EditGoalForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.goal.title;
    _descriptionController.text = widget.goal.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.goal.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      Text(widget.goal.id),
                      _InputWidget(
                        controller: _titleController,
                        hint: context.l10n.edit_goal_page__name_goal_input,
                      ),
                      _InputWidget(
                        controller: _descriptionController,
                        hint:
                            context.l10n.edit_goal_page__description_goal_input,
                        maxLines: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      final updatedGoal = widget.goal.copyWith(
                          title: _titleController.text,
                          description: _descriptionController.text);

                      context.maybePop(updatedGoal);
                    },
                    child: Text(context.l10n.edit_goal_page__save_button),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EditTaskForm extends StatefulWidget {
  const _EditTaskForm({
    required this.task,
  });

  final Task task;

  @override
  State<_EditTaskForm> createState() => _EditTaskFormState();
}

class _EditTaskFormState extends State<_EditTaskForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.task.title),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      Text(widget.task.id),
                      _InputWidget(
                        controller: _titleController,
                        hint: context.l10n.edit_goal_page__name_task_input,
                      ),
                      _InputWidget(
                        controller: _descriptionController,
                        hint:
                            context.l10n.edit_goal_page__description_task_input,
                        maxLines: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: OutlinedButton(
                    onPressed: () {
                      final updatedTask = widget.task.copyWith(
                          title: _titleController.text,
                          description: _descriptionController.text);

                      context.maybePop(updatedTask);
                    },
                    child: Text(context.l10n.edit_goal_page__save_button),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InputWidget extends StatelessWidget {
  const _InputWidget(
      {required this.controller, required this.hint, this.maxLines = 3});

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: context.appColors.dividerColor ?? Colors.grey,
        ));
    return TextFormField(
      controller: controller,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          labelText: hint,
          labelStyle: context.appTextStyles.titleMedium?.copyWith(
            fontSize: 16,
            color: context.appColors.dividerColor,
          )),
    );
  }
}
