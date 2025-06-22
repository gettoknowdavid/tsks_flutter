import 'package:formz/formz.dart';

/// {@template collection_title}
/// Form input for a collection_title input.
/// {@endtemplate}
class CollectionTitle extends FormzInput<String, CollectionTitleError> {
  /// {@macro collection_title}
  const CollectionTitle.pure() : super.pure('');

  /// {@macro collection_title}
  const CollectionTitle.dirty([super.value = '']) : super.dirty();

  @override
  CollectionTitleError? validator(String? value) {
    if (value == null || value.isEmpty) return CollectionTitleError.empty;
    if (value.contains('\n')) return CollectionTitleError.invalid;
    if (value.length > 100) return CollectionTitleError.maxCharactersExceeded;
    return null;
  }
}

/// Validation errors for the [CollectionTitle] [FormzInput].
enum CollectionTitleError {
  /// Empty
  empty,

  /// Generic invalid error.
  invalid,

  /// Max characters
  maxCharactersExceeded,
}

extension CollectionTitleErrorX on CollectionTitleError {
  String get message => switch (this) {
    CollectionTitleError.empty => 'Collection title is required',
    CollectionTitleError.invalid => 'Title must on a single line',
    CollectionTitleError.maxCharactersExceeded => 'Max characters of 100',
  };
}
