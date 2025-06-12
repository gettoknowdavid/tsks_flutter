import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/todos/collections_repository.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';

part 'collections_provider.g.dart';

@riverpod
FutureOr<List<Collection?>> collections(Ref ref) async {
  final repository = ref.read(collectionsRepositoryProvider);
  final response = await repository.getCollections();
  return response.fold(
    (exception) => throw exception,
    (collections) => collections,
  );
}
