import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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
}
