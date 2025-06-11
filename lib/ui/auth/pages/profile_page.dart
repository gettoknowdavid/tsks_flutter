import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/ui/auth/providers/auth_repository_provider.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';
import 'package:tsks_flutter/ui/auth/widgets/profile_list_tile.dart';
import 'package:tsks_flutter/ui/auth/widgets/sign_out_button.dart';
import 'package:tsks_flutter/ui/core/ui/page_widget.dart';
import 'package:tsks_flutter/ui/core/ui/user_avatar.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userChangesProvider);
    return switch (authState) {
      AsyncError(:final error) => Text(error.toString()),
      AsyncData(:final value) => ProfileView(isLoading: value == User.empty),
      _ => const ProfileView(isLoading: true),
    };
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({this.isLoading = false, super.key});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return PageWidget(
      title: 'My Account',
      content: Skeletonizer(
        enabled: isLoading,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 72),
            _UserWidget(key: Key('ProfileUserWidget')),
            SizedBox(height: 50),
            _DetailsSection(key: Key('ProfileDetailsSection')),
            SizedBox(height: 32),
            _SubscriptionSection(key: Key('ProfileSubscriptionSection')),
            SizedBox(height: 32),
            SignOutButton(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _UserWidget extends ConsumerWidget {
  const _UserWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    final user = ref.watch(sessionProvider.select((s) => s.value));

    return Row(
      spacing: 16,
      children: [
        const Skeleton.shade(child: UserAvatar(radius: 42)),
        Expanded(
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName.getOrNull ?? '',
                style: textTheme.headlineMedium,
              ),
              Skeleton.shade(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    color: colors.secondaryContainer,
                    border: Border.all(width: 2, color: colors.primary),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text('FREE', style: textTheme.labelSmall),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailsSection extends ConsumerWidget {
  const _DetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    final user = ref.watch(sessionProvider.select((s) => s.value));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(16),
        color: colors.surfaceContainerHigh,
      ),
      child: Column(
        spacing: 32,
        children: [
          ProfileListTile(
            overline: 'Display Name',
            title: user?.fullName.getOrNull ?? '',
            actionButtonTitle: 'Edit',
            onActionButtonPressed: () {},
          ),
          ProfileListTile(
            overline: 'Email',
            title: user?.email.getOrNull ?? '',
            actionButtonTitle: 'Edit',
            onActionButtonPressed: () {},
          ),
          ProfileListTile(
            overline: 'Password',
            title: '**************',
            actionButtonTitle: 'Change',
            onActionButtonPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(16),
        color: colors.surfaceContainerHigh,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: ProfileListTile(
              overline: 'Subscription',
              title: 'Tsks Free',
              actionButtonTitle: 'Update to Pro',
              onActionButtonPressed: () {},
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: const BorderRadiusGeometry.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: const Row(
                spacing: 3,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('See the Pro Benefits '),
                  Icon(PhosphorIconsBold.arrowRight, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
