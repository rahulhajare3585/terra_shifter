import 'package:terra_shifter/data/models/customer.dart';

abstract class CustomerEvent {}

class AddCustomerEvent extends CustomerEvent {
  final Customer customer;

  AddCustomerEvent(this.customer);
}

class GetCustomerEvent extends CustomerEvent {
  final String id;

  GetCustomerEvent(this.id);
}

class GetAllCustomersEvent extends CustomerEvent {}

class UpdateCustomerEvent extends CustomerEvent {
  final Customer customer;

  UpdateCustomerEvent(this.customer);
}

class DeleteCustomerEvent extends CustomerEvent {
  final String id;

  DeleteCustomerEvent(this.id);
}
