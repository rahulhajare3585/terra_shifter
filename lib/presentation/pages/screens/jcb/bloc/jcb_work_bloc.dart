import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_event.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/bloc/jcb_work_state.dart';
import 'package:terra_shifter/presentation/pages/screens/jcb/service/jcb_work_service.dart';

class JcbWorkBloc extends Bloc<JcbWorkEvent, JcbWorkState> {
  final JcbWorkService jcbWorkService;

  JcbWorkBloc(this.jcbWorkService) : super(JcbWorkLoading()) {
    on<GetAllJcbWorksEvent>((event, emit) async {
      emit(JcbWorkLoading());
      try {
        final jcbWorks = await jcbWorkService.getAllJcbWorks();
        emit(JcbWorkLoaded(jcbWorks));
      } catch (e) {
        emit(JcbWorkError(e.toString()));
      }
    });

    on<AddJcbWorkEvent>((event, emit) async {
      try {
        await jcbWorkService.addJcbWork(event.jcbWork);
        emit(JcbWorkOperationSuccess("JcbWork added successfully!"));
        add(GetAllJcbWorksEvent());
      } catch (e) {
        emit(JcbWorkError(e.toString()));
      }
    });
    

    on<UpdateJcbWorkEvent>((event, emit) async {
      try {
        await jcbWorkService.updateJcbWork(event.jcbWork);
        emit(JcbWorkOperationSuccess("JcbWork updated successfully!"));
        add(GetAllJcbWorksEvent());
      } catch (e) {
        emit(JcbWorkError(e.toString()));
      }
    });

    on<GetAllCustomersEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customers = await jcbWorkService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to fetch customers: ${e.toString()}"));
      }
    });
  }
}