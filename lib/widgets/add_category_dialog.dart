import 'package:flutter/material.dart';

class AddCategoryDialog extends StatelessWidget {
  final ValueChanged<String> onCategoryAdded;

  const AddCategoryDialog({super.key, required this.onCategoryAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Tab'),
      content: TextField(
        controller: categoryController,
        decoration: const InputDecoration(hintText: 'Enter category name'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (categoryController.text.isNotEmpty) {
              onCategoryAdded(categoryController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
