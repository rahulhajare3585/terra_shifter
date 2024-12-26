import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/plates_service.dart';
import 'package:terra_shifter/data/models/plates.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_event.dart';
import 'package:terra_shifter/presentation/blocs/plates/plates_state.dart';

class PlatesBloc extends Bloc<PlatesEvent, PlatesState> {
  final PlatesService platesService;

  PlatesBloc(this.platesService) : super(PlatesInitial()) {
    on<AddPlateEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        await platesService.addPlate(event.plate);
        emit(PlatesOperationSuccess("Plate added successfully"));
        final plates = await platesService.getAllPlates();
        emit(PlatesLoaded(plates));
        emit(PlatesOperationSuccess("Plate added successfully"));
      } catch (e) {
        emit(PlatesError("Failed to add plate: ${e.toString()}"));
      }
    });

    on<GetPlateEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        final plate = await platesService.getPlate(event.id);
        if (plate != null) {
          emit(PlatesLoaded([plate]));
        } else {
          emit(PlatesError("Plate not found"));
        }
      } catch (e) {
        emit(PlatesError("Failed to fetch plate: ${e.toString()}"));
      }
    });

    on<GetAllPlatesEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        final plates = await platesService.getAllPlates();
        emit(PlatesLoaded(plates));
      } catch (e) {
        emit(PlatesError("Failed to fetch plates: ${e.toString()}"));
      }
    });

    on<UpdatePlateEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        await platesService.updatePlate(event.plate);
        emit(PlatesOperationSuccess("Plate updated successfully"));
        final plates = await platesService.getAllPlates();
        emit(PlatesLoaded(plates));
        PlatesOperationSuccess("Plate updated successfully");
      } catch (e) {
        emit(PlatesError("Failed to update plate: ${e.toString()}"));
      }
    });

    on<DeletePlateEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        await platesService.deletePlate(event.id);
        emit(PlatesOperationSuccess("Plate deleted successfully"));
        final plates = await platesService.getAllPlates();
        emit(PlatesLoaded(plates));
      } catch (e) {
        emit(PlatesError("Failed to delete plate: ${e.toString()}"));
      }
    });
  }
}