import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/tractor_work_service.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_event.dart';
import 'package:terra_shifter/presentation/blocs/tractor/tractor_work_state.dart';

class TractorsWorkBloc extends Bloc<TractorsWorkEvent, TractorsWorkState> {
  final TractorsWorkService tractorsWorkService;

  TractorsWorkBloc(this.tractorsWorkService) : super(TractorsWorkInitial()) {
    on<AddTractorsWorkEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        await tractorsWorkService.addTractorWork(event.tractorsWork);
        emit(TractorsWorkOperationSuccess("Work added successfully"));
        final tractorsWorks = await tractorsWorkService.getAllTractorWorks();
        emit(TractorsWorkLoaded(tractorsWorks));
      } catch (e) {
        emit(TractorsWorkError("Failed to add work: ${e.toString()}"));
      }
    });

    on<GetTractorsWorkEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        final tractorsWork = await tractorsWorkService.getTractorWork(event.id);
        if (tractorsWork != null) {
          emit(TractorsWorkLoaded([tractorsWork]));
        } else {
          emit(TractorsWorkError("Work not found"));
        }
      } catch (e) {
        emit(TractorsWorkError("Failed to fetch work: ${e.toString()}"));
      }
    });

    on<GetAllTractorsWorksEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        final tractorsWorks = await tractorsWorkService.getAllTractorWorks();
        emit(TractorsWorkLoaded(tractorsWorks));
      } catch (e) {
        emit(TractorsWorkError("Failed to fetch works: ${e.toString()}"));
      }
    });

    on<UpdateTractorsWorkEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        await tractorsWorkService.updateTractorWork(event.tractorsWork);
        emit(TractorsWorkOperationSuccess("Work updated successfully"));
        final tractorsWorks = await tractorsWorkService.getAllTractorWorks();
        emit(TractorsWorkLoaded(tractorsWorks));
      } catch (e) {
        emit(TractorsWorkError("Failed to update work: ${e.toString()}"));
      }
    });

    on<GetTractorsWorkByCustomerIdEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        final tractorsWorks = await tractorsWorkService.getTractorWorksByCustomerId(event.customerId);
        emit(TractorsWorkLoaded(tractorsWorks));
      } catch (e) {
        emit(TractorsWorkError("Failed to fetch works: ${e.toString()}"));
      }
    });

    on<DeleteTractorsWorkEvent>((event, emit) async {
      emit(TractorsWorkLoading());
      try {
        await tractorsWorkService.deleteTractorWork(event.id);
        emit(TractorsWorkOperationSuccess("Work deleted successfully"));
        final tractorsWorks = await tractorsWorkService.getAllTractorWorks();
        emit(TractorsWorkLoaded(tractorsWorks));
      } catch (e) {
        emit(TractorsWorkError("Failed to delete work: ${e.toString()}"));
      }
    });

    on<GetAllCustomersEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customers = await tractorsWorkService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(CustomerError("Failed to fetch customers: ${e.toString()}"));
      }
    });
  }
}