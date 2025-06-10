import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/core/themes/colors.dart';

typedef TMessenger = ScaffoldFeatureController<SnackBar, SnackBarClosedReason>;

ColorScheme get _colors {
  final brightness = PlatformDispatcher.instance.platformBrightness;
  final isLight = brightness == Brightness.light;
  return isLight ? TsksColors.lightColorScheme : TsksColors.darkColorScheme;
}

extension TsksSnackbar on BuildContext {
  TMessenger showErrorSnackBar(String? message) {
    final style = TextStyle(fontSize: 14, color: _colors.onError);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: _colors.error,
        content: Text(message ?? 'Unknown Error', style: style),
        behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        width: ResponsiveValue<double>(
          this,
          defaultValue: double.infinity,
          conditionalValues: [
            const Condition.largerThan(
              name: TABLET,
              value: 420,
            ),
          ],
        ).value,
      ),
    );
  }

  TMessenger showSuccessSnackBar(String message) {
    final style = TextStyle(fontSize: 14, color: _colors.onPrimary);
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: _colors.primary,
        content: Text(message, style: style),
        behavior: kIsWeb ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
        width: ResponsiveValue<double>(
          this,
          defaultValue: double.infinity,
          conditionalValues: [
            const Condition.largerThan(
              name: TABLET,
              value: 420,
            ),
          ],
        ).value,
      ),
    );
  }
}
