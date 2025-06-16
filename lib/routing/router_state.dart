part of 'router_notifier.dart';

final class TsksRouterState with EquatableMixin {
  const TsksRouterState() : this._(redirectPath: '/', allowedPath: const []);

  const TsksRouterState._({
    required this.redirectPath,
    required this.allowedPath,
  });

  TsksRouterState loading() => const TsksRouterState._(
    redirectPath: '/',
    allowedPath: [],
  );

  TsksRouterState authenticated() => const TsksRouterState._(
    redirectPath: '/',
    allowedPath: [
      '/',
      '/collections',
      '/collections/:uid',
      '/search',
      '/notifications',
      '/me',
      '/new-todo',
    ],
  );

  TsksRouterState unauthenticated() => const TsksRouterState._(
    redirectPath: '/sign-in',
    allowedPath: ['/sign-in', '/sign-up', '/landing'],
  );

  final String redirectPath;
  final List<String> allowedPath;

  @override
  List<Object?> get props => [redirectPath, allowedPath];
}
