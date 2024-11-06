import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/models/user_model.dart';

class FirebaseFunctions {
  static getUsersCollection() => FirebaseFirestore.instance
      .collection(
        'users',
      )
      .withConverter<UserModel>(
        fromFirestore: (docSnapshot, options) =>
            UserModel.fromJson(docSnapshot.data()!),
        toFirestore: (userModel, _) => userModel.toJson(),
      );

  static getTasksCollection(String userId) => getUsersCollection()
    .doc(userId)
    .collection('tasks')
    .withConverter<TaskModel>(
      fromFirestore: (docSnapshot, options) =>
          TaskModel.fromJson(docSnapshot.data()!),
   toFirestore: (taskModel, _) => taskModel.toJson() as Map<String, Object?>,
    );
  static Future<void> addTasksToFirestore(TaskModel task, String userId) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> doc = tasksCollection.doc();
    task.id = doc.id;
    return doc.set(task);
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs
        .map(
          (docSnapshot) => docSnapshot.data(),
        )
        .toList();
  }

  static Future<void> deleteTaskFromFirestore(
      String taskId, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(taskId).delete();
  }

 static Future<void> updateTaskInFirestore(TaskModel task, String userId) async {
  CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
  await tasksCollection.doc(task.id).update(task.toJson());
}


 static Future<UserModel> register({
  required String name,
  required String email,
  required String password,
}) async {
  UserCredential credential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  UserModel user = UserModel(
    id: credential.user!.uid,
    name: name,
    email: email,
  );
  CollectionReference<UserModel> usersCollection = getUsersCollection();
  await usersCollection.doc(user.id).set(user);
  return user;
}

 static Future<UserModel> login({
  required String email,
  required String password,
}) async {
  UserCredential credential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  CollectionReference<UserModel> usersCollection = getUsersCollection();
  DocumentSnapshot<UserModel> docSnapshot = await usersCollection
      .doc(credential.user!.uid)
      .get();

  if (!docSnapshot.exists) {
    throw FirebaseException(
      plugin: 'cloud_firestore',
      code: 'not-found',
      message: 'User document not found',
    );
  }

  return docSnapshot.data()!;
}


  static Future<void> logout() => FirebaseAuth.instance.signOut();
}
