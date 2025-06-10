import 'package:flutter/material.dart';

class TinyLoadingIndicator extends StatelessWidget {
  const TinyLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox.square(
        dimension: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
