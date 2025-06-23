import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/models/collections/collection.dart';
import 'package:tsks_flutter/routing/router.dart';
import 'package:tsks_flutter/ui/collections/providers/collections_notifier.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/cancel_button.dart';
import 'package:tsks_flutter/ui/core/ui/date_form_field.dart';
import 'package:tsks_flutter/ui/tasks/providers/task_form/task_form_notifier.dart';
import 'package:tsks_flutter/ui/tasks/providers/tasks_notifier.dart';
import 'package:tsks_flutter/ui/tasks/widgets/collection_dropdown_widget.dart';

class TaskFormWidget extends HookConsumerWidget {
  const TaskFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) ref.invalidate(taskFormNotifierProvider);
      },
      child: Form(
        key: formKey,
        child: const Padding(
          padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
          child: Column(
            children: [
              _TitleField(key: Key('todoForm_titleField')),
              SizedBox(height: 24),
              Row(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CollectionField(key: Key('todoForm_collectionField')),
                  Expanded(
                    child: _DateField(key: Key('todoForm_collectionDueDate')),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                spacing: 16,
                children: [
                  _SubmitButton(key: Key('todoForm_submitButton')),
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
    final title = ref.watch(taskFormNotifierProvider.select((s) => s.title));

    // Collection ID
    final cId = ref.read(taskFormNotifierProvider.select((s) => s.collection));

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
      onFieldSubmitted: (value) async {
        if (!Form.of(context).validate()) return;
        FocusScope.of(context).unfocus();
        await ref.read(tasksNotifierProvider(cId).notifier).createTask();
      },
    );
  }
}

class _CollectionField extends HookConsumerWidget {
  const _CollectionField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsNotifierProvider);

    final pathId = ref.watch(routerConfigProvider).state.pathParameters['id'];

    final selectedCollectionId = ref.watch(
      taskFormNotifierProvider.select((s) => s.collection),
    );

    return CollectionDropdownWidget(
      items: _items(collections),
      value: selectedCollectionId.isEmpty ? null : selectedCollectionId,
      onChanged: ref.read(taskFormNotifierProvider.notifier).collectionChanged,
      enabled: pathId == null,
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

class _DateField extends HookConsumerWidget {
  const _DateField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskFormNotifierProvider.notifier);
    return DateFormField(
      onChanged: notifier.dueDateChanged,
      initialValue: ref.watch(taskFormNotifierProvider).dueDate,
    );
  }
}

class _SubmitButton extends HookConsumerWidget {
  const _SubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final submitPressed = useState<bool>(false);

    final state = ref.watch(taskFormNotifierProvider);
    final collectionId = state.collection;
    final notifier = ref.read(tasksNotifierProvider(collectionId).notifier);

    Future<void> submit() async {
      if (!Form.of(context).validate()) return;

      submitPressed.value = true;
      FocusScope.of(context).unfocus();

      if (state.isEdit) {
        await notifier.updateTask(state.initialTask!);
      } else {
        await notifier.createTask();
      }

      ref.read(routerConfigProvider).pop();
    }

    return SizedBox(
      height: 52,
      child: FilledButton(
        style: FilledButton.styleFrom(),
        onPressed: submitPressed.value || !state.hasChanges ? null : submit,
        child: Text(state.isEdit ? 'Update Task' : 'Add Task'),
      ),
    );
  }
}
