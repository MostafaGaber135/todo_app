class TaskModel {
  String id;
  final String title;
  final String description;
  final DateTime date;
  final bool isDone;

  TaskModel({
     this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
  });
}
