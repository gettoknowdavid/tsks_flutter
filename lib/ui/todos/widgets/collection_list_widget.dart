import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';

class CollectionListWidget extends ConsumerWidget {
  const CollectionListWidget({this.onCollectionSelected, super.key});

  final void Function(Uid?)? onCollectionSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(allCollectionsProvider);

    return switch (collections) {
      AsyncLoading() => _List(fakeCollections, isLoading: true),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      AsyncData(:final value) => _List(
        value,
        onCollectionSelected: onCollectionSelected,
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _List extends StatelessWidget {
  const _List(
    this.collections, {
    this.isLoading = false,
    this.onCollectionSelected,
  });

  final List<Collection?> collections;
  final bool isLoading;
  final void Function(Uid?)? onCollectionSelected;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox.shrink();

    return ListView.separated(
      shrinkWrap: true,
      itemCount: collections.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) => ListTile(
        title: Text(collections[index]!.title.getOrCrash),
        onTap: () => onCollectionSelected?.call(collections[index]?.uid),
      ),
    );
  }
}
