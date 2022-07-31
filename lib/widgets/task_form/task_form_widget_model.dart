import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskFormWidgetModel {
  String taskText = '';
  int groupKey;

  TaskFormWidgetModel({
    required this.groupKey,
  });

  void saveTask(BuildContext context) async {
    if (taskText.isEmpty) return;

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }

    final groupBox = await Hive.openBox<Group>('boxGroups');
    final taskBox = await Hive.openBox<Task>('boxTasks');

    final task = Task(title: taskText, isDone: false);
    taskBox.add(task);

    final group = groupBox.get(groupKey);
    group?.addTask(taskBox, task);

    Navigator.of(context).pop();
  }
}

class TaskFormWidgetModelProvider extends InheritedWidget {
  final TaskFormWidgetModel model;

  const TaskFormWidgetModelProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(key: key, child: child);

  static TaskFormWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskFormWidgetModelProvider>();
  }

  static TaskFormWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskFormWidgetModelProvider>()
        ?.widget;
    return widget is TaskFormWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskFormWidgetModelProvider old) {
    return false;
  }
}
