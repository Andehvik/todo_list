import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (ctx, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          trailing: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              taskProvider.toggleTaskCompletion(index);
            },
          ),
        );
      },
    );
  }
}
