import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tsks_flutter/ui/auth/widgets/widgets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

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
                'Sign In.',
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              const GoogleSignInButton(),
              const SizedBox(height: 20),
              const FacebookSignInButton(),
              const SizedBox(height: 20),
              const Text('or', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              const SignInFormWidget(),
              const SizedBox(height: 50),
              const AuthRedirectButton(),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: colors.onSurfaceVariant,
                  ),
                  child: const Text(
                    'Forgot Password?',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
