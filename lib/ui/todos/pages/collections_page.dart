import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/constants/fake_models.dart';
import 'package:tsks_flutter/domain/core/exceptions/tsks_exception.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' hide Collection;
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/add_new_collection_button.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_category_selector_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_tile.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCollectionsAsync = ref.watch(allCollectionsProvider);
    final filteredCollections = ref.watch(filteredCollectionsProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref.refresh(allCollectionsProvider.future),
      child: PageWidget(
        title: 'Collections',
        content: switch (allCollectionsAsync) {
          AsyncError(:final error) => _ErrorWidget(error),
          AsyncData() => _CollectionsPageView(filteredCollections),
          _ => _CollectionsPageView(fakeCollections, isLoading: true),
        },
      ),
    );
  }
}

class _CollectionsPageView extends ConsumerWidget {
  const _CollectionsPageView(this.collections, {this.isLoading = false});
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

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget(this.exception);
  final Object exception;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          if (exception is TsksException)
            Text((exception as TsksException).message)
          else
            Text(exception.toString()),
          const SizedBox(height: 20),
          const AddNewCollectionButton(),
        ],
      ),
    );
  }
}
