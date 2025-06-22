part of 'task_form_notifier.dart';

final class TaskFormState with FormzMixin, EquatableMixin {
  const TaskFormState() : this._(collectionId: '');

  const TaskFormState._({
    required this.collectionId,
    this.title = const TaskTitle.pure(),
    this.isDone = false,
    this.dueDate,
    this.status = Status.initial,
    this.initialTask,
    this.newTask,
    this.parentTask,
    this.exception,
  });

  final String collectionId;
  final TaskTitle title;
  final bool isDone;
  final DateTime? dueDate;
  final Status status;
  final Task? initialTask;
  final Task? newTask;
  final Task? parentTask;
  final TsksException? exception;

  TaskFormState withCollectionId(String value) {
    return TaskFormState._(
      collectionId: value,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withParentTask(Task value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: value,
    );
  }

  TaskFormState withTitle(String value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: TaskTitle.dirty(value),
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withIsDone(bool? value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: value ?? false,
      dueDate: dueDate,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withDueDate(DateTime? value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: isDone,
      dueDate: value,
      initialTask: initialTask,
      parentTask: parentTask,
    );
  }

  TaskFormState withTask(Task value) {
    return TaskFormState._(
      collectionId: value.collection,
      title: TaskTitle.dirty(value.title),
      isDone: value.isDone,
      dueDate: value.dueDate,
      initialTask: value,
      parentTask: parentTask,
    );
  }

  TaskFormState withSubmissionInProgress() {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      status: Status.inProgress,
      parentTask: parentTask,
    );
  }

  TaskFormState withSubmissionFailure(TsksException value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      status: Status.failure,
      parentTask: parentTask,
      exception: value,
    );
  }

  TaskFormState withSubmissionSuccess(Task value) {
    return TaskFormState._(
      collectionId: collectionId,
      title: title,
      isDone: isDone,
      dueDate: dueDate,
      initialTask: initialTask,
      status: Status.success,
      newTask: value,
      parentTask: parentTask,
    );
  }

  bool get isEditing => initialTask != null;

  bool get hasChanges {
    return initialTask?.collection != collectionId ||
        initialTask?.title != title.value ||
        initialTask?.isDone != isDone ||
        initialTask?.dueDate != dueDate;
  }

  @override
  List<Object?> get props => [
    collectionId,
    title,
    isDone,
    dueDate,
    status,
    initialTask,
    newTask,
    exception,
  ];

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [title];
}
