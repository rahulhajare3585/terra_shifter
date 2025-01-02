import 'package:equatable/equatable.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/plates_master.dart';

abstract class PlatesManageState extends Equatable {
  const PlatesManageState();

  @override
  List<Object> get props => [];
}

class PlatesManageInitial extends PlatesManageState {}

class PlatesManageLoading extends PlatesManageState {}

class PlatesManageLoaded extends PlatesManageState {
  final List<PlatesMaster> platesMasters;

  const PlatesManageLoaded(this.platesMasters);

  @override
  List<Object> get props => [platesMasters];
}

class PlatesManageOperationSuccess extends PlatesManageState {
  final String message;

  const PlatesManageOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class PlatesManageError extends PlatesManageState {
  final String error;

  const PlatesManageError(this.error);

  @override
  List<Object> get props => [error];
}

class CustomerLoading extends PlatesManageState {}
class CustomerLoaded extends PlatesManageState {
  final List<Customer> customers;

  CustomerLoaded(this.customers);
}