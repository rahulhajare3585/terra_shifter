import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/pages/tractors/invoice/service/tractor_invoice_page_service.dart';
import 'tractor_invoice_event.dart';
import 'tractor_invoice_state.dart';

class TractorInvoiceBloc extends Bloc<TractorInvoiceEvent, TractorInvoiceState> {
  final TractorInvoicePageService service;

  TractorInvoiceBloc(this.service) : super(TractorInvoiceLoading()) {
    on<LoadTractorInvoice>((event, emit) async {
      emit(TractorInvoiceLoading());
      try {
        final customer = await service.getCustomerById(event.customerId);
        final tractorWorks = await service.getTractorWorksByCustomerId(event.customerId);
        if (customer != null) {
          emit(TractorInvoiceLoaded(customer, tractorWorks));
        } else {
          emit(TractorInvoiceError("Customer not found"));
        }
      } catch (e) {
        emit(TractorInvoiceError("Error loading data: $e"));
      }
    });

    on<FilterTractorInvoiceByDate>((event, emit) async {
      if (state is TractorInvoiceLoaded) {
        final currentState = state as TractorInvoiceLoaded;
        final filteredWorks = currentState.tractorWorks.where((work) {
          final workDate = DateTime.parse(work.workDate);
          return workDate.isAfter(event.startDate) && workDate.isBefore(event.endDate);
        }).toList();
        emit(TractorInvoiceLoaded(currentState.customer, filteredWorks));
      }
    });
  }
}