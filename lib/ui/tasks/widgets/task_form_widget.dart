import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/providers/all_collections.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/cancel_button.dart';
import 'package:tsks_flutter/ui/core/ui/date_form_field.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_snackbar.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';

class TaskFormWidget extends HookConsumerWidget {
  const TaskFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final status = ref.watch(taskFormNotifierProvider.select((s) => s.status));

    ref.listen(taskFormNotifierProvider, (previous, next) {
      if (previous?.status == next.status) return;

      if (next.status.isFailure) {
        context.showErrorSnackBar(next.exception?.message);
      }

      if (next.status.isSuccess) {
        final newOrUpdatedTask = next.newTask;
        if (newOrUpdatedTask != null) {
          // Optimistically update the collections list
          final collection = newOrUpdatedTask.collection;
          final notifier = ref.read(tasksNotifierProvider(collection).notifier);
          notifier.optimisticallyUpdate(newOrUpdatedTask);
        }
        Navigator.pop(context);
      }
    });

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.invalidate(taskFormNotifierProvider);
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
    final title = ref.watch(taskFormNotifierProvider.select((s) => s.title));
    final status = ref.watch(taskFormNotifierProvider.select((s) => s.status));
    return TextFormField(
      focusNode: focusNode,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Task title',
        fillColor: colors.surfaceContainer,
        filled: true,
      ),
      initialValue: title.value,
      onChanged: ref.read(taskFormNotifierProvider.notifier).titleChanged,
      validator: (value) => title.error?.message,
      enabled: !status.isInProgress,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          FocusScope.of(context).unfocus();
          await ref.read(taskFormNotifierProvider.notifier).submit();
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

    final pathId = ref.watch(routerConfigProvider).state.pathParameters['id'];

    final selectedCollectionId = ref.watch(
      taskFormNotifierProvider.select((s) => s.collectionId),
    );

    final status = ref.watch(taskFormNotifierProvider.select((s) => s.status));

    return CollectionDropdownWidget(
      items: _items(collections),
      value: selectedCollectionId.isEmpty ? null : selectedCollectionId,
      onChanged: ref.read(taskFormNotifierProvider.notifier).collectionChanged,
      enabled: pathId == null && !status.isInProgress,
      validator: (value) => value == null ? 'Collection required ' : null,
    );
  }

  List<DropdownMenuItem<String?>> _items(
    AsyncValue<List<Collection?>> collections,
  ) {
    switch (collections) {
      case AsyncData(:final value):
        if (value.isEmpty) return [];
        return value.map((collection) {
          return DropdownMenuItem<String>(
            value: collection!.id,
            child: Text(collection.title),
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

  final String? value;
  final List<DropdownMenuItem<String?>> items;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String?>(
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
    final notifier = ref.read(taskFormNotifierProvider.notifier);
    final status = ref.watch(taskFormNotifierProvider.select((s) => s.status));
    return DateFormField(
      onChanged: notifier.dueDateChanged,
      enabled: !status.isInProgress,
      initialValue: ref.watch(taskFormNotifierProvider).dueDate,
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInProgress = ref.watch(
      taskFormNotifierProvider.select((s) => s.status.isInProgress),
    );

    // Whether the form is in editing mode i.e. editing an existing todo
    final isEditing = ref.watch(
      taskFormNotifierProvider.select((s) => s.isEditing),
    );

    // Whether the form state during when editing a todo has any changes
    final hasChanges = ref.watch(
      taskFormNotifierProvider.select((s) => s.hasChanges),
    );

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;
      await ref.watch(taskFormNotifierProvider.notifier).submit();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: isInProgress || !hasChanges ? null : submit,
        child: isInProgress
            ? const Text('Submitting...')
            : Text(isEditing ? 'Update Task' : 'Add Task'),
      ),
    );
  }
}
