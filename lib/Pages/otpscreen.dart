import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terra_shifter/Pages/home_screen.dart';

class Otpscreen extends StatefulWidget {
  String verificationId;
  Otpscreen({super.key, required this.verificationId});
  @override
  State<Otpscreen> createState() => _PhoneAuth();
}

class _PhoneAuth extends State<Otpscreen> {
  var otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Otp'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: 'Enter the otp',
                  suffixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24))),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential =
                      await PhoneAuthProvider.credential(
                          verificationId: widget.verificationId,
                          smsCode: otpController.text.toString());
                  FirebaseAuth.instance
                      .signInWithCredential(credential)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  });
                } catch (ex) {
                  print('Exception $ex');
                }
              },
              child: const Text('Verify')),
        ],
      ),
    );
  }
}
