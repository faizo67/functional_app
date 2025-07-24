import 'package:functional_app/core/utils/dialog_service.dart';
import 'package:go_router/go_router.dart';
import 'presentation/screen/login_ui.dart';
import 'presentation/screen/home_ui.dart';
import 'domain/usecases/home_usecase.dart';

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
