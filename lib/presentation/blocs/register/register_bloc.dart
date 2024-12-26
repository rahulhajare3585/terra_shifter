import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/user_service.dart';

import 'package:terra_shifter/presentation/blocs/register/register_event.dart';
import 'package:terra_shifter/presentation/blocs/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterService registerService;

  RegisterBloc(this.registerService) : super(RegisterInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        // Call register service to register user
        await registerService.registerUser(event.user);
        emit(RegisterSuccess("User registered successfully"));
      } catch (e) {
        emit(RegisterError("Failed to register user: ${e.toString()}"));
      }
    });

    on<GetUserEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        final user = await registerService.getUser(event.id);
        if (user != null) {
          emit(RegisterLoaded(user));
        } else {
          emit(RegisterError("User not found"));
        }
      } catch (e) {
        emit(RegisterError("Failed to fetch user: ${e.toString()}"));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(RegisterLoading());
      try {
        await registerService.updateUser(event.user);
        emit(RegisterSuccess("User updated successfully"));
      } catch (e) {
        emit(RegisterError("Failed to update user: ${e.toString()}"));
      }
    });
  }
}
