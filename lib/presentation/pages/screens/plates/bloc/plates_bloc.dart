import 'package:bloc/bloc.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_event.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/bloc/plates_state.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/service/plates_service.dart';


class PlatesBloc extends Bloc<PlatesEvent, PlatesState> {
  final PlatesService platesService;

  PlatesBloc(this.platesService) : super(PlatesInitial()) {
    on<GetAllPlatesEvent>((event, emit) async {
      emit(PlatesLoading());
      try {
        final plates = await platesService.getAllPlates();
        emit(PlatesLoaded(plates));
      } catch (e) {
        emit(PlatesError(e.toString()));
      }
    });

    on<AddPlatesEvent>((event, emit) async {
      try {
        await platesService.addPlates(event.plates);
        emit(PlatesOperationSuccess("Plates record added successfully!"));
        add(GetAllPlatesEvent());
      } catch (e) {
        emit(PlatesError(e.toString()));
      }
    });

    on<UpdatePlatesEvent>((event, emit) async {
      try {
        await platesService.updatePlates(event.plates);
        emit(PlatesOperationSuccess("Plates record updated successfully!"));
        add(GetAllPlatesEvent());
      } catch (e) {
        emit(PlatesError(e.toString()));
      }
    });

    on<ResetPlatesEvent>((event, emit) {
      emit(PlatesInitial());
    });
  }
}