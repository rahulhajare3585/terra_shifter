import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:terra_shifter/data/models/users.dart';
import 'package:terra_shifter/presentation/blocs/register/register_bloc.dart';
import 'package:terra_shifter/presentation/blocs/register/register_event.dart';
import 'package:terra_shifter/presentation/blocs/register/register_state.dart';
import 'package:terra_shifter/presentation/pages/authentication/login_page.dart';
import 'package:terra_shifter/core/usecases/app_localization.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Logo
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          // Card Content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    color: Colors.white.withOpacity(0.8), // Transparent card
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                    elevation: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                localizations?.translate('register') ?? "Register",
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Form Fields
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('full_name') ??
                                        "Full Name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.person),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('email_address') ??
                                        "Email Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('password') ??
                                        "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('confirm_password') ??
                                        "Confirm Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.lock),
                              ),
                            ),
                            const SizedBox(height: 12),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText:
                                        localizations?.translate('date_of_birth') ??
                                            'Date of Birth',
                                    hintText:
                                        "${_selectedDate.toLocal()}".split(' ')[0],
                                    border: const OutlineInputBorder(),
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: contactController,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('contact_number') ??
                                        "Contact Number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: addressController,
                              decoration: InputDecoration(
                                labelText:
                                    localizations?.translate('address') ??
                                        "Address",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.home),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final user = Users(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    dateOfBirth: _selectedDate,
                                    contactNumber: contactController.text,
                                    address: addressController.text,
                                  );
                                  context
                                      .read<RegisterBloc>()
                                      .add(RegisterUserEvent(user));
                                },
                                label: Text(
                                  localizations?.translate('register') ??
                                      "Register",
                                  style: TextStyle(
                                      color:
                                          theme.textTheme.bodySmall?.color),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                ),
                                icon: const Icon(Icons.person_add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
