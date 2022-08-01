import 'package:flutter/material.dart';
import 'package:todo_list/ui/widgets/task_form/task_form_widget_model.dart';

class TaskFormWidget extends StatefulWidget {
  final int groupKey;

  const TaskFormWidget({
    Key? key,
    required this.groupKey,
  }) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  late final TaskFormWidgetModel _model;

  @override
  void initState() {
    super.initState();
    _model = TaskFormWidgetModel(groupKey: widget.groupKey);
  }

  @override
  Widget build(BuildContext context) {
    return TaskFormWidgetModelProvider(
      model: _model,
      child: const _TaskFormWidgetBody(),
    );
  }
}

class _TaskFormWidgetBody extends StatelessWidget {
  const _TaskFormWidgetBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _TaskTextWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            TaskFormWidgetModelProvider.read(context)?.model.saveTask(context),
        child: const Icon(Icons.done),
      ),
    );
  }
}

class _TaskTextWidget extends StatelessWidget {
  const _TaskTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = TaskFormWidgetModelProvider.read(context)?.model;

    return TextField(
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Task Text',
      ),
      autofocus: true,
      maxLines: null,
      expands: true,
      onChanged: (value) => model?.taskText = value,
      onEditingComplete: () => model?.saveTask(context),
    );
  }
}
