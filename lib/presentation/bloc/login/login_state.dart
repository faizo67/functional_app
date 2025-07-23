part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  LoginSuccess(this.token);

  String get accessToken => token;
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
