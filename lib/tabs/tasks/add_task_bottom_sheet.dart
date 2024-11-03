import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';

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
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(
              15,
            ),
            right: Radius.circular(
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
                widget.task == null ? 'Add new task' : 'Edit task',
                style: titleMediumStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: titleController,
                hintText: 'Enter task title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task title';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              CustomTextFormField(
                controller: descriptionController,
                hintText: 'Enter task description',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Select date',
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
                  if (dateTime != null) {
                    selectedDate = dateTime;
                  }
                  setState(() {});
                },
                child: Text(
                  dateFormat.format(
                    selectedDate,
                  ),
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              CustomElevatedButton(
                label: widget.task == null ? 'Add' : 'Save Changes',
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
    FirebaseFunctions.addTasksToFirestore(
      task,
    ).timeout(
      const Duration(microseconds: 100),
      onTimeout: () {
        if (!mounted) return;
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).getTasks();
        Fluttertoast.showToast(
          msg: "Task added successfully",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 5,
          backgroundColor: AppTheme.green,
        );
      },
    ).catchError(
      (error) {
        Fluttertoast.showToast(
          msg: "Something went wrong",
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
    FirebaseFunctions.updateTaskInFirestore(
      updatedTask,
    ).timeout(
      const Duration(
        microseconds: 100,
      ),
      onTimeout: () {
        if (!mounted) return;
        Navigator.of(context).pop();
        Provider.of<TasksProvider>(context, listen: false).updateTask(
          updatedTask,
        );
        Provider.of<TasksProvider>(context, listen: false).getTasks();
        Fluttertoast.showToast(
          msg: "Task updated successfully",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: AppTheme.green,
        );
      },
    ).catchError((error) {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: AppTheme.red,
      );
    });
  }
}