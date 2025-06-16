import 'package:flutter/material.dart';

class BottomSheetPage<T> extends Page<void> {
  const BottomSheetPage({
    required this.builder,
    this.isDismissible = true,
    super.key,
  });

  final WidgetBuilder builder;
  final bool isDismissible;

  @override
  Route<T> createRoute(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.9;
    return ModalBottomSheetRoute<T>(
      builder: builder,
      isScrollControlled: true,
      settings: this,
      showDragHandle: true,
      useSafeArea: true,
      isDismissible: isDismissible,
      constraints: BoxConstraints(maxHeight: maxHeight),
      shape: const RoundedSuperellipseBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(24)),
      ),
    );
  }
}

class DialogPage<T> extends Page<T> {
  const DialogPage({
    required this.builder,
    super.key,
    this.barrierDismissible = true,
    this.barrierColor,
  });

  final WidgetBuilder builder;
  final bool barrierDismissible;
  final Color? barrierColor;

  @override
  Route<T> createRoute(BuildContext context) {
    return DialogRoute<T>(
      context: context,
      settings: this,
      useSafeArea: false,
      barrierDismissible: barrierDismissible,
      builder: builder,
      barrierColor: barrierColor ?? Colors.black54,
    );
  }
}
