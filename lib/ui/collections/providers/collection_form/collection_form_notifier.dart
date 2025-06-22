import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/data/repositories/collections/collections_repository.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/utils/color_to_int_extension.dart';

part 'collection_form_notifier.g.dart';
part 'collection_form_state.dart';

@Riverpod(keepAlive: true)
class CollectionFormNotifier extends _$CollectionFormNotifier {
  @override
  CollectionFormState build() => const CollectionFormState();

  void initializeWithCollection(Collection collection) {
    state = state.withCollection(collection);
  }

  void titleChanged(String title) => state = state.withTitle(title);

  void isFavouriteChanged(bool? value) => state = state.withIsFavourite(value);

  void colorChanged(Color? value) => state = state.withColor(value);

  void iconChanged(Map<String, dynamic> value) => state = state.withIcon(value);

  Future<void> submit() async {
    if (state.isNotValid) return;

    // Check if the form is in edit mode
    final initialCollection = state.initialCollection;
    final isEditing = initialCollection != null;

    // If editing, but no changes were made, we can consider it a success
    // and avoid a pointless database write.
    if (isEditing && !state.hasChanges) return;

    state = state.withSubmissionInProgress();

    final repository = ref.read(collectionsRepositoryProvider);
    final Either<TsksException, Collection> response;

    if (isEditing) {
      response = await repository.updateCollection(
        originalCollection: initialCollection,
        updatedCollection: initialCollection.copyWith(
          title: state.title.value,
          isFavourite: state.isFavourite,
          colorARGB: state.color?.toARGB32(),
          iconMap: state.iconMap,
        ),
      );
    } else {
      response = await repository.createCollection(
        title: state.title.value,
        colorARGB: state.color?.toARGB32(),
        iconMap: state.iconMap,
        isFavourite: state.isFavourite,
      );
    }

    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
