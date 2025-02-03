import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:animate_do/animate_do.dart';
import 'package:terra_shifter/presentation/pages/authentication/login_page.dart';

class BiometricAuth extends StatefulWidget {
  @override
  _BiometricAuthState createState() => _BiometricAuthState();
}

class _BiometricAuthState extends State<BiometricAuth> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    // Delayed visibility to create fade-in effect
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            bottomRight: Radius.circular(100),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Animated Fade-in Logo
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Image.asset(
                    'assets/images/tractor.png', // Ensure this image is in assets
                    height: 100,
                  ),
                ),
                const SizedBox(height: 40),
          
                // Animated Biometric Authentication Card
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: _isVisible ? 1.0 : 0.0,
                  child: SlideInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Authenticate using',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
          
                            // Animated Biometric Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildAuthButton(
                                  icon: Icons.fingerprint,
                                  label: 'Fingerprint',
                                  onPressed: () {
                                    _authenticate('Fingerprint');
                                  },
                                ),
                                const SizedBox(width: 20),
                                _buildAuthButton(
                                  icon: Icons.face,
                                  label: 'Face ID',
                                  onPressed: () {
                                    _authenticate('Face ID');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
          
                            // "Or" with Fade-in Effect
                            FadeIn(
                              delay: const Duration(milliseconds: 400),
                              child:GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
                              },
                                child: const Text(
                                  'Sign in using credentials',
                                  style: TextStyle(
                                    fontSize: 20,
                                
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
                ),
        ),
    ),
    );
  }

  // Animated Auth Button
  Widget _buildAuthButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Bounce(
      duration: const Duration(milliseconds: 600),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(icon, size: 50, color: Theme.of(context).primaryColor),
                onPressed: onPressed,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Method to handle authentication
  void _authenticate(String method) {
    print('Authenticating with $method...');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authenticating with $method...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Method to handle fallback to password
  void _fallbackToPassword() {
    print('Fallback to password authentication...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fallback to password authentication...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
