part of 'task_form_notifier.dart';

final class TaskFormState with FormzMixin, EquatableMixin {
  const TaskFormState() : this._(collection: '');

  const TaskFormState._({
    required this.collection,
    this.title = const TaskTitle.pure(),
    this.isDone = false,
    this.dueDate,
    this.initialTask,
    this.newTask,
    this.parentTask,
  });

  final String collection;
  final TaskTitle title;
  final bool isDone;
  final DateTime? dueDate;
  final Task? initialTask;
  final Task? newTask;
  final Task? parentTask;

  TaskFormState withCollection(String value) {
    return TaskFormState._(
      collection: value,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withParentTask(Task value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: value,
    );
  }

  TaskFormState withTitle(String value) {
    return TaskFormState._(
      collection: collection,
      title: TaskTitle.dirty(value),
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withIsDone(bool? value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: value ?? false,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withDueDate(DateTime? value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: isDone,
      dueDate: value,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withTask(Task value) {
    return TaskFormState._(
      collection: value.collection,
      title: TaskTitle.dirty(value.title),
      isDone: value.isDone,
      dueDate: value.dueDate,
      initialTask: value,
      parentTask: parentTask,
    );
  }

  bool get isEdit => initialTask != null;

  bool get hasChanges {
    return initialTask?.collection != collection ||
        initialTask?.title != title.value ||
        initialTask?.isDone != isDone ||
        initialTask?.dueDate != dueDate;
  }

  @override
  List<Object?> get props => [
    collection,
    title,
    isDone,
    dueDate,
    initialTask,
    newTask,
  ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [title];
}
