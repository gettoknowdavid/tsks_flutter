import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/domain/models/auth/user.dart';
import 'package:tsks_flutter/ui/pages/pages.dart';
import 'package:tsks_flutter/ui/providers/auth/auth.dart';

part 'router_notifier.g.dart';
part 'router_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@Riverpod(keepAlive: true)
GoRouter routerConfig(Ref ref) {
  final tsksRouterNotifier = ref.watch(tsksRouterProvider);
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: const SignInRoute().location,
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

// @TypedGoRoute<LoadingRoute>(path: '/loading', name: 'Loading')
// final class LoadingRoute extends GoRouteData with _$LoadingRoute {
//   const LoadingRoute();

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const LoadingPage();
//   }
// }

@TypedGoRoute<LandingRoute>(path: '/landing', name: 'Landing')
final class LandingRoute extends GoRouteData with _$LandingRoute {
  const LandingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LandingPage();
  }
}

@TypedGoRoute<DashboardRoute>(path: '/', name: 'Dashboard')
final class DashboardRoute extends GoRouteData with _$DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardPage();
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
