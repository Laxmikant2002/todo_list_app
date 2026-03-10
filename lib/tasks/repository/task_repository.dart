import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import '../model/task.dart';

class TaskRepository {
  final FirebaseAuth _auth;
  final DatabaseReference _database;
  static const _defaultDatabaseUrl =
      'https://todoapp-2026-366a6-default-rtdb.asia-southeast1.firebasedatabase.app';

  TaskRepository({
    FirebaseAuth? auth,
    DatabaseReference? database,
    String? databaseUrl,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _database =
           database ??
           FirebaseDatabase.instanceFor(
             app: Firebase.app(),
             databaseURL: databaseUrl ?? _defaultDatabaseUrl,
           ).ref();

  String? get _userId => _auth.currentUser?.uid;

  DatabaseReference get _tasksRef => _database.child('users/$_userId/tasks');

  // Listen to tasks in realtime (optional – if you want realtime updates)
  Stream<List<Task>> tasksStream() {
    if (_userId == null) {
      debugPrint('⚠️ No user ID, returning empty stream');
      return Stream.value(<Task>[]);
    }

    debugPrint('🔗 Listening to $_tasksRef');

    try {
      return _tasksRef.onValue.map<List<Task>>((event) {
        final snapshot = event.snapshot;
        if (!snapshot.exists) return <Task>[];

        final tasks = <Task>[];
        for (final child in snapshot.children) {
          try {
            tasks.add(Task.fromSnapshot(child));
          } catch (e, stack) {
            debugPrint('❌ Error parsing task: $e');
            debugPrint('$stack');
          }
        }

        tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return tasks;
      });
    } catch (e) {
      debugPrint('💥 Exception in tasksStream: $e');
      final wrappedError = e is Object ? e : Exception('Unknown error: $e');
      return Stream<List<Task>>.error(wrappedError);
    }
  }

  // Fetch tasks once
  Future<List<Task>> fetchTasks() async {
    if (_userId == null) return [];
    final snapshot = await _tasksRef.get();
    if (!snapshot.exists) return [];

    final tasks = <Task>[];
    for (final child in snapshot.children) {
      try {
        tasks.add(Task.fromSnapshot(child));
      } catch (e, stack) {
        debugPrint('❌ Error parsing task in fetchTasks: $e');
        debugPrint('$stack');
      }
    }

    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
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
