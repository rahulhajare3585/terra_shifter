import 'package:terra_shifter/data/models/users.dart';

abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  LoginUserEvent(this.email, this.password);
}

class LogoutUserEvent extends LoginEvent {}

class GetLoggedInUserEvent extends LoginEvent {}

class UpdateUserLoginDetailsEvent extends LoginEvent {
  final Users user;

  UpdateUserLoginDetailsEvent(this.user);
}
