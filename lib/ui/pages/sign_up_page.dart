import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/widgets/facebook_sign_in_button.dart';
import 'package:tsks_flutter/ui/widgets/google_sign_in_button.dart';
import 'package:tsks_flutter/ui/widgets/sign_up_form_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      body: MaxWidthBox(
        maxWidth: 420,
        child: SingleChildScrollView(
          padding: ResponsiveValue<EdgeInsets>(
            context,
            defaultValue: EdgeInsets.zero,
            conditionalValues: [
              const Condition.smallerThan(
                name: TABLET,
                value: EdgeInsets.symmetric(horizontal: 16),
              ),
            ],
          ).value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ResponsiveValue<Widget>(
                context,
                defaultValue: const SizedBox(height: 150),
                conditionalValues: [
                  const Condition.smallerThan(
                    name: TABLET,
                    value: SizedBox(height: 125),
                  ),
                ],
              ).value,
              Text(
                'Sign Up.',
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              const GoogleSignInButton(),
              const SizedBox(height: 20),
              const FacebookSignInButton(),
              const SizedBox(height: 20),
              Text(
                'or',
                style: textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const SignUpFormWidget(),
              const SizedBox(height: 50),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.maybePop(context);
                    } else {
                      const SignInRoute().push<void>(context);
                    }
                  },
                  icon: const Icon(PhosphorIconsRegular.caretLeft),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceVariant,
                  ),
                  label: const Text('Back to Sign in'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
