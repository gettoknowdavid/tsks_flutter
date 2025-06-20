import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/todos/collection.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/cancel_button.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_snackbar.dart';
import 'package:tsks_flutter/ui/todos/providers/collections/collections_provider.dart';
import 'package:tsks_flutter/ui/todos/providers/todo_form/todo_form_notifier.dart';
import 'package:tsks_flutter/ui/todos/providers/todos_provider.dart';
import 'package:tsks_flutter/ui/todos/widgets/date_form_field.dart';

class TodoFormWidget extends HookConsumerWidget {
  const TodoFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final status = ref.watch(todoFormProvider.select((s) => s.status));

    ref.listen(todoFormProvider, (previous, next) {
      if (previous?.status == next.status) return;
      switch (next.status) {
        case TodoFormStatus.initial:
        case TodoFormStatus.loading:
          return;
        case TodoFormStatus.failure:
          context.showErrorSnackBar(next.exception?.message);
          return;
        case TodoFormStatus.success:
          final newOrUpdatedTodo = next.newTodo;
          if (newOrUpdatedTodo != null) {
            // Optimistically update the collections list
            final collectionUid = newOrUpdatedTodo.collectionUid;
            final notifier = ref.read(todosProvider(collectionUid).notifier);
            notifier.optimisticallyUpdate(newOrUpdatedTodo);
          }
          Navigator.pop(context);
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.invalidate(todoFormProvider);
      },
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              const _TitleField(key: Key('todoForm_titleField')),
              const SizedBox(height: 24),
              const Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CollectionField(key: Key('todoForm_collectionField')),
                  Expanded(
                    child: _DateField(key: Key('todoForm_collectionDueDate')),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                spacing: 16,
                children: [
                  const _SubmitButton(key: Key('todoForm_submitButton')),
                  CancelButton(enabled: !status.isLoading),
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
    final title = ref.watch(todoFormProvider.select((s) => s.title));
    final status = ref.watch(todoFormProvider.select((s) => s.status));
    return TextFormField(
      focusNode: focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Todo title',
        fillColor: colors.surfaceContainer,
        filled: true,
      ),
      initialValue: title.getOrNull,
      onChanged: ref.read(todoFormProvider.notifier).titleChanged,
      validator: (value) => title.failureOrNull?.message,
      enabled: !status.isLoading,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          await ref.read(todoFormProvider.notifier).submit();
        }
      },
    );
  }
}

class _CollectionField extends HookConsumerWidget {
  const _CollectionField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(allCollectionsProvider);

    final collectionUidFromPath = ref
        .watch(routerConfigProvider)
        .state
        .pathParameters['uid'];

    final pathUid = collectionUidFromPath != null
        ? Uid(collectionUidFromPath)
        : null;

    final colUid = ref.watch(todoFormProvider.select((s) => s.collectionUid));
    final selectedCollectionUid = colUid.isValid ? colUid : null;

    final status = ref.watch(todoFormProvider.select((s) => s.status));

    return CollectionDropdownWidget(
      items: _items(collections),
      value: selectedCollectionUid,
      onChanged: ref.read(todoFormProvider.notifier).collectionChanged,
      enabled: pathUid == null && !status.isLoading,
      validator: (_) => colUid.value.fold(
        (_) => 'Collection required',
        (_) => null,
      ),
    );
  }

  List<DropdownMenuItem<Uid?>> _items(
    AsyncValue<List<Collection?>> collections,
  ) {
    switch (collections) {
      case AsyncData(:final value):
        if (value.isEmpty) return [];
        return value.map((collection) {
          return DropdownMenuItem<Uid>(
            value: collection!.uid,
            child: Text(collection.title.getOrCrash),
          );
        }).toList();
      default:
        return [];
    }
  }
}

class CollectionDropdownWidget extends StatelessWidget {
  const CollectionDropdownWidget({
    required this.value,
    required this.items,
    super.key,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final Uid? value;
  final List<DropdownMenuItem<Uid?>> items;
  final void Function(Uid?)? onChanged;
  final String? Function(Uid?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<Uid?>(
        value: value,
        decoration: InputDecoration(
          hintText: 'Pick a Collection',
          constraints: const BoxConstraints(maxWidth: 190),
          contentPadding: const EdgeInsetsGeometry.fromLTRB(22, 18, 22, 18),
          enabled: enabled,
        ),
        iconSize: 14,
        icon: const Icon(PhosphorIconsBold.caretDown),
        style: Theme.of(context).textTheme.labelLarge,
        onChanged: !enabled ? null : onChanged,
        items: items,
        validator: validator,
      ),
    );
  }
}

class _DateField extends HookConsumerWidget {
  const _DateField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(todoFormProvider.notifier);
    final status = ref.watch(todoFormProvider.select((s) => s.status));
    return DateFormField(
      onChanged: notifier.dueDateChanged,
      enabled: !status.isLoading,
      initialValue: ref.watch(todoFormProvider).dueDate,
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(todoFormProvider.select((s) => s.status));

    // Whether the form is in editing mode i.e. editing an existing todo
    final isEditing = ref.watch(todoFormProvider.select((s) => s.isEditing));

    // Whether the form state during when editing a todo has any changes
    final hasChanges = ref.watch(todoFormProvider.select((s) => s.hasChanges));

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;
      await ref.watch(todoFormProvider.notifier).submit();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: status.isLoading || !hasChanges ? null : submit,
        child: status.isLoading
            ? const Text('Submitting...')
            : Text(isEditing ? 'Update Todo' : 'Add Todo'),
      ),
    );
  }
}
