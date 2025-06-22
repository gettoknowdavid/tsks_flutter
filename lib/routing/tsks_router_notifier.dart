import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tsks_flutter/data/repositories/auth/auth_repository.dart';
import 'package:tsks_flutter/models/auth/user.dart';

part 'tsks_router_notifier.g.dart';

@Riverpod(keepAlive: true)
class TsksRouterNotifier extends _$TsksRouterNotifier {
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
      '/collections/:id',
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
