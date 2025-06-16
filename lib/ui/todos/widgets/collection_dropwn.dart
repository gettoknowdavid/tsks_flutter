import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/core/exceptions/exceptions.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';

class CollectionDropdown extends ConsumerWidget {
  const CollectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(allCollectionsProvider);

    return switch (collections) {
      AsyncData(:final value) => CollectionDropdownList(value),
      AsyncLoading() => CollectionDropdownList(
        fakeCollections,
        isLoading: true,
      ),
      AsyncError(:final error) => Center(
        child: Text((error as TsksException).message),
      ),
      _ => const SizedBox.shrink(),
    };
  }
}

class CollectionDropdownList extends StatelessWidget {
  const CollectionDropdownList(
    this.collections, {
    this.isLoading = false,
    super.key,
  });

  final List<Collection?> collections;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox.shrink();
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final collection = collections[index]!;
          return ListTile(
            key: ValueKey(collection),
            title: Text(collection.title.getOrCrash),
            onTap: () => Navigator.pop<Collection?>(context, collection),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: collections.length,
        shrinkWrap: true,
      ),
    );
  }
}
