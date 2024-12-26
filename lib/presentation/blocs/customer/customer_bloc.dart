

import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/customer_service.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_event.dart';
import 'package:terra_shifter/presentation/blocs/customer/customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerService customerService;

  CustomerBloc(this.customerService) : super(CustomerInitial()) {
    on<AddCustomerEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerService.addCustomer(event.customer);
        emit(CustomerOperationSuccess("Customer added successfully"));
        final customers = await customerService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to add customer: ${e.toString()}"));
      }
    });

    on<GetCustomerEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customer = await customerService.getCustomer(event.id);
        if (customer != null) {
          emit(CustomerLoaded([customer]));
        } else {
          emit(CustomerError("Customer not found"));
        }
      } catch (e) {
        emit(CustomerError("Failed to fetch customer: ${e.toString()}"));
      }
    });

    on<GetAllCustomersEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customers = await customerService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to fetch customers: ${e.toString()}"));
      }
    });

    on<UpdateCustomerEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerService.updateCustomer(event.customer);
        emit(CustomerOperationSuccess("Customer updated successfully"));
        final customers = await customerService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to update customer: ${e.toString()}"));
      }
    });

    on<DeleteCustomerEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        await customerService.deleteCustomer(event.id);
        emit(CustomerOperationSuccess("Customer deleted successfully"));
        final customers = await customerService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to delete customer: ${e.toString()}"));
      }
    });
  }
}
