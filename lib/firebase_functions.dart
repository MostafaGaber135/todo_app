import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/task_model.dart';

class FirebaseFunctions {
  static getTasksCollection() => FirebaseFirestore.instance
      .collection(
        'tasks',
      )
      .withConverter<TaskModel>(
        fromFirestore: (docSnapshot, options) =>
            TaskModel.fromJson(docSnapshot.data()!),
        toFirestore: (taskModel, _) => taskModel.toJson(),
      );

  static Future<void> addTasksToFirestore(TaskModel task) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> doc = tasksCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs
        .map(
          (docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }

  static Future<void> deleteTaskFromFirestore(String taskId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    return tasksCollection.doc(taskId).delete();
  }
}
