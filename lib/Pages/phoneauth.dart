import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terra_shifter/Pages/otpscreen.dart';

class Phoneauth extends StatefulWidget {
  const Phoneauth({super.key});
  @override
  State<Phoneauth> createState() => _PhoneAuth();
}

class _PhoneAuth extends State<Phoneauth> {
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PhoneAuth'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  suffixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                String contachNumber = phoneController.text.toString();
                await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException ex) {},
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Otpscreen(verificationId: verificationId)));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                    phoneNumber: '+91 $contachNumber');
              },
              child: const Text('Verify phone number')),
        ],
      ),
    );
  }
}
