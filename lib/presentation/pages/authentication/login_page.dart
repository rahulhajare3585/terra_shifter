import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/Services/user_service.dart';
import 'package:terra_shifter/presentation/blocs/login/login_bloc.dart';
import 'package:terra_shifter/presentation/blocs/login/login_event.dart';
import 'package:terra_shifter/presentation/blocs/login/login_state.dart';
import 'package:terra_shifter/presentation/blocs/register/register_bloc.dart';
import 'package:terra_shifter/presentation/pages/landing/landing_page.dart';
import 'package:terra_shifter/presentation/pages/authentication/register_page.dart';
import 'package:terra_shifter/data/Services/login_service.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _formAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocProvider(
      create: (context) => LoginBloc(LoginService()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[50],
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo or Image with animation
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -0.5),
                            end: Offset(0, 0),
                          ).animate(_animationController),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset('assets/images/logo.png'),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      // Welcome Text with animation
                      FadeTransition(
                        opacity: _logoAnimation,
                        child: Text(
                          localizations?.translate('welcome_back') ?? 'Welcome Back!',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      // Card for Inputs with slide-in animation
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - _formAnimation.value)),
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24.0),
                                  bottomRight: Radius.circular(24.0),
                                ),
                              ),
                              elevation: 8.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 50),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Email Input
                                    TextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: localizations?.translate('email_address') ?? 'Email Address',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 30.0),
                                    // Password Input
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        labelText: localizations?.translate('password') ?? 'Password',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 18.0),
                                    // Login Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          final email = _emailController.text;
                                          final password =
                                              _passwordController.text;
                                          if (email.isNotEmpty &&
                                              password.isNotEmpty) {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            // Dispatch login event
                                            context.read<LoginBloc>().add(
                                                LoginUserEvent(
                                                    email, password));
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14.0,
                                          ),
                                        ),
                                        child: _isLoading
                                            ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                localizations?.translate('login') ?? 'Login',
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: theme.textTheme
                                                      .bodySmall?.color,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    // Forgot Password Button
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          // Forgot password action
                                        },
                                        child: Text(
                                          localizations?.translate('forgot_password') ?? 'Forgot Password?',
                                          style: TextStyle(
                                              color: theme.primaryColor),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24.0),
                      // Sign Up Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            localizations?.translate('dont_have_account') ?? 'Don\'t have an account?',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => RegisterBloc(RegisterService()),
                                    child: RegisterPage(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              localizations?.translate('sign_up') ?? 'Sign Up',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}