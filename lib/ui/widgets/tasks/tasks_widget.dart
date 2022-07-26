import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/ui/widgets/tasks/tasks_widget_model.dart';

class TaskWidgetConfiguration {
  int groupKey;
  String title;

  TaskWidgetConfiguration(this.groupKey, this.title);
}

class TasksWidget extends StatefulWidget {
  final TaskWidgetConfiguration configuration;

  const TasksWidget({
    Key? key,
    required this.configuration,
  }) : super(key: key);

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  late final TaskWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskWidgetModel(configuration: widget.configuration);
  }

  @override
  Widget build(BuildContext context) {
    return TaskWidgetModelProvider(
      model: _model,
      child: const _TaskWidgetModelBody(),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _model.dispose();
  }
}

class _TaskWidgetModelBody extends StatelessWidget {
  const _TaskWidgetModelBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.watch(context)?.model;
    final title = model?.configuration.title ?? 'Tasks';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const _TaskListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model?.showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskListWidget extends StatelessWidget {
  const _TaskListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasksCount =
        TaskWidgetModelProvider.watch(context)?.model.tasks.length ?? 0;

    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _TaskListRowWidget(index: index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1);
      },
      itemCount: tasksCount,
    );
  }
}

class _TaskListRowWidget extends StatelessWidget {
  final int index;

  const _TaskListRowWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskWidgetModelProvider.read(context)!.model;
    final text = model.tasks[index].title;

    final icon = model.tasks[index].isDone
        ? const Icon(Icons.done, color: Colors.green)
        : null;
    final style = model.tasks[index].isDone
        ? const TextStyle(decoration: TextDecoration.lineThrough)
        : null;

    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: ((context) => model.deleteTask(index)),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          text,
          style: style,
        ),
        trailing: icon,
        onTap: () => model.doneToggle(index),
      ),
    );
  }
}
