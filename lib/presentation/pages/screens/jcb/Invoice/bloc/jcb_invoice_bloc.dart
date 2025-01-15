import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_event.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/bloc/jcb_invoice_state.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/Invoice/service/jcb_invoice_page_service.dart';
import 'package:terra_shifter/presentation/pages/tractors/invoice/service/tractor_invoice_page_service.dart';

class JCBInvoiceBloc extends Bloc<JcbInvoiceEvent, JCBInvoiceState> {
  final JcbInvoicePageService service;

  JCBInvoiceBloc(this.service) : super(JCBInvoiceLoading()) {
    on<LoadJCBInvoice>((event, emit) async {
      emit(JCBInvoiceLoading());
      try {
        final customer = await service.getCustomerById(event.customerId);
        final jcbWork = await service.getJCBWorksByCustomerId(event.customerId);
        if (customer != null) {
          emit(JCBInvoiceLoaded(customer, jcbWork));
        } else {
          emit(JCBInvoiceError("Customer not found"));
        }
      } catch (e) {
        emit(JCBInvoiceError("Error loading data: $e"));
      }
    });

    on<FilterJCBInvoiceByDate>((event, emit) async {
      if (state is JCBInvoiceLoaded) {
        final currentState = state as JCBInvoiceLoaded;
        final filteredWorks = currentState.jcbWork.where((work) {
          final workDate = DateTime.parse(work.WorkDate);
          return workDate.isAfter(event.startDate) && workDate.isBefore(event.endDate);
        }).toList();
        emit(JCBInvoiceLoaded(currentState.customer, filteredWorks));
      }
    });
  }
}