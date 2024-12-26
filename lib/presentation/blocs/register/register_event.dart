import 'package:terra_shifter/data/models/users.dart';

abstract class RegisterEvent {}

class RegisterUserEvent extends RegisterEvent {
  final Users user;

  RegisterUserEvent(this.user);
}

class GetUserEvent extends RegisterEvent {
  final String id;

  GetUserEvent(this.id);
}

class GetAllUsersEvent extends RegisterEvent {}

class UpdateUserEvent extends RegisterEvent {
  final Users user;

  UpdateUserEvent(this.user);
}

class DeleteUserEvent extends RegisterEvent {
  final String id;

  DeleteUserEvent(this.id);
}
