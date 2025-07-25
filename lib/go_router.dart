import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/utils/dialog_service.dart';
import 'presentation/screen/login_ui.dart';
import 'presentation/screen/home_ui.dart';
import 'presentation/screen/details.dart';
import 'domain/usecases/home_usecase.dart';
import 'data/models/product_model.dart';

GoRouter createRouter(HomeUseCase homeUseCase) => GoRouter(
  navigatorKey: DialogService().navigatorKey,
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
        final accessToken = state.extra is String ? state.extra as String : '';
        return HomeUI(accessToken: accessToken, homeUseCase: homeUseCase);
      },
      routes: [
        GoRoute(
          path: 'details',
          name: 'details',
          builder: (context, state) {
            final product = state.extra as ProductModel;
            return DetailsScreen(product: product);
          },
        ),
      ],
    ),
  ],
);
