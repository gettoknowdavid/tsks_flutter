import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/core/value_objects/value_objects.dart';

part 'collection_form.g.dart';
part 'collection_form_state.dart';

@riverpod
class CollectionForm extends _$CollectionForm {
  @override
  CollectionFormState build() => CollectionFormState();

  void titleChanged(String title) => state = state.withTitle(title);

  void isFavouriteChanged(bool? value) => state = state.withIsFavourite(value);

  void colorChanged(Color? value) => state = state.withColor(value);

  void iconChanged(Map<String, dynamic> value) => state = state.withIcon(value);

  Future<void> submit() async {
    if (!state.isFormValid) return;
    state = state.withSubmissionInProgress();
    final repository = ref.read(collectionsRepositoryProvider);
    final response = await repository.createCollection(
      title: state.title,
      colorARGB: state.color?.toARGB32(),
      iconMap: state.iconMap,
      isFavourite: state.isFavourite,
      createdAt: state.createdAt,
    );
    state = response.fold(
      state.withSubmissionFailure,
      state.withSubmissionSuccess,
    );
  }
}
