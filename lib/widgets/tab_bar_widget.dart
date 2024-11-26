import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

class TabBarWidget extends StatelessWidget {
  final List<TaskProvider> taskLists;
  final ValueChanged<int> onTabSelected;
  final ValueChanged<int> onTabOptionsSelected;

  const TabBarWidget({
    super.key,
    required this.taskLists,
    required this.onTabSelected,
    required this.onTabOptionsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: onTabSelected,
      tabs: taskLists.map((taskProvider) {
        return GestureDetector(
          onLongPress: () => onTabOptionsSelected(taskLists.indexOf(taskProvider)),
          child: Tab(text: taskProvider.categoryName),
        );
      }).toList(),
    );
  }
}
