import 'package:hive/hive.dart';
import 'package:todo_list/domain/entity/group.dart';
import 'package:todo_list/domain/entity/task.dart';

class BoxManager {
  static final BoxManager instance = BoxManager._();
  final Map<String, int> _boxCounter = <String, int>{};

  BoxManager._();

  Future<Box<T>> _openBox<T>(
    int typeId,
    TypeAdapter<T> adapter,
    String nameBox,
  ) async {
    if (Hive.isBoxOpen(nameBox)) {
      final count = _boxCounter[nameBox] ?? 1;
      _boxCounter[nameBox] = count + 1;
      return Hive.box(nameBox);
    }

    _boxCounter[nameBox] = 1;
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return Hive.openBox<T>(nameBox);
  }

  Future<Box<Group>> openGroupBox() async {
    return _openBox(1, GroupAdapter(), 'groups_box');
  }

  Future<Box<Task>> openTaskBox(int groupKey) async {
    return _openBox(2, TaskAdapter(), makeTaskBoxName(groupKey));
  }

  Future<void> closeBox<T>(Box<T> box) async {
    if (!box.isOpen) {
      _boxCounter.remove(box.name);
      return;
    }

    var count = _boxCounter[box.name] ?? 1;
    count--;
    _boxCounter[box.name] = count;
    if (count > 0) return;

    _boxCounter.remove(box.name);
    await box.compact();
    await box.close();
  }

  String makeTaskBoxName(int groupKey) {
    return 'tasks_box_$groupKey';
  }
}
