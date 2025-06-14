import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';
import 'package:tsks_flutter/ui/todos/providers/collection/collection_notifier.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(
      collectionNotifierProvider.select((s) => s.collection),
    );

    return PageWidget(
      title: collection.title.getOrCrash,
      showBackButton: true,
      onBackPressed: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          const CollectionsRoute().push<void>(context);
        }
      },
      action: PopupMenuButton<String>(
        child: const Icon(PhosphorIconsBold.dotsThree),
        onSelected: (String value) {
          // Handle your action on selection here
        },
        itemBuilder: (BuildContext context) {
          final choices = <String>[];
          // Logic to modify choices based on app state or user actions
          choices.add('Dynamic Option 1');
          choices.add('Dynamic Option 2');
          // Return menu items based on modified choices
          return choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      ),
    );
  }
}
