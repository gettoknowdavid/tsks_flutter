part of 'task_form_notifier.dart';

final class TaskFormState with FormzMixin, EquatableMixin {
  const TaskFormState() : this._(collection: '');

  const TaskFormState._({
    required this.collection,
    this.title = const TaskTitle.pure(),
    this.isDone = false,
    this.dueDate,
    this.initialTask,
  });

  final String collection;
  final TaskTitle title;
  final bool isDone;
  final DateTime? dueDate;
  final Task? initialTask;

  TaskFormState withCollection(String value) {
    return TaskFormState._(
      collection: value,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
    );
  }

  TaskFormState withParentTask(Task value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
    );
  }

  TaskFormState withTitle(String value) {
    return TaskFormState._(
      collection: collection,
      title: TaskTitle.dirty(value),
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
    );
  }

  TaskFormState withIsDone(bool? value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: value ?? false,
      dueDate: dueDate,
      initialTask: initialTask,
    );
  }

  TaskFormState withDueDate(DateTime? value) {
    return TaskFormState._(
      collection: collection,
      title: title,
      isDone: isDone,
      dueDate: value,
      initialTask: initialTask,
    );
  }

  TaskFormState withTask(Task value) {
    return TaskFormState._(
      collection: value.collection,
      title: TaskTitle.dirty(value.title),
      isDone: value.isDone,
      dueDate: value.dueDate,
      initialTask: value,
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
  ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [title];
}
