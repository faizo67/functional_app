import '../../core/Dio/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;
  String? _accessToken;
  String? _refreshToken;
  AuthRepository(this._dioClient);

  // Login
  Future<bool> login(String login, String password) async {
    final response = await _dioClient.dio.post(
      '/auth/login',
      data: {'login': login, 'password': password},
    );
    print('Login response: \\${response.data}');
    if ((response.statusCode == 200 || response.statusCode == 202) &&
        response.data['access_token'] != null) {
      _accessToken = response.data['access_token'];
      _refreshToken = response.data['refresh_token'];
      return true;
    }
    return false;
  }

  // Refresh token logic
  Future<bool> refreshToken() async {
    if (_refreshToken == null) return false;
    final response = await _dioClient.dio.post(
      '/auth/refresh',
      data: {'refresh_token': _refreshToken},
    );
    if ((response.statusCode == 200 || response.statusCode == 202) &&
        response.data['access_token'] != null) {
      _accessToken = response.data['access_token'];
      // Optionally update refresh token if returned
      if (response.data['refresh_token'] != null) {
        _refreshToken = response.data['refresh_token'];
      }
      return true;
    }
    return false;
  }

  // Logout
  Future<void> logout() async {
    _accessToken = null;
    _refreshToken = null;
  }

  // Get access token
  String? get accessToken => _accessToken;
}
