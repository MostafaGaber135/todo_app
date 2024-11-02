import 'package:flutter/material.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();
  Future<void> getTasks() async {
    List<TaskModel> allTasks =
        await FirebaseFunctions.getAllTasksFromFirestore();
    tasks = allTasks
        .where(
          (task) =>
              task.date.year == selectedDate.year &&
              task.date.month == selectedDate.month &&
              task.date.day == selectedDate.day,
        )
        .toList();
    notifyListeners();
  }

  void getSelectedDateTasks(DateTime date) {
    selectedDate = date;
    getTasks();
  }

  void updateTask(TaskModel updatedTask) {
   final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
