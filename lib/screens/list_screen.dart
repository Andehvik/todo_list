import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../widgets/add_category_dialog.dart';
import '../widgets/tab_bar_widget.dart';
import '../widgets/task_input_field.dart';
import '../widgets/task_list_widget.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<TaskProvider> taskLists = [];
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _addNewCategory('Default List');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: taskLists.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo Lists'),
          backgroundColor: Colors.greenAccent,
        ),
        body: Column(
          children: [
            TabBarWidget(
              taskLists: taskLists,
              onTabSelected: (index) {
                setState(() => currentTabIndex = index);
              },
              onTabOptionsSelected: (index) {
                _showTabOptionsDialog(index);
              },
            ),
            TaskInputField(
              onTaskSubmitted: (value) {
                if (value.isNotEmpty) {
                  taskLists[currentTabIndex].addTask(
                    Task(id: DateTime.now().toString(), title: value, isDone: false),
                  );
                }
              },
            ),
            Expanded(
              child: TabBarView(
                children: taskLists.map((taskProvider) {
                  return ChangeNotifierProvider.value(
                    value: taskProvider,
                    child: TaskListWidget(),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'addCategory',
          onPressed: () => _showAddCategoryDialog(context),
          child: const Icon(Icons.add_box),
          backgroundColor: Colors.blue,
          tooltip: 'Add New Tab',
        ),
      ),
    );
  }

  void _addNewCategory(String categoryName) {
    setState(() {
      final newProvider = TaskProvider();
      newProvider.setCategoryName(categoryName);
      taskLists.add(newProvider);
    });
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AddCategoryDialog(
        onCategoryAdded: (name) => _addNewCategory(name),
      ),
    );
  }

  void _showEditTabDialog(int tabIndex) {
    final TextEditingController categoryController =
    TextEditingController(text: taskLists[tabIndex].categoryName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Tab Name'),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(hintText: 'Enter new tab name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel action
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  taskLists[tabIndex].setCategoryName(categoryController.text);
                });
                Navigator.of(ctx).pop(); // Close dialog after saving
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTab(int tabIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Tab'),
        content: const Text('Are you sure you want to delete this tab?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel action
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                taskLists.removeAt(tabIndex); // Remove the tab
              });
              Navigator.of(ctx).pop(); // Close dialog after deleting
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }



  void _showTabOptionsDialog(int tabIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Manage Tab: ${taskLists[tabIndex].categoryName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Tab Name'),
              onTap: () {
                Navigator.of(ctx).pop();
                _showEditTabDialog(tabIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Tab'),
              onTap: () {
                Navigator.of(ctx).pop();
                _deleteTab(tabIndex);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Task List Widg

