import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    required void Function(DateTime?) onChanged,
    super.key,
    super.initialValue,
    super.validator,
    bool? enabled,
  }) : super(
         builder: (FormFieldState<DateTime> field) {
           return _DateField(
             key: key,
             field: field,
             initialValue: initialValue,
             onChanged: onChanged,
             validator: validator,
             enabled: enabled,
           );
         },
       );
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.field,
    required this.onChanged,
    super.key,
    this.initialValue,
    this.validator,
    this.enabled,
  });

  final FormFieldState<DateTime> field;
  final void Function(DateTime?) onChanged;
  final DateTime? initialValue;
  final String? Function(DateTime?)? validator;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final today = DateTime.now();
    final formattedDate = field.value != null
        ? DateFormat.yMEd().format(field.value!)
        : 'Pick a due date';

    return UnmanagedRestorationScope(
      bucket: field.bucket,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              helperText: 'Due Date',
              hintText: formattedDate,
            ),
            enabled: enabled,
            readOnly: true,
            style: theme.textTheme.labelLarge,
            validator: (value) => validator?.call(field.value),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: field.context,
                initialDate: initialValue ?? today,
                currentDate: today,
                firstDate: today,
                lastDate: DateTime(today.year + 1),
              );
              if (pickedDate == null) return;
              field.didChange(pickedDate);
              return onChanged(pickedDate);
            },
          ),
        ],
      ),
    );
  }
}
