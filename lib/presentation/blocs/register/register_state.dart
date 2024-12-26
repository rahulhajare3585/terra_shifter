import 'package:terra_shifter/data/models/users.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;

  RegisterSuccess(this.message);
}

class RegisterLoaded extends RegisterState {
  final Users user;

  RegisterLoaded(this.user);
}

class RegisterError extends RegisterState {
  final String error;

  RegisterError(this.error);
}
