import 'package:terra_shifter/data/models/customer.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;

  CustomerLoaded(this.customers);
}

class CustomerOperationSuccess extends CustomerState {
  final String message;

  CustomerOperationSuccess(this.message);
}

class successState extends CustomerState{}

class CustomerError extends CustomerState {
  final String error;

  CustomerError(this.error);
}
