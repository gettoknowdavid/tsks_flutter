import 'package:formz/formz.dart';

/// {@template task_title}
/// Form input for a task_title input.
/// {@endtemplate}
class TaskTitle extends FormzInput<String, TaskTitleError> {
  /// {@macro task_title}
  const TaskTitle.pure() : super.pure('');

  /// {@macro task_title}
  const TaskTitle.dirty([super.value = '']) : super.dirty();

  @override
  TaskTitleError? validator(String? value) {
    if (value == null || value.isEmpty) return TaskTitleError.empty;
    if (value.contains('\n')) return TaskTitleError.invalid;
    if (value.length > 500) return TaskTitleError.maxCharactersExceeded;
    return null;
  }
}

/// Validation errors for the [TaskTitle] [FormzInput].
enum TaskTitleError {
  /// Empty
  empty,

  /// Generic invalid error.
  invalid,

  /// Max characters
  maxCharactersExceeded,
}

extension TaskTitleErrorX on TaskTitleError {
  String get message => switch (this) {
    TaskTitleError.empty => 'Task title is required',
    TaskTitleError.invalid => 'Title must on a single line',
    TaskTitleError.maxCharactersExceeded => 'Max characters of 500',
  };
}
