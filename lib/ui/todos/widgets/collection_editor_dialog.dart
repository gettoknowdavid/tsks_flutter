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

    final status = ref.watch(collectionFormProvider.select((s) => s.status));

    ref.listen(collectionFormProvider, (previous, next) {
      if (previous?.status == next.status) return;
      switch (next.status) {
        case CollectionFormStatus.initial:
        case CollectionFormStatus.loading:
          return;
        case CollectionFormStatus.failure:
          context.showErrorSnackBar(next.exception?.message);
        case CollectionFormStatus.success:
          Navigator.pop(context);
      }
    });

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              children: [
                const _TitleField(key: Key('collectionForm_titleField')),
                const SizedBox(height: 16),
                const _IsFavouriteField(
                  key: Key('collectionForm_isFavouriteField'),
                ),
                const SizedBox(height: 32),
                Row(
                  spacing: 16,
                  children: [
                    const _SubmitButton(
                      key: Key('collectionForm_submitButton'),
                    ),
                    CancelButton(enabled: !status.isLoading),
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

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;
      await ref.watch(collectionFormProvider.notifier).submit();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: status.isLoading ? null : submit,
        child: status.isLoading
            ? const Text('Submitting...')
            : const Text('Add Collection'),
      ),
    );
  }
}
