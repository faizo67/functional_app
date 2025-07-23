import 'package:functional_app/data/repositorie/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// Attempts to log in with the provided [login] and [password].
  /// Returns true if login is successful, false otherwise.
  Future<bool> execute(String login, String password) async {
    if (login.isEmpty || password.isEmpty) {
      // You can throw a custom exception or return false for invalid input
      print('Login or password cannot be empty');
      return false;
    }
    try {
      final result = await _authRepository.login(login, password);
      if (result) {
        // Login success
        return true;
      } else {
        // Handle login failure, e.g., show a message to the user
        print('Login failed: Invalid credentials are failed');
        return false;
      }
    } catch (e) {
      // Handle or log error as needed
      print('Login failed: $e');
      return false;
    }
  }
}
