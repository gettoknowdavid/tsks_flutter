part of 'todo_form_notifier.dart';

final class TodoFormState with EquatableMixin {
  TodoFormState()
    : this._(
        collectionUid: Uid(''),
        title: SingleLineString(''),
        createdAt: DateTime.now(),
      );

  const TodoFormState._({
    required this.collectionUid,
    required this.title,
    required this.createdAt,
    this.isDone = false,
    this.dueDate,
    this.status = TodoFormStatus.initial,
    this.initialTodo,
    this.newTodo,
    this.exception,
  });

  final Uid collectionUid;
  final SingleLineString title;
  final DateTime createdAt;
  final bool isDone;
  final DateTime? dueDate;
  final TodoFormStatus status;
  final Todo? initialTodo;
  final Todo? newTodo;
  final TsksException? exception;

  TodoFormState withCollectionUid(Uid collectionUid) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDate,
      initialTodo: initialTodo,
    );
  }

  TodoFormState withTitle(String title) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: SingleLineString(title),
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDate,
      initialTodo: initialTodo,
    );
  }

  TodoFormState withIsDone(bool? value) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: value ?? false,
      dueDate: dueDate,
      initialTodo: initialTodo,
    );
  }

  TodoFormState withDueDate(DateTime? dueDateValue) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDateValue,
      initialTodo: initialTodo,
    );
  }

  TodoFormState withTodo(Todo todo) {
    return TodoFormState._(
      collectionUid: todo.collectionUid,
      title: todo.title,
      createdAt: todo.createdAt,
      isDone: todo.isDone,
      dueDate: todo.dueDate,
      initialTodo: todo,
    );
  }

  TodoFormState withSubmissionProgress() {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDate,
      initialTodo: initialTodo,
      status: TodoFormStatus.loading,
    );
  }

  TodoFormState withSubmissionFailure(TsksException exception) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDate,
      initialTodo: initialTodo,
      status: TodoFormStatus.failure,
      exception: exception,
    );
  }

  TodoFormState withSubmissionSuccess(Todo todo) {
    return TodoFormState._(
      collectionUid: collectionUid,
      title: title,
      createdAt: createdAt,
      isDone: isDone,
      dueDate: dueDate,
      initialTodo: initialTodo,
      status: TodoFormStatus.success,
      newTodo: newTodo,
    );
  }

  bool get isFormValid => collectionUid.isValid && title.isValid;

  bool get isEditing => initialTodo != null;

  bool get hasChanges {
    return initialTodo?.collectionUid != collectionUid ||
        initialTodo?.title != title ||
        initialTodo?.isDone != isDone ||
        initialTodo?.dueDate != dueDate;
  }

  Map<String, dynamic> toJson() {
    return {
      'collectionUid': collectionUid.getOrCrash,
      'title': title.getOrCrash,
      'isDone': isDone,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    collectionUid,
    title,
    createdAt,
    isDone,
    dueDate,
    status,
    initialTodo,
    newTodo,
    exception,
  ];
}

enum TodoFormStatus { initial, loading, success, failure }

extension TodoFormStatusX on TodoFormStatus {
  bool get isInitial => this == TodoFormStatus.initial;

  bool get isLoading => this == TodoFormStatus.loading;

  bool get isSuccess => this == TodoFormStatus.success;

  bool get isFailure => this == TodoFormStatus.failure;
}
