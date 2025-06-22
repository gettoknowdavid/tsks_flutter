import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_filter_notifier.dart';

class CollectionCategorySelectorWidget extends StatelessWidget {
  const CollectionCategorySelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: CollectionFilter.values.map(_FilterButton.new).toList(),
    );
  }
}

class _FilterButton extends ConsumerWidget {
  const _FilterButton(this.filter);
  final CollectionFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(collectionFilterNotifierProvider.notifier);
    final isSelected = ref.watch(collectionFilterNotifierProvider) == filter;

    return Skeleton.shade(
      child: OutlinedButton(
        onPressed: isSelected ? () {} : () => notifier.updateFilter(filter),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
          side: BorderSide(
            width: isSelected ? 0 : 1.5,
            color: isSelected
                ? colors.secondaryContainer
                : colors.outlineVariant,
          ),
          foregroundColor: colors.onSurface,
          backgroundColor: isSelected ? colors.secondaryContainer : null,
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(16)),
          ),
        ),
        child: Text(filter.name),
      ),
    );
  }
}
