import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:terra_shifter/data/models/users.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Users?> getUser(String email, String password) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(email).get();
      if (docSnapshot.exists) {
        return Users.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Log in a user with email and password
  Future<Users?> loginUser(String email, String password) async {
    try {
      // Fetch user details from Firestore
      final docSnapshot = await _firestore.collection('users').doc(email).get();

      // Check if the user exists in Firestore
      if (docSnapshot.exists) {
        Users user = Users.fromMap(docSnapshot.data()!);

        // Verify the password (assuming password is stored as plain text, which is insecure)
        if (user.password == password) {
          return user;
        } else {
          print("Invalid password");
          return null;
        }
      } else {
        print("User not found in Firestore");
        return null;
      }
    } on FirebaseAuthException catch (e) {
      print("Error logging in: ${e.message}");
      return null;
    }
  }

  // Log out the current user
  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
      print("User logged out successfully!");
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  // Get the currently logged-in user
  Future<Users?> getLoggedInUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot = await _firestore.collection('users').doc(user.email).get();
        if (docSnapshot.exists) {
          return Users.fromMap(docSnapshot.data()!);
        }
      }
      return null;
    } catch (e) {
      print("Error fetching logged-in user: $e");
      return null;
    }
  }

  // Check if the user is already logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }
}