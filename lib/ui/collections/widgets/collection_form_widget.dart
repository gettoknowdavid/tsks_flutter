import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/ui/collections/providers/all_collections.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_notifier.dart';
import 'package:tsks_flutter/ui/collections/widgets/color_radio_button.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';
import 'package:tsks_flutter/utils/my_custom_icons.dart';

class CollectionFormWidget extends HookConsumerWidget {
  const CollectionFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final status = ref.watch(
      collectionFormNotifierProvider.select((s) => s.status),
    );

    ref.listen(collectionFormNotifierProvider, (previous, next) {
      if (previous?.status == next.status) return;

      if (next.status.isFailure) {
        context.showErrorSnackBar(next.exception?.message);
      }

      if (next.status.isSuccess) {
        final newOrUpdatedCollection = next.newCollection;
        if (newOrUpdatedCollection != null) {
          // Optimistically update the current collection
          final id = newOrUpdatedCollection.id;
          final notifier = ref.read(collectionNotifierProvider(id).notifier);
          notifier.optimisticallyUpdate(newOrUpdatedCollection);

          // Optimistically update the collections list
          final colsNotifier = ref.read(allCollectionsProvider.notifier);
          colsNotifier.optimisticallyUpdate(newOrUpdatedCollection);
        }
        Navigator.pop(context);
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.invalidate(collectionFormNotifierProvider);
      },
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              const Row(
                spacing: 8,
                children: [
                  _IconPickerField(key: Key('collectionForm_iconField')),
                  Expanded(
                    child: _TitleField(key: Key('collectionForm_titleField')),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _ColorPickerField(key: Key('collectionForm_colorField')),
              const SizedBox(height: 16),
              const _IsFavouriteField(key: Key('collectionForm_isFavField')),
              const SizedBox(height: 32),
              Row(
                spacing: 16,
                children: [
                  const _SubmitButton(key: Key('collectionForm_submitButton')),
                  CancelButton(enabled: !status.isInProgress),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends HookConsumerWidget {
  const _TitleField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final focusNode = useFocusNode();
    final title = ref.watch(
      collectionFormNotifierProvider.select((s) => s.title),
    );
    final isInProgress = ref.watch(
      collectionFormNotifierProvider.select((s) => s.status.isInProgress),
    );
    return TextFormField(
      focusNode: focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Collection title',
        fillColor: colors.surfaceContainer,
        filled: true,
      ),
      initialValue: title.value,
      onChanged: ref.read(collectionFormNotifierProvider.notifier).titleChanged,
      validator: (value) => title.error?.message,
      enabled: !isInProgress,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          await ref.read(collectionFormNotifierProvider.notifier).submit();
        }
      },
    );
  }
}

class _IsFavouriteField extends ConsumerWidget {
  const _IsFavouriteField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final status = ref.watch(
      collectionFormNotifierProvider.select((s) => s.status),
    );
    return CheckboxListTile(
      tileColor: colors.surfaceContainer,
      value: ref.watch(collectionFormNotifierProvider).isFavourite,
      onChanged: ref
          .read(collectionFormNotifierProvider.notifier)
          .isFavouriteChanged,
      title: const Text('Add to favourite'),
      enabled: !status.isInProgress,
      contentPadding: const EdgeInsets.fromLTRB(24, 5, 16, 5),
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
      ),
    );
  }
}

class _ColorPickerField extends ConsumerWidget {
  const _ColorPickerField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('Pick a color', style: theme.textTheme.bodySmall),
          ),
          const SizedBox(height: 12),
          LimitedBox(
            maxHeight: 32,
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: collectionColors.length,
              itemBuilder: (_, i) => ColorRadioButton(collectionColors[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconPickerField extends ConsumerWidget {
  const _IconPickerField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final iconMap = ref.watch(
      collectionFormNotifierProvider.select((s) => s.iconMap),
    );
    final deserializedIcon = iconMap != null ? deserializeIcon(iconMap) : null;
    return SizedBox.square(
      dimension: 56,
      child: IconButton.filled(
        icon: deserializedIcon != null
            ? Icon(deserializedIcon.data)
            : const Icon(PhosphorIconsBold.snowflake),
        onPressed: () async {
          final selectedIcon = await showIconPicker(
            context,
            configuration: SinglePickerConfiguration(
              constraints: const BoxConstraints(
                maxWidth: 560,
                minWidth: 420,
                minHeight: 420,
                maxHeight: 600,
              ),
              backgroundColor: colors.surfaceContainer,
              preSelected: deserializedIcon,
              showTooltips: true,
              adaptiveDialog: true,
              iconPackModes: <IconPack>[IconPack.custom],
              customIconPack: myCustomIcons,
              searchComparator: _searchComparator,
              iconSize: 32,
            ),
          );
          if (selectedIcon == null) return;
          final serializedIcon = serializeIcon(selectedIcon)!;
          ref
              .read(collectionFormNotifierProvider.notifier)
              .iconChanged(serializedIcon);
        },
        style: IconButton.styleFrom(
          backgroundColor: colors.surfaceContainer,
          foregroundColor: colors.onSurface,
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
        tooltip: 'Pick a collection icon',
      ),
    );
  }

  bool _searchComparator(String search, IconPickerIcon icon) {
    return search.toLowerCase().contains(
          icon.name.replaceAll('_', ' ').toLowerCase(),
        ) ||
        icon.name.toLowerCase().contains(search.toLowerCase());
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInProgress = ref.watch(
      collectionFormNotifierProvider.select((s) => s.status.isInProgress),
    );

    // Whether the form is in editing mode i.e. editing an existing collection
    final isEditing = ref.watch(
      collectionFormNotifierProvider.select((s) => s.isEditing),
    );

    // Whether the form state during when editing a collection has any changes
    final hasChanges = ref.watch(
      collectionFormNotifierProvider.select((s) => s.hasChanges),
    );

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;
      await ref.watch(collectionFormNotifierProvider.notifier).submit();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: isInProgress || !hasChanges ? null : submit,
        child: isInProgress
            ? const Text('Submitting...')
            : Text(isEditing ? 'Update Collection' : 'Add Collection'),
      ),
    );
  }
}
