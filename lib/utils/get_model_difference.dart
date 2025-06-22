import 'package:collection/collection.dart';

/// A typedef for a function that extracts a field's value from an object.
///
/// This allows `getModelDifference` to work generically with any object [T],
/// by providing a way to access the specific fields that need to be compared.
/// The function should return the value of the field for a given object [T].
typedef FieldGetter<T> = dynamic Function(T);

/// Computes the differences between two objects of the same type [T]
/// and returns a map containing only the fields that have changed.
///
/// This algorithm is designed to efficiently generate a "patch" or "delta"
/// representing the modifications from an [original] object to an [updated]
/// object.
/// It is particularly useful for scenarios like updating database documents
/// where only changed fields should be transmitted.
///
/// The comparison is performed based on a provided [fields] map, which
/// links field names (strings) to `FieldGetter` functions that can extract
/// the corresponding value from the object.
///
/// By default, field comparisons use standard Dart equality (`==`).
/// For fields that are collections (e.g., `List`, `Map`), and require
/// a deep comparison (checking elements/entries within the collection
/// rather than just object identity), their keys should be included
/// in the [deepCompare] set.
///
/// Example Usage:
/// ```dart
/// class MyModel {
///   final String name;
///   final int age;
///   final List<String> tags;
///
///   MyModel({required this.name, required this.age, required this.tags});
///
///   @override
///   bool operator ==(Object other) {
///     if (identical(this, other)) return true;
///     return other is MyModel &&
///            other.name == name &&
///            other.age == age &&
///            const DeepCollectionEquality().equals(other.tags, tags);
///   }
///
///   @override
///   int get hashCode =>
///       Object.hash(name, age, const DeepCollectionEquality().hash(tags));
/// }
///
/// // Define the fields to compare for MyModel
/// final myModelFields = {
///   'name': (MyModel m) => m.name,
///   'age': (MyModel m) => m.age,
///   'tags': (MyModel m) => m.tags,
/// };
///
/// final originalModel = MyModel(name: 'Alice', age: 30, tags: ['A', 'B']);
/// final updatedModel = MyModel(name: 'Alice', age: 31, tags: ['A', 'C']);
///
/// final differences = getModelDifference(
///   originalModel,
///   updatedModel,
///   myModelFields,
///   deepCompare: {'tags'}, // Specify 'tags' needs deep comparison
/// );
///
/// print(differences); // Output: {age: 31, tags: [A, C]}
/// ```
///
Map<String, dynamic> getModelDifference<T>(
  T original,
  T updated,
  Map<String, FieldGetter<T>> fields, {
  Set<String> deepCompare = const {},
}) {
  final changes = <String, dynamic>{};
  const eq = DeepCollectionEquality();

  for (final entry in fields.entries) {
    final key = entry.key;
    final oldVal = entry.value(original);
    final newVal = entry.value(updated);

    // Determine if deep comparison is required for the current field.
    final isEqual = deepCompare.contains(key)
        ? eq.equals(oldVal, newVal) // Deep comparison for collections
        : oldVal ==
              newVal; // Shallow comparison for primitives and other objects

    // If values are not equal, record the new value for this field.
    if (!isEqual) {
      changes[key] = newVal;
    }
  }

  return changes;
}
