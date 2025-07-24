import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:functional_app/core/utils/app_theme.dart';
import 'package:functional_app/core/utils/dialog_service.dart';
import 'package:functional_app/presentation/bloc/home/home_bloc.dart';
import 'package:functional_app/presentation/bloc/login/login_bloc.dart';
import 'service_locator.dart';
import 'go_router.dart';
import 'domain/usecases/home_usecase.dart';

void main() {
  setupLocator();
   DialogService().navigatorKey = GlobalKey<NavigatorState>();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final homeUseCase = getIt<HomeUseCase>();
    final router = createRouter(homeUseCase);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<HomeBloc>()),
      ],
      child: MaterialApp.router(
        theme: appThemeColor,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        routerConfig: router,
      ),
    );
  }
}
