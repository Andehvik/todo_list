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
  List<TaskProvider> taskLists = [TaskProvider()]; // Start with one list
  int currentTabIndex = 0;
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: taskLists.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Todo Lists'),
          backgroundColor: Colors.greenAccent,
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                currentTabIndex = index;
              });
            },
            tabs: List.generate(taskLists.length, (index) {
              return Tab(
                text: 'List ${index + 1}', // Tab names: List 1, List 2, etc.
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
            // Add New Tab Button
            FloatingActionButton(
              heroTag: 'addTab',
              onPressed: () {
                _showAddCategoryDialog();
              },
              child: Icon(Icons.add_box),
              backgroundColor: Colors.blue,
              tooltip: 'Add New Tab',
            ),
            const SizedBox(height: 16), // Spacing between buttons
            // Add Task Button
            FloatingActionButton(
              heroTag: 'addTask',
              onPressed: () {
                _showAddTaskDialog(context, currentTabIndex);
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              tooltip: 'Add Task to Current Tab',
            ),
          ],
        ),
      ),
    );
  }

  // Add New Tab (Category) Dialog
  void _showAddCategoryDialog() {
    final TextEditingController categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add New Tab'),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                setState(() {
                  taskLists.add(TaskProvider());
                });
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Add New Task Dialog
  void _showAddTaskDialog(BuildContext context, int tabIndex) {
    final TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Task'),
        content: TextField(
          controller: taskController,
          decoration: InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                taskLists[tabIndex].addTask(Task(title: taskController.text, id: counter.toString(), isDone: false));
                counter++;
                Navigator.of(ctx).pop();
              }
            },
            child: Text('Add'),
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
        );
      },
    );
  }
}


