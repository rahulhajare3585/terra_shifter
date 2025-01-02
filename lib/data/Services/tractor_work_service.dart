import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

class TractorsWorkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new tractor work
  Future<void> addTractorWork(TractorsWork tractorsWork) async {
    try {
      // Check if the work with the given id already exists
      final docSnapshot =
          await _firestore.collection('tractors_work').doc(tractorsWork.id).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('tractors_work')
            .doc(tractorsWork.id)
            .set(tractorsWork.toJson());
        print("Tractor work added successfully!");
      } else {
        print("Tractor work with id ${tractorsWork.id} already exists.");
      }
    } catch (e) {
      print("Error adding tractor work: $e");
    }
  }

  // Read or fetch a tractor work by id
  Future<TractorsWork?> getTractorWork(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('tractors_work').doc(id).get();
      if (docSnapshot.exists) {
        return TractorsWork.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching tractor work: $e");
      return null;
    }
  }

  // Update an existing tractor work
  Future<void> updateTractorWork(TractorsWork tractorsWork) async {
    try {
      await _firestore
          .collection('tractors_work')
          .doc(tractorsWork.id)
          .update(tractorsWork.toJson());
      print("Tractor work updated successfully!");
    } catch (e) {
      print("Error updating tractor work: $e");
    }
  }

  // Delete a tractor work by id
  Future<void> deleteTractorWork(String id) async {
    try {
      await _firestore.collection('tractors_work').doc(id).delete();
      print("Tractor work deleted successfully!");
    } catch (e) {
      print("Error deleting tractor work: $e");
    }
  }

  // Fetch all tractor works
  Future<List<TractorsWork>> getAllTractorWorks() async {
    try {
      final querySnapshot = await _firestore.collection('tractors_work').get();
      return querySnapshot.docs
          .map((doc) => TractorsWork.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching tractor works: $e");
      return [];
    }
  }

  // Fetch tractor works by customer id
  Future<List<TractorsWork>> getTractorWorksByCustomerId(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('tractors_work')
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => TractorsWork.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching tractor works by customer id: $e");
      return [];
    }
  }

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