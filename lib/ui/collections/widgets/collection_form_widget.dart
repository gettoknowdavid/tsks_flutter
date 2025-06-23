import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';
import 'package:tsks_flutter/ui/collections/widgets/color_radio_button.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';
import 'package:tsks_flutter/utils/my_custom_icons.dart';

class CollectionFormWidget extends HookConsumerWidget {
  const CollectionFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.invalidate(collectionFormNotifierProvider);
      },
      child: Form(
        key: formKey,
        child: const SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              Row(
                spacing: 8,
                children: [
                  _IconPickerField(key: Key('collectionForm_iconField')),
                  Expanded(
                    child: _TitleField(key: Key('collectionForm_titleField')),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _ColorPickerField(key: Key('collectionForm_colorField')),
              SizedBox(height: 16),
              _IsFavouriteField(key: Key('collectionForm_isFavField')),
              SizedBox(height: 32),
              Row(
                spacing: 16,
                children: [
                  _SubmitButton(key: Key('collectionForm_submitButton')),
                  CancelButton(),
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
    );
  }
}

class _IsFavouriteField extends ConsumerWidget {
  const _IsFavouriteField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final notifier = ref.read(collectionFormNotifierProvider.notifier);
    return CheckboxListTile(
      tileColor: colors.surfaceContainer,
      value: ref.watch(collectionFormNotifierProvider).isFavourite,
      onChanged: notifier.isFavouriteChanged,
      title: const Text('Add to favourite'),
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
          final notifier = ref.read(collectionFormNotifierProvider.notifier);
          notifier.iconChanged(serializedIcon);
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

class _SubmitButton extends HookConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitPressed = useState<bool>(false);

    final notifier = ref.read(collectionsNotifierProvider.notifier);
    final state = ref.watch(collectionFormNotifierProvider);

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;

      FocusScope.of(context).unfocus();
      submitPressed.value = true;

      if (state.isEdit) {
        await notifier.updateColleciton(state.initialCollection!);
      } else {
        await notifier.createCollection();
      }

      ref.read(routerConfigProvider).pop();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: submitPressed.value || !state.hasChanges ? null : submit,
        child: Text(state.isEdit ? 'Update Collection' : 'Add Collection'),
      ),
    );
  }
}
