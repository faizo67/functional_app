import 'package:dio/dio.dart';
import 'package:functional_app/data/repositorie/auth_repository.dart';

class DioClient {
  final Dio dio = Dio();
  AuthRepository? _authRepository;

  DioClient([this._authRepository]) {
    dio.options.baseUrl = 'https://whale-app-pqthm.ondigitalocean.app/api/v0';

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Authorization header if token exists
          final token = _authRepository?.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('Response: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          print('Error on Dio_client: ${e.message}');
          // If unauthorized, try to refresh token and retry
          if (e.response?.statusCode == 401) {
            // No refresh token logic; simply forward the error
            // If you implement refresh logic, handle it here.
          }
          return handler.next(e);
        },
      ),
    );
  }

  set authRepository(AuthRepository repo) => _authRepository = repo;
}
