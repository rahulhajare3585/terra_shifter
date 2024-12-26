import 'package:terra_shifter/data/models/users.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Users user;
  final String message;

  LoginSuccess(this.user, this.message);
}

class LoginError extends LoginState {
  final String error;

  LoginError(this.error);
}

class LogoutSuccess extends LoginState {
  final String message;

  LogoutSuccess(this.message);
}

class GetLoggedInUserSuccess extends LoginState {
  final Users user;

  GetLoggedInUserSuccess(this.user);
}
