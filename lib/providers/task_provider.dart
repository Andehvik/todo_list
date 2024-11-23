import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  String categoryName = "Your List";

  List<Task> get tasks {
    return [..._tasks];
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
   tasks[index].isDone = !tasks[index].isDone;
   notifyListeners();
  }
  String setName(String categoryName) {
    return this.categoryName = categoryName;
  }

// Implement methods to update and delete tasks

// You can also add methods for fetching and managing tasks
}