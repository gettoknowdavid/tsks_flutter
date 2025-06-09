part of 'router_notifier.dart';

final class TsksRouterState with EquatableMixin {
  const TsksRouterState() : this._(redirect: '/loading', allowed: const []);

  const TsksRouterState._({required this.redirect, required this.allowed});

  TsksRouterState loading() => const TsksRouterState._(
    redirect: '/loading',
    allowed: [],
  );

  TsksRouterState authenticated() => const TsksRouterState._(
    redirect: '/',
    allowed: ['/'],
  );

  TsksRouterState unauthenticated() => const TsksRouterState._(
    redirect: '/sign-in',
    allowed: ['/sign-in', 'sign-out', '/landing'],
  );

  final String redirect;
  final List<String> allowed;

  @override
  List<Object?> get props => [redirect, allowed];
}
