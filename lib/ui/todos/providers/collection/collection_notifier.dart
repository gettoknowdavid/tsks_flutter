import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

part 'collection_notifier.g.dart';
part 'collection_state.dart';

@Riverpod(keepAlive: true)
class CollectionNotifier extends _$CollectionNotifier {
  @override
  CollectionState build() => CollectionState();

  Future<void> fetch(Collection collection) async {
    state = state.withInitialize(collection);
  }
}
