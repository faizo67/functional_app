import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:functional_app/presentation/bloc/home/home_bloc.dart';
import 'package:functional_app/presentation/bloc/login/login_bloc.dart';
import 'package:functional_app/presentation/screen/login_ui.dart';
import 'package:functional_app/presentation/screen/home_ui.dart';
import 'service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<LoginBloc>()),
        BlocProvider(create: (_) => getIt<HomeBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: LoginUI(),
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            final accessToken = settings.arguments as String;
            return MaterialPageRoute(
              builder: (_) =>
                  HomeUI(accessToken: accessToken, homeUseCase: getIt()),
            );
          }
          // Add other routes here if needed
          return null;
        },
      ),
    );
  }
}
