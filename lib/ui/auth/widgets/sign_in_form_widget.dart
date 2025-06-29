import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/ui/auth/providers/sign_in/sign_in_notifier.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_snackbar.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart' show TinyLoadingIndicator;

class SignInFormWidget extends HookConsumerWidget {
  const SignInFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    ref.listen(signInNotifierProvider, (previous, next) {
      if (previous?.status == next.status) return;
      if (next.status.isFailure || next.exception != null) {
        context.showErrorSnackBar(next.exception?.message);
      }
    });

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailField(key: Key('signIn_emailField')),
          SizedBox(height: 15),
          _PasswordField(key: Key('signIn_passwordField')),
          SizedBox(height: 40),
          _SignInButton(key: Key('signIn_submitButton')),
        ],
      ),
    );
  }
}

class _EmailField extends HookConsumerWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(signInNotifierProvider.select((s) => s.email));
    final status = ref.watch(signInNotifierProvider.select((s) => s.status));
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(hintText: 'Email'),
      onChanged: ref.read(signInNotifierProvider.notifier).emailChanged,
      validator: (value) => email.error?.message,
      enabled: !status.isInProgress,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(signInNotifierProvider.notifier).signIn();
        }
      },
    );
  }
}

class _PasswordField extends HookConsumerWidget {
  const _PasswordField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(
      signInNotifierProvider.select((s) => s.password),
    );

    final status = ref.watch(signInNotifierProvider.select((s) => s.status));

    /// Whether the password is hidden or not. Defaults to true
    final isHidden = useState<bool>(true);

    return TextFormField(
      onChanged: ref.read(signInNotifierProvider.notifier).passwordChanged,
      validator: (value) => password.error?.message,
      enabled: !status.isInProgress,
      obscureText: isHidden.value,
      textInputAction: TextInputAction.go,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(signInNotifierProvider.notifier).signIn();
        }
      },
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: IconButton(
            onPressed: () => isHidden.value = !isHidden.value,
            iconSize: 22,
            icon: isHidden.value
                ? const Icon(PhosphorIconsBold.eye)
                : const Icon(PhosphorIconsBold.eyeSlash),
          ),
        ),
      ),
    );
  }
}

class _SignInButton extends ConsumerWidget {
  const _SignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInProgress = ref.watch(
      signInNotifierProvider.select((s) => s.status.isInProgress),
    );

    Future<void> signIn() async {
      if (Form.of(context).validate()) {
        await ref.read(signInNotifierProvider.notifier).signIn();
      }
    }

    return FilledButton(
      onPressed: isInProgress ? null : signIn,
      child: isInProgress
          ? const TinyLoadingIndicator()
          : const Text('Sign in'),
    );
  }
}
