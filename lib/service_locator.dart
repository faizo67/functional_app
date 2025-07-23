import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'data/repositorie/auth_repository.dart';
import 'data/repositorie/home_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/home_usecase.dart';
import 'presentation/bloc/login/login_bloc.dart';
import 'presentation/bloc/home/home_bloc.dart';
import 'core/Dio/dio_client.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // External
  getIt.registerLazySingleton<Dio>(() => Dio());

  // Core
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<DioClient>()),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(getIt<Dio>()),
  );

  // Use Cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<HomeUseCase>(
    () => HomeUseCase(getIt<HomeRepository>()),
  );

  // Blocs
  getIt.registerFactory<LoginBloc>(() => LoginBloc(getIt<LoginUseCase>()));
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<HomeUseCase>()));
}
