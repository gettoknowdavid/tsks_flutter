import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';
import 'package:tsks_flutter/ui/todos/providers/collection_form/collection_form.dart';

class CollectionEditorDialog extends HookConsumerWidget {
  const CollectionEditorDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return MaxWidthBox(
      maxWidth: 560,
      child: Dialog(
        alignment: Alignment.topCenter,
        insetPadding: const EdgeInsets.fromLTRB(40, 160, 40, 0),
        shape: RoundedSuperellipseBorder(
          borderRadius: const BorderRadiusGeometry.all(Radius.circular(16)),
          side: BorderSide(
            width: 2,
            color: theme.colorScheme.secondaryContainer,
          ),
        ),
        child: Form(
          key: formKey,
          child: const SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              children: [
                _TitleField(key: Key('collectionForm_titleField')),
                SizedBox(height: 16),
                _IsFavouriteField(key: Key('collectionForm_isFavouriteField')),
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
      ),
    );
  }
}

class _TitleField extends HookConsumerWidget {
  const _TitleField({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(collectionFormProvider.select((s) => s.title));
    final status = ref.watch(collectionFormProvider.select((s) => s.status));
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Collection title'),
      onChanged: ref.read(collectionFormProvider.notifier).titleChanged,
      validator: (value) => title.failureOrNull?.message,
      enabled: !status.isLoading,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(collectionFormProvider.notifier).submit();
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
    final status = ref.watch(collectionFormProvider.select((s) => s.status));
    return CheckboxListTile(
      tileColor: colors.surfaceContainer,
      value: ref.watch(collectionFormProvider).isFavourite,
      onChanged: ref.read(collectionFormProvider.notifier).isFavouriteChanged,
      title: const Text('Add to favourite'),
      enabled: !status.isLoading,
      contentPadding: const EdgeInsets.fromLTRB(24, 5, 16, 5),
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(collectionFormProvider.select((s) => s.status));
    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: () {
          if (!Form.of(context).validate()) return;
          ref.watch(collectionFormProvider.notifier).submit();
        },
        child: status.isLoading
            ? const TinyLoadingIndicator()
            : const Text('Add Collection'),
      ),
    );
  }
}
