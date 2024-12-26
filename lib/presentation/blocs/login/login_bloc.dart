import 'package:bloc/bloc.dart';
import 'package:terra_shifter/data/Services/login_service.dart';
import 'package:terra_shifter/presentation/blocs/login/login_event.dart';
import 'package:terra_shifter/presentation/blocs/login/login_state.dart';
import 'package:terra_shifter/data/services/user_service.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginService loginService;

  LoginBloc(this.loginService) : super(LoginInitial()) {
    // Handle login event
    on<LoginUserEvent>((event, emit) async {
      emit(LoginLoading());
      
      // Validate email and password
      if (_isValidEmail(event.email) && _isValidPassword(event.password)) {
        try {
          final user = await loginService.getUser(event.email, event.password);
          if (user != null && user.password == event.password) {
            emit(LoginSuccess(user,"User logged in successfully"));
          } else {
            emit(LoginError("Invalid credentials"));
          }
        } catch (e) {
          emit(LoginError("Login failed: ${e.toString()}"));
        }
      } else {
        emit(LoginError("Invalid email or password format"));
      }
    });

    // Handle logout event
    on<LogoutUserEvent>((event, emit) async {
      try {
        await loginService.logoutUser();
        emit(LogoutSuccess("User logged out successfully"));
      } catch (e) {
        emit(LoginError("Logout failed: ${e.toString()}"));
      }
    });

    // Handle fetching logged-in user event
    on<GetLoggedInUserEvent>((event, emit) async {
      try {
        final user = await loginService.getLoggedInUser();
        if (user != null) {
          emit(GetLoggedInUserSuccess(user));
        } else {
          emit(LoginError("No user is logged in"));
        }
      } catch (e) {
        emit(LoginError("Failed to get logged-in user: ${e.toString()}"));
      }
    });
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Password validation (for example, minimum 6 characters)
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
