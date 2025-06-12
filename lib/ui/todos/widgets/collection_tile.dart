import 'package:flutter/material.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_icon_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_tasks_status_widget.dart';

class CollectionTile extends StatelessWidget {
  const CollectionTile({required this.collection, super.key});
  final Collection collection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const borderRadius = BorderRadius.all(Radius.circular(28));

    return InkWell(
      onTap: () {},
      // onTap: () => context.push('/collections/${collection.uid}'),
      borderRadius: borderRadius,
      child: Card(
        margin: EdgeInsets.zero,
        color: theme.colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(borderRadius: borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollectionIconWidget(collection: collection),
              const Spacer(),
              Text(
                collection.title.getOrCrash,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              CollectionTasksStatusWidget(collection: collection),
            ],
          ),
        ),
      ),
    );
  }
}
