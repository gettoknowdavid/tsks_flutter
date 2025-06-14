import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_icon_widget.dart';
import 'package:tsks_flutter/ui/todos/widgets/collection_tasks_status_widget.dart';

class CollectionTile extends ConsumerWidget {
  const CollectionTile({required this.collection, super.key});

  final Collection collection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return InkWell(
      onTap: () {
        CollectionRoute(collection.uid.getOrCrash).push<void>(context);
      },
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
          padding: ResponsiveValue<EdgeInsets>(
            context,
            conditionalValues: [
              const Condition.largerThan(
                name: PHONE,
                value: EdgeInsets.all(20),
              ),
            ],
            defaultValue: const EdgeInsets.all(14),
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CollectionIconWidget(
                collection: collection,
                size: ResponsiveValue<double>(
                  context,
                  conditionalValues: [
                    const Condition.largerThan(name: PHONE, value: 44),
                  ],
                  defaultValue: 34,
                ).value,
              ),
              const Spacer(),
              Text(
                collection.title.getOrCrash,
                style: ResponsiveValue<TextStyle>(
                  context,
                  conditionalValues: [
                    Condition.smallerThan(
                      name: MOBILE,
                      value: textTheme.titleSmall,
                    ),
                    Condition.largerThan(
                      name: TABLET,
                      value: textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                  ],
                  defaultValue: textTheme.titleMedium,
                ).value,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                semanticsLabel: collection.title.getOrCrash,
              ),
              ResponsiveValue<Widget>(
                context,
                conditionalValues: [
                  const Condition.largerThan(
                    name: PHONE,
                    value: SizedBox(height: 8),
                  ),
                ],
                defaultValue: const SizedBox.shrink(),
              ).value,
              CollectionTasksStatusWidget(collection: collection),
            ],
          ),
        ),
      ),
    );
  }
}
