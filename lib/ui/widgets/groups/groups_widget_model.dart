import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';
import 'package:todo_list/ui/navigation/main_navigation.dart';

class GroupsWidgetModel extends ChangeNotifier {
  var _groups = <Group>[];

  GroupsWidgetModel() {
    setUp();
  }

  List<Group> get groups => _groups.toList();

  void showForm(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.groupsForm);
  }

  void showTasks(BuildContext context, int index) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('boxGroups');
    final groupKey = box.keyAt(index) as int;

    unawaited(
        Navigator.of(context).pushNamed(MainNavigationRouteNames.tasks, arguments: groupKey));
  }

  void setUp() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('boxGroups');
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(TaskAdapter());
    }
    await Hive.openBox<Task>('boxTasks');

    _readGroupsFromHive(box);
    box.listenable().addListener(() => _readGroupsFromHive(box));
  }

  void _readGroupsFromHive(Box<Group> box) {
    _groups = box.values.toList();
    notifyListeners();
  }

  void deleteGroup(int index) async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(GroupAdapter());
    }
    final box = await Hive.openBox<Group>('boxGroups');
    box.getAt(index)?.tasks?.deleteAllFromHive();
    await box.deleteAt(index);
  }
}

class GroupsWidgetModelProvider extends InheritedNotifier {
  final GroupsWidgetModel model;

  const GroupsWidgetModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, child: child, notifier: model);

  static GroupsWidgetModelProvider? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GroupsWidgetModelProvider>();
  }

  static GroupsWidgetModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<GroupsWidgetModelProvider>()
        ?.widget;
    return widget is GroupsWidgetModelProvider ? widget : null;
  }

  @override
  bool updateShouldNotify(GroupsWidgetModelProvider old) {
    return true;
  }
}
