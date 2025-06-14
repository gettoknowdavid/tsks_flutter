import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/dtos/todos/collection_dto.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/utils/color_to_int_extension.dart';

part 'collection_form.g.dart';
part 'collection_form_state.dart';

@Riverpod(keepAlive: true)
class CollectionForm extends _$CollectionForm {
  @override
  CollectionFormState build() => CollectionFormState();

  void initializeWithCollection(Collection collection) {
    state = state.withCollection(collection);
  }

  void titleChanged(String title) => state = state.withTitle(title);

  void isFavouriteChanged(bool? value) => state = state.withIsFavourite(value);

  void colorChanged(Color? value) => state = state.withColor(value);

  void iconChanged(Map<String, dynamic> value) => state = state.withIcon(value);

  Future<void> submit() async {
    // Validate the form
    if (!state.isFormValid) return;

    // Check if the form is in edit mode
    final initialCollection = state.initialCollection;
    final isEditing = initialCollection != null;

    // If editing, but no changes were made, we can consider it a success
    // and avoid a pointless database write.
    if (isEditing && !state.hasChanges) {
      state = state.withSubmissionSuccess(unit);
      return;
    }

    state = state.withSubmissionInProgress();
    final repository = ref.read(collectionsRepositoryProvider);
    final Either<TsksException, Unit> response;

    if (isEditing) {
      final dataToUpdate = <String, dynamic>{};

      final initialDto = CollectionDto.fromDomain(initialCollection);
      final initialData = initialDto.toJson();
      final currentData = state.toJson();

      // Dynamically iterate and compare
      currentData.forEach((key, value) {
        // Compare each proper from the state with that from the
        // initial collection, and if a field matches, add that field to the
        // `dataToUpdate` map
        if (!const DeepCollectionEquality().equals(value, initialData[key])) {
          dataToUpdate[key] = value;
        }
      });

      response = await repository.updateCollection(
        uid: initialCollection.uid,
        data: dataToUpdate,
      );
    } else {
      response = await repository.createCollection(
        title: state.title,
        colorARGB: state.color?.toARGB32(),
        iconMap: state.iconMap,
        isFavourite: state.isFavourite,
        createdAt: state.createdAt,
      );
    }

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
