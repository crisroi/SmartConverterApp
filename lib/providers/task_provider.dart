import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  static const _storageKey = 'tasks_list';
  List<TaskModel> _tasks = [];

  List<TaskModel> get activeTasks =>
      _tasks.where((t) => !t.isCompleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<TaskModel> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  TaskProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      final List decoded = jsonDecode(raw);
      _tasks = decoded.map((e) => TaskModel.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  void addTask({required String title, String note = ''}) {
    _tasks.add(TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      note: note,
      createdAt: DateTime.now(),
    ));
    _saveTasks();
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void editTask(String id, {required String title, String note = ''}) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(title: title, note: note);
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }
}
