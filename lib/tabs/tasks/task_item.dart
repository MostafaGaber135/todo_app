import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/add_task_bottom_sheet.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });
  final TaskModel task;
  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Slidable(
        key: ValueKey(widget.task.id),
        startActionPane: ActionPane(
          motion: const StretchMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            String userId = Provider.of<UserProvider>(
              context,
              listen: false,
            ).currentUser!.id;
            FirebaseFunctions.deleteTaskFromFirestore(
              widget.task.id,
              userId,
            ).then(
              (_) {
                if (context.mounted) {
                  Provider.of<TasksProvider>(
                    context,
                    listen: false,
                  ).getTasks(
                    userId,
                  );
                }
                if (!context.mounted) return;
                Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.taskDeletedSuccessfully,
                  toastLength: Toast.LENGTH_LONG,
                  timeInSecForIosWeb: 5,
                  backgroundColor: AppTheme.green,
                );
              },
            ).catchError(
              (_) {
                if (!context.mounted) return;
                Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.somethingWentWrong,
                  toastLength: Toast.LENGTH_LONG,
                  backgroundColor: AppTheme.red,
                );
              },
            );
          }),
          children: [
            SlidableAction(
              onPressed: (_) {
                String userId = Provider.of<UserProvider>(
                  context,
                  listen: false,
                ).currentUser!.id;
                FirebaseFunctions.deleteTaskFromFirestore(
                  widget.task.id,
                  userId,
                ).then(
                  (_) {
                    if (context.mounted) {
                      Provider.of<TasksProvider>(
                        context,
                        listen: false,
                      ).getTasks(
                        userId,
                      );
                    }
                    if (!context.mounted) return;
                    Fluttertoast.showToast(
                      msg:
                          AppLocalizations.of(context)!.taskDeletedSuccessfully,
                      backgroundColor: AppTheme.green,
                    );
                  },
                ).catchError(
                  (_) {
                    if (!context.mounted) return;
                    Fluttertoast.showToast(
                      msg: AppLocalizations.of(context)!.somethingWentWrong,
                      backgroundColor: AppTheme.red,
                    );
                  },
                );
              },
              backgroundColor: AppTheme.red,
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.trash,
              label: AppLocalizations.of(context)!.delete,
            ),
            SlidableAction(
              onPressed: (_) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => AddTaskBottomSheet(
                    task: widget.task,
                  ),
                );
              },
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              icon: FontAwesomeIcons.pen,
              label: AppLocalizations.of(context)!.edit,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(
            20,
          ),
          decoration: BoxDecoration(
            color: settingsProvider.isDark
                ? AppTheme.backgroundColorBottomNavigationBar
                : AppTheme.white,
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 62,
                width: 4,
                margin: const EdgeInsetsDirectional.only(
                  end: 12,
                ),
                color: widget.task.isDone ? AppTheme.green : AppTheme.primary,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: textTheme.titleMedium?.copyWith(
                      color: widget.task.isDone
                          ? AppTheme.green
                          : AppTheme.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    widget.task.description,
                    style: textTheme.titleSmall?.copyWith(
                      color: settingsProvider.isDark
                          ? AppTheme.white
                          : AppTheme.backgroundColorBottomNavigationBar,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: toggleTaskDone,
                child: widget.task.isDone
                    ? Text(
                        AppLocalizations.of(context)!.done,
                        style: const TextStyle(
                          color: AppTheme.green,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(
                        height: 34,
                        width: 69,
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.check,
                          color: AppTheme.white,
                          size: 32,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleTaskDone() async {
    String userId = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser!.id;

    setState(() {
      widget.task.toggleDone();
    });
    await FirebaseFunctions.updateTaskInFirestore(
      widget.task,
      userId,
    );
    if (!mounted) return;
    Fluttertoast.showToast(
      msg: widget.task.isDone
          ? AppLocalizations.of(context)!.taskMarkedAsDone
          : AppLocalizations.of(context)!.taskMarkedAsNotDone,
      backgroundColor: widget.task.isDone ? AppTheme.green : AppTheme.red,
    );
  }
}
