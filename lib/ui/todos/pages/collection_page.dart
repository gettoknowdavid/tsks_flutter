import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_form/collection_form.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_notifier.dart';
import 'package:tsks_flutter/ui/todos/widgets/add_new_collection_button.dart';

class CollectionPage extends ConsumerWidget {
  const CollectionPage({required this.uid, super.key});

  final Uid uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return Scaffold(
      appBar: isMobile ? const _AppBar(key: Key('CollectionPageAppBar')) : null,
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MaxWidthBox(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          maxWidth: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.largerThan(name: MOBILE, value: 720),
              const Condition.largerThan(name: DESKTOP, value: 1000),
            ],
            defaultValue: double.infinity,
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              if (!isMobile) ...[
                const Row(
                  children: [
                    PageBackButton(),
                    SizedBox(width: 16),
                    Expanded(child: _Title(key: Key('CollectionPageTitle'))),
                    _MoreOptions(key: Key('CollectionPopupOptionsMenu')),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends ConsumerWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uidStr = ref.read(routerConfigProvider).state.pathParameters['uid'];
    final uid = Uid(uidStr ?? '');
    final collection = ref.watch(collectionNotifierProvider(uid));

    return switch (collection) {
      AsyncError() => const PageTitle('An error occurred'),
      AsyncData(:final value) => PageTitle(value.title.getOrCrash),
      _ => const Skeletonizer(child: PageTitle('Fake Title')),
    };
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: const PageBackButton(),
      title: const _Title(key: Key('CollectionPageTitle')),
      titleSpacing: 0,
      centerTitle: false,
      actions: const [_MoreOptions()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MoreOptions extends ConsumerWidget {
  const _MoreOptions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uidStr = ref.read(routerConfigProvider).state.pathParameters['uid'];
    final uid = Uid(uidStr ?? '');
    final collection = ref.watch(collectionNotifierProvider(uid)).valueOrNull;
    return PopupMenuButton<String>(
      child: const Icon(PhosphorIconsBold.dotsThree),
      onSelected: (String value) async {
        if (collection == null) return;
        if (value == 'Edit') {
          final notifier = ref.read(collectionFormProvider.notifier);
          notifier.initializeWithCollection(collection);
          context.openCollectionEditor();
        } else if (value == 'Delete') {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Collection?'),
              content: const Text(
                '''You are about to delete this collection. This aaction cannot be undone. Do you want to continue?''',
              ),
              actions: [
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );

          if (shouldDelete ?? false) {
            final uid = collection.uid;
            final notifier = ref.read(collectionNotifierProvider(uid).notifier);
            await notifier.deleteCollection();
            if (context.mounted) {
              await const CollectionsRoute().push<void>(context);
            } else {
              final location = const CollectionsRoute().location;
              await ref.read(routerConfigProvider).push<void>(location);
            }
          }
        }
      },
      itemBuilder: (BuildContext context) {
        return ['Edit', 'Delete'].map((String choice) {
          return PopupMenuItem<String>(value: choice, child: Text(choice));
        }).toList();
      },
    );
  }
}
