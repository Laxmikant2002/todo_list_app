import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../model/task.dart';

class TaskRepository {
  final FirebaseAuth _auth;
  final DatabaseReference _database;

  TaskRepository({
    FirebaseAuth? auth,
    DatabaseReference? database,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _database = database ?? FirebaseDatabase.instance.ref();

  String? get _userId => _auth.currentUser?.uid;

  DatabaseReference get _tasksRef => _database.child('users/$_userId/tasks');

  // Listen to tasks in realtime (optional – if you want realtime updates)
  Stream<List<Task>> tasksStream() {
    if (_userId == null) return Stream.value([]);
    return _tasksRef.onValue.map((event) {
      final map = event.snapshot.value as Map<dynamic, dynamic>?;
      if (map == null) return [];
      return map.entries.map((e) {
        return Task.fromJson(e.key as String, e.value as Map<String, dynamic>);
      }).toList()..sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      ); // newest first
    });
  }

  // Fetch tasks once
  Future<List<Task>> fetchTasks() async {
    if (_userId == null) return [];
    final snapshot = await _tasksRef.get();
    if (!snapshot.exists) return [];
    final map = snapshot.value as Map<dynamic, dynamic>?;
    if (map == null) return [];
    return map.entries.map((e) {
      return Task.fromJson(e.key as String, e.value as Map<String, dynamic>);
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> addTask(Task task) async {
    final newTaskRef = _tasksRef.push();
    await newTaskRef.set(task.toJson());
  }

  Future<void> updateTask(Task task) async {
    await _tasksRef.child(task.id).update(task.toJson());
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.child(taskId).remove();
  }
}
