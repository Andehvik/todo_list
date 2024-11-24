import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final List<TaskProvider> taskLists = [];
  int currentTabIndex = 0;
  int counter = 0;

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
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            tabs: List.generate(taskLists.length, (index) {
              return GestureDetector(
                onLongPress: () => _showTabOptionsDialog(index),
                child: Tab(
                  text: taskLists[index].categoryName,
                ),
              );
            }),
          ),
        ),
        body: TabBarView(
          children: List.generate(taskLists.length, (index) {
            return ChangeNotifierProvider.value(
              value: taskLists[index],
              child: TaskListWidget(),
            );
          }),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'addTab',
              onPressed: _showAddCategoryDialog,
              child: const Icon(Icons.add_box),
              backgroundColor: Colors.blue,
              tooltip: 'Add New Tab',
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'addTask',
              onPressed: () => _showAddTaskDialog(context, currentTabIndex),
              child: const Icon(Icons.add),
              backgroundColor: Colors.green,
              tooltip: 'Add Task to Current Tab',
            ),
          ],
        ),
      ),
    );
  }

  // Add New Tab (Category)
  void _addNewCategory(String categoryName) {
    setState(() {
      final newProvider = TaskProvider();
      newProvider.setCategoryName(categoryName);
      taskLists.add(newProvider);
    });
  }

  // Show Add Category Dialog
  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Tab'),
        content: TextField(
          controller: categoryController,
          decoration: const InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                _addNewCategory(categoryController.text);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Show Tab Options (Edit/Delete)
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
                Navigator.of(ctx).pop(); // Close this dialog
                _showEditTabDialog(tabIndex); // Show edit dialog
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Tab'),
              onTap: () {
                Navigator.of(ctx).pop(); // Close this dialog
                _deleteTab(tabIndex);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Edit Tab Name
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  taskLists[tabIndex].setCategoryName(categoryController.text);
                });
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete Tab
  void _deleteTab(int tabIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Tab'),
        content: const Text('Are you sure you want to delete this tab?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                taskLists.removeAt(tabIndex);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Add New Task
  void _showAddTaskDialog(BuildContext context, int tabIndex) {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                taskLists[tabIndex].addTask(
                  Task(
                    title: taskController.text,
                    id: counter.toString(),
                    isDone: false,
                  ),
                );
                counter++;
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// Task List Widget
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
          onLongPress: () {
            // Show deletion menu
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Task'),
                content: const Text('Do you want to delete this task?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      taskProvider.deleteTask(task);
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

