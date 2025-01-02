import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/plates_manage_service.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_manage_event.dart';
import 'package:terra_shifter/presentation/blocs/plates_manage/plates_managee_state.dart';

class PlatesManageBloc extends Bloc<PlatesManageEvent, PlatesManageState> {
  final PlatesManageService platesManageService;

  PlatesManageBloc(this.platesManageService) : super(PlatesManageInitial()) {
    on<AddPlateMasterEvent>((event, emit) async {
      emit(PlatesManageLoading());
      try {
        await platesManageService.addPlateMaster(event.plateMaster);
        emit(PlatesManageOperationSuccess("Plate master added successfully"));
        final platesMasters = await platesManageService.getAllPlateMasters();
        emit(PlatesManageLoaded(platesMasters));
      } catch (e) {
        emit(PlatesManageError("Failed to add plate master: ${e.toString()}"));
      }
    });
    
    on<GetAllCustomersEvent>((event, emit) async {
      emit(CustomerLoading());
      try {
        final customers = await platesManageService.getAllCustomers();
        emit(CustomerLoaded(customers));
      } catch (e) {
        emit(PlatesManageError("Failed to fetch customers: ${e.toString()}"));
      }
    });

    on<GetPlateMasterEvent>((event, emit) async {
      emit(PlatesManageLoading());
      try {
        final plateMaster = await platesManageService.getPlateMaster(event.id);
        if (plateMaster != null) {
          emit(PlatesManageLoaded([plateMaster]));
        } else {
          emit(PlatesManageError("Plate master not found"));
        }
      } catch (e) {
        emit(PlatesManageError("Failed to fetch plate master: ${e.toString()}"));
      }
    });

    on<GetAllPlateMastersEvent>((event, emit) async {
      emit(PlatesManageLoading());
      try {
        final platesMasters = await platesManageService.getAllPlateMasters();
        emit(PlatesManageLoaded(platesMasters));
      } catch (e) {
        emit(PlatesManageError("Failed to fetch plate masters: ${e.toString()}"));
      }
    });

    on<UpdatePlateMasterEvent>((event, emit) async {
      emit(PlatesManageLoading());
      try {
        await platesManageService.updatePlateMaster(event.plateMaster);
        emit(PlatesManageOperationSuccess("Plate master updated successfully"));
        final platesMasters = await platesManageService.getAllPlateMasters();
        emit(PlatesManageLoaded(platesMasters));
      } catch (e) {
        emit(PlatesManageError("Failed to update plate master: ${e.toString()}"));
      }
    });

    on<DeletePlateMasterEvent>((event, emit) async {
      emit(PlatesManageLoading());
      try {
        await platesManageService.deletePlateMaster(event.id);
        emit(PlatesManageOperationSuccess("Plate master deleted successfully"));
        final platesMasters = await platesManageService.getAllPlateMasters();
        emit(PlatesManageLoaded(platesMasters));
      } catch (e) {
        emit(PlatesManageError("Failed to delete plate master: ${e.toString()}"));
      }
    });
  }
}