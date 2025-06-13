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

    return InkWell(
      onTap: () {},
      // onTap: () => context.push('/collections/${collection.uid}'),
      borderRadius: const BorderRadius.all(Radius.circular(28)),
      child: Card(
        semanticContainer: false,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadiusGeometry.all(Radius.circular(28)),
          side: BorderSide(
            width: 2,
            color: theme.colorScheme.surfaceContainer,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollectionIconWidget(collection: collection),
              const Spacer(),
              Text(
                collection.title.getOrCrash,
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 20),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                semanticsLabel: collection.title.getOrCrash,
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
