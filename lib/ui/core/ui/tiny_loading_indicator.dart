import 'package:flutter/material.dart';

class TinyLoadingIndicator extends StatelessWidget {
  const TinyLoadingIndicator({this.diameter = 16, super.key});
  final double? diameter;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: SizedBox.square(
        dimension: diameter,
        child: CircularProgressIndicator(color: colors.onSurface),
      ),
    );
  }
}
