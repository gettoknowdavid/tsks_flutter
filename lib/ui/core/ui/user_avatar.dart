import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/routing/router_notifier.dart';
import 'package:tsks_flutter/ui/auth/providers/session/session.dart';

class UserAvatar extends ConsumerWidget {
  const UserAvatar({this.radius = 20, super.key});
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final session = ref.watch(sessionProvider);
    final avatar = CircleAvatar(radius: radius);

    void onTap() => const ProfileRoute().push<void>(context);

    switch (session) {
      case AsyncLoading():
        return Skeletonizer(child: avatar);
      case AsyncData(:final value):
        if (value == User.empty) return avatar;
        if (value.photoURL == null) {
          return InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radius),
            child: CircleAvatar(
              radius: radius,
              child: Text(
                value.nameInitials,
                style: theme.textTheme.labelLarge,
              ),
            ),
          );
        }
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            imageUrl: value.photoURL!,
            placeholder: (context, url) => Skeletonizer(child: avatar),
            imageBuilder: (context, imageProvider) => CircleAvatar(
              radius: radius,
              foregroundImage: imageProvider,
            ),
          ),
        );

      default:
        return avatar;
    }
  }
}
