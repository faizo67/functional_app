import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screen/login_ui.dart';
import 'presentation/screen/home_ui.dart';
import 'domain/usecases/home_usecase.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(HomeUseCase homeUseCase) => GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginUI(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        final accessToken = state.extra as String? ?? '';
        return HomeUI(accessToken: accessToken, homeUseCase: homeUseCase);
      },
      routes: [
        GoRoute(
          path: 'details',
          name: 'details',
          builder: (context, state) {
            final title = state.extra as String? ?? '';
            return NextScreen(title: title);
          },
        ),
      ],
    ),
  ],
);
