import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/plates.dart';

class PlatesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new plate
  Future<void> addPlate(Plates plate) async {
    try {
      // Check if the plate with the given id already exists
      final docSnapshot =
          await _firestore.collection('plates').doc(plate.id).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('plates')
            .doc(plate.id)
            .set(plate.toMap());
        print("Plate added successfully!");
      } else {
        print("Plate with id ${plate.id} already exists.");
      }
    } catch (e) {
      print("Error adding plate: $e");
    }
  }

  // Read or fetch a plate by id
  Future<Plates?> getPlate(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('plates').doc(id).get();
      if (docSnapshot.exists) {
        return Plates.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching plate: $e");
      return null;
    }
  }

  // Update an existing plate
  Future<void> updatePlate(Plates plate) async {
    try {
      await _firestore
          .collection('plates')
          .doc(plate.id)
          .update(plate.toMap());
      print("Plate updated successfully!");
    } catch (e) {
      print("Error updating plate: $e");
    }
  }

  // Delete a plate by id
  Future<void> deletePlate(String id) async {
    try {
      await _firestore.collection('plates').doc(id).delete();
      print("Plate deleted successfully!");
    } catch (e) {
      print("Error deleting plate: $e");
    }
  }

  // Fetch all plates
  Future<List<Plates>> getAllPlates() async {
    try {
      final querySnapshot = await _firestore.collection('plates').get();
      return querySnapshot.docs
          .map((doc) => Plates.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching plates: $e");
      return [];
    }
  }

  // Fetch all customers
  Future<List<Customer>> getAllCustomers() async {
    try {
      final querySnapshot = await _firestore.collection('customers').get();
      return querySnapshot.docs
          .map((doc) => Customer.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching customers: $e");
      return [];
    }
  }
}