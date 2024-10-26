import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/widgets/custom_elevated_button.dart';
import 'package:todo/widgets/custom_text_form_field.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

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
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.5,
      padding: const EdgeInsets.all(
        20,
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              'Add new task',
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
                  return 'Title can not be empty';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            CustomTextFormField(
              controller: descriptionController,
              hintText: 'Enter description title',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description can not be empty';
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
                  initialDate: selectedDate,
                  lastDate: DateTime.now().add(
                    const Duration(
                      days: 365,
                    ),
                  ),
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                );
                if (dateTime != null && dateTime != selectedDate) {
                  selectedDate = dateTime;
                  setState(() {});
                }
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
              label: 'Add',
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  addTask();
                }
              },
            ),
          ],
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
  }
}
