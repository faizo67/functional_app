import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(this._loginUseCase) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        final success = await _loginUseCase.execute(
          event.username,
          event.password,
        );
        if (success) {
          emit(LoginSuccess('Login successful'));
        } else {
          emit(LoginFailure('Invalid credentials failed'));
        }
      } catch (e) {
        emit(LoginFailure('An error occurred'));
      }
    });
  }
}
