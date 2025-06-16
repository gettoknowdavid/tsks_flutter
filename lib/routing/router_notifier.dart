import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/core/value_objects/uid.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/ui/auth/pages/pages.dart';
import 'package:tsks_flutter/ui/auth/providers/auth_repository_provider.dart';
import 'package:tsks_flutter/ui/core/ui/landing_page.dart';
import 'package:tsks_flutter/ui/core/ui/tsks_layout.dart';
import 'package:tsks_flutter/ui/todos/pages/pages.dart';

part 'router_notifier.g.dart';
part 'router_state.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> layoutKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter routerConfig(Ref ref) {
  final tsksRouterNotifier = ref.watch(tsksRouterProvider);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: const DashboardRoute().location,
    routes: $appRoutes,
    refreshListenable: tsksRouterNotifier,
    redirect: (context, routerState) {
      final allowedPaths = tsksRouterNotifier.value.allowedPath;
      final isAllowedPath = allowedPaths.contains(routerState.fullPath);
      return !isAllowedPath ? tsksRouterNotifier.value.redirectPath : null;
    },
  );
}

@Riverpod(keepAlive: true)
Stream<String> routerLocation(Ref ref) {
  final delegate = ref.watch(routerConfigProvider).routerDelegate;

  return Stream.multi((contr) {
    contr.add(delegate.currentConfiguration.uri.toString());
    void listener() => contr.add(delegate.currentConfiguration.uri.toString());
    delegate.addListener(listener);
    ref.onDispose(() => delegate.removeListener(listener));
  });
}

@Riverpod(keepAlive: true)
class TsksRouter extends _$TsksRouter {
  @override
  Raw<ValueNotifier<TsksRouterState>> build() {
    state = ValueNotifier(const TsksRouterState());

    ref.listen(userChangesProvider, (previous, next) {
      switch (next) {
        case AsyncLoading():
          state = ValueNotifier(state.value.loading());
        case AsyncError():
          state = ValueNotifier(state.value.unauthenticated());
        case AsyncData(:final value):
          if (value == User.empty) {
            state = ValueNotifier(state.value.unauthenticated());
          } else {
            state = ValueNotifier(state.value.authenticated());
          }
      }
    }, fireImmediately: true);

    return state;
  }
}

@TypedGoRoute<LandingRoute>(path: '/landing', name: 'Landing')
final class LandingRoute extends GoRouteData with _$LandingRoute {
  const LandingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LandingPage();
  }
}

@TypedGoRoute<SignInRoute>(path: '/sign-in', name: 'Sign In')
final class SignInRoute extends GoRouteData with _$SignInRoute {
  const SignInRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignInPage();
  }
}

@TypedGoRoute<SignUpRoute>(path: '/sign-up', name: 'Sign Up')
final class SignUpRoute extends GoRouteData with _$SignUpRoute {
  const SignUpRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SignUpPage();
  }
}

@TypedStatefulShellRoute<TsksLayoutRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<DashboardShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<DashboardRoute>(
          path: '/',
          name: 'Dashboard',
        ),
      ],
    ),
    TypedStatefulShellBranch<CollectionsShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CollectionsRoute>(
          path: '/collections',
          name: 'Collections',
        ),
        TypedGoRoute<CollectionRoute>(
          path: '/collections/:uid',
          name: 'Collection',
        ),
      ],
    ),
    TypedStatefulShellBranch<SearchShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SearchRoute>(
          path: '/search',
          name: 'Search',
        ),
      ],
    ),
    TypedStatefulShellBranch<NotificationsShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<NotificationsRoute>(
          path: '/notifications',
          name: 'Notifications',
        ),
      ],
    ),
    TypedStatefulShellBranch<ProfileShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRoute>(
          path: '/me',
          name: 'My Profile',
        ),
      ],
    ),
  ],
)
final class TsksLayoutRoute extends StatefulShellRouteData {
  const TsksLayoutRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = layoutKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return TsksLayout(navigationShell: navigationShell);
  }
}

final class DashboardShellBranchData extends StatefulShellBranchData {
  const DashboardShellBranchData();
}

final class DashboardRoute extends GoRouteData with _$DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardPage();
  }
}

final class CollectionsShellBranchData extends StatefulShellBranchData {
  const CollectionsShellBranchData();
}

final class CollectionsRoute extends GoRouteData with _$CollectionsRoute {
  const CollectionsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CollectionsPage();
  }
}

final class CollectionRoute extends GoRouteData with _$CollectionRoute {
  const CollectionRoute(this.uid);

  final String uid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CollectionPage(uid: Uid(uid));
  }
}

final class SearchShellBranchData extends StatefulShellBranchData {
  const SearchShellBranchData();
}

final class SearchRoute extends GoRouteData with _$SearchRoute {
  const SearchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SearchPage();
  }
}

final class NotificationsShellBranchData extends StatefulShellBranchData {
  const NotificationsShellBranchData();
}

final class NotificationsRoute extends GoRouteData with _$NotificationsRoute {
  const NotificationsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationsPage();
  }
}

final class ProfileShellBranchData extends StatefulShellBranchData {
  const ProfileShellBranchData();
}

final class ProfileRoute extends GoRouteData with _$ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

// extension GoRouterX on GoRouter {
//   String get currentLocation {
//     final lastMatch = routerDelegate.currentConfiguration.last;
//     final matchList = lastMatch is ImperativeRouteMatch
//         ? lastMatch.matches
//         : routerDelegate.currentConfiguration;
//     return matchList.uri.toString();
//   }
// }
