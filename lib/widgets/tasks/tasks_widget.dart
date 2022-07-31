import 'package:flutter/material.dart';
import 'package:todo_list/widgets/tasks/tasks_widget_model.dart';

class TasksWidget extends StatefulWidget {
  const TasksWidget({Key? key}) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  TaskWidgetModel? _model;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model == null) {
      final groupKey = ModalRoute.of(context)!.settings.arguments as int;
      _model = TaskWidgetModel(groupKey: groupKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskWidgetModelProvider(
      model: _model!,
      child: const _TaskWidgetModelBody(),
    );
  }
}

class _TaskWidgetModelBody extends StatelessWidget {
  const _TaskWidgetModelBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.group?.name ?? 'Tasks';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
