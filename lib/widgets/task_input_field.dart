import 'package:flutter/material.dart';

class TaskInputField extends StatelessWidget {
  final ValueChanged<String> onTaskSubmitted;

  const TaskInputField({super.key, required this.onTaskSubmitted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Add a task',
          border: OutlineInputBorder(),
        ),
        onSubmitted: onTaskSubmitted,
      ),
    );
  }
}
