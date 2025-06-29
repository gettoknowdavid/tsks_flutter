import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsks_flutter/ui/collections/providers/collection_form/collection_form_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/check_mark.dart';

class ColorRadioButton extends ConsumerWidget {
  const ColorRadioButton(this.color, {super.key});

  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(collectionFormNotifierProvider.notifier);
    final isSelected = ref.watch(
      collectionFormNotifierProvider.select((s) => s.color == color),
    );
    return Center(
      child: InkWell(
        onTap: () {
          if (isSelected) {
            notifier.colorChanged(null);
          } else {
            notifier.colorChanged(color);
          }
        },
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadiusGeometry.all(Radius.circular(10)),
          ),
          child: isSelected ? const _CheckMark() : null,
        ),
      ),
    );
  }
}

class _CheckMark extends StatelessWidget {
  const _CheckMark();

  @override
  Widget build(BuildContext context) {
    return const CheckMark(
      color: Colors.black,
      dimension: 24,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    );
  }
}
