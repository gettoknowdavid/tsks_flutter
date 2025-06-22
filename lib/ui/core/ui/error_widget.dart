import 'package:flutter/material.dart';
import 'package:tsks_flutter/data/exceptions/tsks_exception.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget(this.exception, {this.child, super.key});

  final Object exception;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          if (exception is TsksException)
            Text((exception as TsksException).message)
          else
            Text(exception.toString()),
          if (child != null) ...[
            const SizedBox(height: 20),
            child!,
          ],
        ],
      ),
    );
  }
}
