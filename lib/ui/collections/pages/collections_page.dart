import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';
import 'package:tsks_flutter/ui/collections/providers/filtered_collections.dart';
import 'package:tsks_flutter/ui/collections/widgets/add_new_collection_button.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_category_selector_widget.dart';
import 'package:tsks_flutter/ui/collections/widgets/collection_tile.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_error_widget.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' hide Collection;

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(collectionsNotifierProvider);
    final filteredAsync = ref.watch(filteredCollectionsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(collectionsNotifierProvider.future),
      child: PageWidget(
        title: 'Collections',
        content: collectionsAsync.when(
          loading: () => _PageView(fakeCollections, isLoading: true),
          error: (error, _) => TsksErrorWidget(error),
          data: (value) => switch (filteredAsync.filter) {
            CollectionFilter.all => _PageView(filteredAsync.collections),
            CollectionFilter.favourites => _PageView(filteredAsync.collections),
          },
        ),
      ),
    );
  }
}

class _PageView extends ConsumerWidget {
  const _PageView(this.collections, {this.isLoading = false});

  final List<Collection?> collections;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Skeletonizer(
      enabled: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveValue<Widget>(
            context,
            conditionalValues: [
              const Condition.largerThan(
                name: MOBILE,
                value: SizedBox(height: 50),
              ),
            ],
            defaultValue: const SizedBox.shrink(),
          ).value,
          const CollectionCategorySelectorWidget(),
          const SizedBox(height: 10),
          _Grid(collections, key: const Key('CollectionGrid')),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid(this.collections, {super.key});

  final List<Collection?> collections;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveValue<int>(
          context,
          conditionalValues: [
            const Condition.largerThan(name: TABLET, value: 3),
            const Condition.largerThan(name: DESKTOP, value: 4),
          ],
          defaultValue: 2,
        ).value,
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
    );
  }
}
