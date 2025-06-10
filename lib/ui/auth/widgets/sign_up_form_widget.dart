import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tsks_flutter/ui/auth/providers/sign_up/sign_up_notifier.dart';
import 'package:tsks_flutter/ui/core/ui/ui.dart';

class SignUpFormWidget extends HookConsumerWidget {
  const SignUpFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);

    ref.listen(signUpNotifierProvider, (previous, next) {
      if (previous?.status == next.status) return;
      switch (next.status) {
        case SignUpStatus.failure:
          context.showErrorSnackBar(next.exception?.message);
        case SignUpStatus.success:
        case SignUpStatus.initial:
        case SignUpStatus.loading:
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
      validator: (value) => fullName.failureOrNull?.message,
      enabled: status != SignUpStatus.loading,
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
      validator: (value) => email.failureOrNull?.message,
      enabled: status != SignUpStatus.loading,
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
      validator: (value) => password.failureOrNull?.message,
      enabled: status != SignUpStatus.loading,
      obscureText: isHidden.value,
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
    final isLoading = ref.watch(
      signUpNotifierProvider.select((s) => s.status.isLoading),
    );

    Future<void> signUp() async {
      if (Form.of(context).validate()) {
        await ref.read(signUpNotifierProvider.notifier).signUp();
      }
    }

    return FilledButton(
      onPressed: isLoading ? null : signUp,
      child: isLoading ? const TinyLoadingIndicator() : const Text('Sign up'),
    );
  }
}
