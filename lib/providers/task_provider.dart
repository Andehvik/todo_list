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

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
   _tasks[index].isDone = !_tasks[index].isDone;
   notifyListeners();
  }
  String setCategoryName(String categoryName) {
    this.categoryName = categoryName;
    notifyListeners();
    return this.categoryName;
  }
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }


// Implement methods to update and delete tasks

// You can also add methods for fetching and managing tasks
}