import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key, this.task});
  final TaskModel? task;
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat(
    'dd/MM/yyyy',
  );
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    selectedDate = widget.task?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        decoration: BoxDecoration(
          color: settingsProvider.isDark ? AppTheme.black : AppTheme.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(
              15,
            ),
            topRight: Radius.circular(
              15,
            ),
          ),
        ),
        padding: const EdgeInsets.all(
          20,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                widget.task == null
                    ? AppLocalizations.of(context)!.addNewTask
                    : AppLocalizations.of(context)!.editTask,
                style: titleMediumStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: titleController,
                hintText: AppLocalizations.of(context)!.enterTaskTitle,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterTaskTitle;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: descriptionController,
                hintText: AppLocalizations.of(context)!.enterTaskDescription,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(context)!
                        .pleaseEnterTaskDescription;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                AppLocalizations.of(context)!.selectDate,
                style: titleMediumStyle?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () async {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(
                        days: 365,
                      ),
                    ),
                    initialDate: selectedDate,
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                  );
                  selectedDate = dateTime!;
                  setState(() {});
                },
                child: Text(
                  dateFormat.format(
                    selectedDate,
                  ),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: settingsProvider.isDark
                            ? AppTheme.white
                            : AppTheme.black,
                      ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              CustomElevatedButton(
                label: widget.task == null
                    ? AppLocalizations.of(context)!.add
                    : AppLocalizations.of(context)!.saveChanges,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (widget.task == null) {
                      addTask();
                    } else {
                      updateTask();
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addTask() {
    TaskModel task = TaskModel(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
    String userId = Provider.of<UserProvider>(
      context,
      listen: false,
    ).currentUser!.id;
    FirebaseFunctions.addTasksToFirestore(
      task,
      userId,
    ).then(
      (_) {
        if (!mounted) return;
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg:     AppLocalizations.of(context)!.taskAddedSuccessfully,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
        );
      },
    ).catchError(
      (error) {
        if(!mounted)return;
        Fluttertoast.showToast(
          msg:     AppLocalizations.of(context)!.somethingWentWrong,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.red,
        );
      },
    );
  }

  void updateTask() {
    TaskModel updatedTask = widget.task!.copyWith(
      title: titleController.text,
      description: descriptionController.text,
      date: selectedDate,
    );
    String userId =
        Provider.of<UserProvider>(context, listen: false).currentUser!.id;

    FirebaseFunctions.updateTaskInFirestore(
      updatedTask,
      userId,
    ).then(
      (_) {
        if (!mounted) return;
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false)
            .updateTask(updatedTask);
        Provider.of<TasksProvider>(context, listen: false).getTasks(userId);
        Fluttertoast.showToast(
          msg:     AppLocalizations.of(context)!.taskUpdatedSuccessfully,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: AppTheme.green,
        );
      },
    ).catchError((error) {
      if(!mounted)return;
      Fluttertoast.showToast(
        msg:     AppLocalizations.of(context)!.somethingWentWrong,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: AppTheme.red,
      );
    });
  }
}
