import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' hide Collection;
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/add_new_collection_button.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_tile.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PageWidget(
      title: 'Collections',
      content: CollectionsGridWidget(),
    );
  }
}

class CollectionsGridWidget extends ConsumerWidget {
  const CollectionsGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    return switch (collections) {
      AsyncError(:final error) => Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(error.toString()),
            const SizedBox(height: 20),
            const AddNewCollectionButton(),
          ],
        ),
      ),
      AsyncData(:final value) => CollectionsGrid(value),
      _ => CollectionsGrid(fakeCollections, isLoading: true),
    };
  }
}

class CollectionsGrid extends StatelessWidget {
  const CollectionsGrid(this.collections, {this.isLoading = false, super.key});
  final List<Collection?> collections;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox();
    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        primary: false,
        shrinkWrap: true,
        itemCount: collections.length + 1,
        itemBuilder: (_, i) {
          if (i < collections.length) {
            return CollectionTile(collection: collections[i]!);
          }
          return const AddNewCollectionButton();
        },
      ),
    );
  }
}
