import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/plates_master.dart';

class PlatesManageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new plate master
  Future<void> addPlateMaster(PlatesMaster plateMaster) async {
    try {
      // Check if the plate master with the given id already exists
      final docSnapshot =
          await _firestore.collection('plates_master').doc(plateMaster.id.toString()).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('plates_master')
            .doc(plateMaster.id.toString())
            .set(plateMaster.toMap());
        print("Plate master added successfully!");
      } else {
        print("Plate master with id ${plateMaster.id} already exists.");
      }
    } catch (e) {
      print("Error adding plate master: $e");
    }
  }

  // Read or fetch a plate master by id
  Future<PlatesMaster?> getPlateMaster(int id) async {
    try {
      final docSnapshot =
          await _firestore.collection('plates_master').doc(id.toString()).get();
      if (docSnapshot.exists) {
        return PlatesMaster.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching plate master: $e");
      return null;
    }
  }

  // Update an existing plate master
  Future<void> updatePlateMaster(PlatesMaster plateMaster) async {
    try {
      await _firestore
          .collection('plates_master')
          .doc(plateMaster.id.toString())
          .update(plateMaster.toMap());
      print("Plate master updated successfully!");
    } catch (e) {
      print("Error updating plate master: $e");
    }
  }

  // Delete a plate master by id
  Future<void> deletePlateMaster(int id) async {
    try {
      await _firestore.collection('plates_master').doc(id.toString()).delete();
      print("Plate master deleted successfully!");
    } catch (e) {
      print("Error deleting plate master: $e");
    }
  }

  // Fetch all plate masters
  Future<List<PlatesMaster>> getAllPlateMasters() async {
    try {
      final querySnapshot = await _firestore.collection('plates_master').get();
      return querySnapshot.docs
          .map((doc) => PlatesMaster.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching plate masters: $e");
      return [];
    }
  }

  // Fetch plate masters by customerId
  Future<List<PlatesMaster>> getPlateMastersByCustomerId(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('plates_master')
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => PlatesMaster.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching plate masters by customerId: $e");
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