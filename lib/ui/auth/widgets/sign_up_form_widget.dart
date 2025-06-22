import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/ui/auth/providers/sign_up/sign_up_notifier.dart';
import 'package:tsks_flutter/ui/core/models/models.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';

class SignUpFormWidget extends HookConsumerWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    ref.listen(signUpNotifierProvider, (previous, next) {
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
          _FullNameField(key: Key('signUp_fullNameField')),
          SizedBox(height: 15),
          _EmailField(key: Key('signUp_emailField')),
          SizedBox(height: 15),
          _PasswordField(key: Key('signUp_passwordField')),
          SizedBox(height: 40),
          _SignUpButton(key: Key('signUp_submitButton')),
        ],
      ),
    );
  }
}

class _FullNameField extends HookConsumerWidget {
  const _FullNameField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullName = ref.watch(
      signUpNotifierProvider.select((s) => s.fullName),
    );
    final status = ref.watch(signUpNotifierProvider.select((s) => s.status));
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Full Name'),
      onChanged: ref.read(signUpNotifierProvider.notifier).fullNameChanged,
      validator: (value) => fullName.error?.message,
      enabled: !status.isInProgress,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(signUpNotifierProvider.notifier).signUp();
        }
      },
    );
  }
}

class _EmailField extends HookConsumerWidget {
  const _EmailField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(signUpNotifierProvider.select((s) => s.email));
    final status = ref.watch(signUpNotifierProvider.select((s) => s.status));
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Email'),
      onChanged: ref.read(signUpNotifierProvider.notifier).emailChanged,
      validator: (value) => email.error?.message,
      keyboardType: TextInputType.emailAddress,
      enabled: !status.isInProgress,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(signUpNotifierProvider.notifier).signUp();
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
      signUpNotifierProvider.select((s) => s.password),
    );

    final status = ref.watch(signUpNotifierProvider.select((s) => s.status));

    /// Whether the password is hidden or not. Defaults to true
    final isHidden = useState<bool>(true);

    return TextFormField(
      onChanged: ref.read(signUpNotifierProvider.notifier).passwordChanged,
      validator: (value) => password.error?.message,
      enabled: !status.isInProgress,
      obscureText: isHidden.value,
      onFieldSubmitted: (value) async {
        if (Form.of(context).validate()) {
          await ref.read(signUpNotifierProvider.notifier).signUp();
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

class _SignUpButton extends ConsumerWidget {
  const _SignUpButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInProgress = ref.watch(
      signUpNotifierProvider.select((s) => s.status.isInProgress),
    );

    Future<void> signUp() async {
      if (Form.of(context).validate()) {
        await ref.read(signUpNotifierProvider.notifier).signUp();
      }
    }

    return FilledButton(
      onPressed: isInProgress ? null : signUp,
      child: isInProgress
          ? const TinyLoadingIndicator()
          : const Text('Sign up'),
    );
  }
}
