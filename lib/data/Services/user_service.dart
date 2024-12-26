import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/users.dart';

class RegisterService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new user
  Future<void> registerUser(Users user) async {
    try {
      // Check if the user with the given email already exists
      final querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await _firestore
            .collection('users')
            .doc(user.email) // Using email as the document ID
            .set(user.toMap());
        print("User registered successfully!");
      } else {
        print("User with email ${user.email} already exists.");
      }
    } catch (e) {
      print("Error registering user: $e");
    }
  }

  // Read or fetch a user by email
  Future<Users?> getUser(String email) async {
    try {
      final docSnapshot =
          await _firestore.collection('users').doc(email).get();
      if (docSnapshot.exists) {
        return Users.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  // Update an existing user
  Future<void> updateUser(Users user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.email) // Using email as the document ID
          .update(user.toMap());
      print("User updated successfully!");
    } catch (e) {
      print("Error updating user: $e");
    }
  }

  // Delete a user by email
  Future<void> deleteUser(String email) async {
    try {
      await _firestore.collection('users').doc(email).delete();
      print("User deleted successfully!");
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Fetch all users
  Future<List<Users>> getAllUsers() async {
    try {
      final querySnapshot = await _firestore.collection('users').get();
      return querySnapshot.docs
          .map((doc) => Users.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }
}
