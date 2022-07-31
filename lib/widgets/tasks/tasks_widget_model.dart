import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class TaskWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupBox;

  var _tasks = <Task>[];
  List<Task> get tasks => _tasks.toList();

  Group? _group;
  Group? get group => _group;

  TaskWidgetModel({required this.groupKey}) {
    setup();
  }

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed('/groups/tasks/form', arguments: groupKey);
  }

  void loadGroup() async {
    final box = await _groupBox;
    _group = box.get(groupKey);
    notifyListeners();
  }

  void _readTasks() {
    _tasks = _group?.tasks ?? <Task>[];
    notifyListeners();
  }

  void _setupListenTasks() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('boxTasks');

    final box = await _groupBox;
    _readTasks();
    box.listenable(keys: <dynamic>[groupKey]).addListener(_readTasks);
  }

  void setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox<Group>('boxGroups');
    loadGroup();
    _setupListenTasks();
  }

  void deleteTask(int groupIndex) async {
    await _group?.tasks?.deleteFromHive(groupIndex);
    await _group?.save();
  }

  void doneToggle(int groupIndex) async {
    final task = tasks[groupIndex];
    final currentState = task.isDone;
    task.isDone = !currentState;
    await task.save();
    notifyListeners();

    // final task = _group?.tasks?[groupIndex];
    // final currentState = task?.isDone ?? false;
    // task?.isDone = !currentState;
    // await task?.save();
    // notifyListeners();
  }
}

class TaskWidgetModelProvider extends InheritedNotifier {
  final TaskWidgetModel model;

  const TaskWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, child: child, notifier: model);

  static TaskWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TaskWidgetModelProvider>();
  }

  static TaskWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<TaskWidgetModelProvider>()
        ?.widget;
    return widget is TaskWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(TaskWidgetModelProvider old) {
    return true;
  }
}
