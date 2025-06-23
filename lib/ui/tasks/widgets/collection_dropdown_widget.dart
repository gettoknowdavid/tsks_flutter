import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
