import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../domain/entity/group.dart';

class TaskWidgetModel extends ChangeNotifier {
  int groupKey;
  late final Future<Box<Group>> _groupBox;

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

  void setup() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    _groupBox = Hive.openBox('boxGroups');
    loadGroup();
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
