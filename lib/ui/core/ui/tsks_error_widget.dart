import 'package:flutter/material.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_snackbar.dart';

class TsksErrorWidget extends StatelessWidget {
  const TsksErrorWidget(this.exception, {this.child, super.key});

  final Object exception;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final message = errorMessage(exception);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Text(message),
          if (child != null) ...[
            const SizedBox(height: 20),
            child!,
          ],
        ],
      ),
    );
  }
}
