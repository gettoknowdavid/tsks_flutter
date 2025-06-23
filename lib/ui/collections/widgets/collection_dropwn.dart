import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';

class CollectionDropdown extends ConsumerWidget {
  const CollectionDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsNotifierProvider);

    return switch (collections) {
      AsyncData(:final value) => _List(value),
      AsyncLoading() => _List(fakeCollections, isLoading: true),
      AsyncError(:final error) => Center(child: Text(error.toString())),
      _ => const SizedBox.shrink(),
    };
  }
}

class _List extends StatelessWidget {
  const _List(this.collections, {this.isLoading = false});

  final List<Collection?> collections;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox.shrink();
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: const EdgeInsets.all(12),
        shrinkWrap: true,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemCount: collections.length,
        itemBuilder: (context, index) {
          final collection = collections[index]!;
          return ListTile(
            key: ValueKey(collection),
            title: Text(collection.title),
            onTap: () => Navigator.pop<Collection?>(context, collection),
          );
        },
      ),
    );
  }
}
