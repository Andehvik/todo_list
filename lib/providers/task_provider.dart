import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'dart:convert';

class TaskProvider with ChangeNotifier {
  Function onTaskListChange;

  TaskProvider({required this.onTaskListChange});

  List<Task> _tasks = [];
  String categoryName = "";

  List<Task> get tasks {
    return [..._tasks];
  }

 void exportToJson(){
   final List<Map<String, dynamic>> data = [toJSON()];
   final String jsonString = jsonEncode(data);
   print(jsonString); // Replace with your actual export logic
  }

  void addTask(Task task) {
    _tasks.add(task);
    sortTasks();
    notifyListeners();
  }
  void sortTasks() {
    _tasks.sort((a,b){
      if(a.isDone == b.isDone) {
        return 0;
      }
      if(a.isDone){
        return 1;
      }else{
        return -1;
      }
    });
    notifyListeners();
    onTaskListChange();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
    onTaskListChange();
  }

  void toggleTaskCompletion(int index) {
   _tasks[index].isDone = !_tasks[index].isDone;
   sortTasks();
   notifyListeners();
  }
  String setCategoryName(String categoryName) {
    this.categoryName = categoryName;
    notifyListeners();
    onTaskListChange();
    return this.categoryName;
  }
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < _tasks.length) {
      _tasks[index] = updatedTask;
      notifyListeners();
      onTaskListChange();
    }
  }

  Map <String, dynamic> toJSON(){
    var jsonFile = {
      'categoryName': categoryName,
      'tasks': tasks.map((task) => task.toJSON()).toList()
    };
    return jsonFile;
  }

}