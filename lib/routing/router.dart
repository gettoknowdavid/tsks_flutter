import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsks_flutter/ui/pages/pages.dart';

part 'router.g.dart';

final routerConfig = GoRouter(
  // initialLocation: const SignInRoute().location,
  routes: $appRoutes,
);

@TypedGoRoute<LandingRoute>(path: '/landing', name: 'Landing')
final class LandingRoute extends GoRouteData with _$LandingRoute {
  const LandingRoute();

  @override
  Widget build(context, state) => const LandingPage();
}

@TypedGoRoute<DashboardRoute>(path: '/', name: 'Dashboard')
final class DashboardRoute extends GoRouteData with _$DashboardRoute {
  const DashboardRoute();

  @override
  Widget build(context, state) => const DashboardPage();
}

@TypedGoRoute<SignInRoute>(path: '/sign-in', name: 'Sign In')
final class SignInRoute extends GoRouteData with _$SignInRoute {
  const SignInRoute();

  @override
  Widget build(context, state) => const SignInPage();
}
