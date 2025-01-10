import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/model/plates.dart';

class PlatesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new plates record
  Future<void> addPlates(PlatesModel plates) async {
    try {
      // Check if the plates record with the given id already exists
      final docSnapshot =
          await _firestore.collection('plates').doc(plates.id.toString()).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('plates')
            .doc(plates.id.toString())
            .set(plates.toMap());
        print("Plates record added successfully!");
      } else {
        print("Plates record with id ${plates.id} already exists.");
      }
    } catch (e) {
      print("Error adding plates record: $e");
    }
  }

  // Read or fetch a plates record by id
  Future<PlatesModel?> getPlates(int id) async {
    try {
      final docSnapshot =
          await _firestore.collection('plates').doc(id.toString()).get();
      if (docSnapshot.exists) {
        return PlatesModel.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching plates record: $e");
      return null;
    }
  }

  // Update an existing plates record
  Future<void> updatePlates(PlatesModel plates) async {
    try {
      await _firestore
          .collection('plates')
          .doc(plates.id.toString())
          .update(plates.toMap());
      print("Plates record updated successfully!");
    } catch (e) {
      print("Error updating plates record: $e");
    }
  }

  // Delete a plates record by id
  Future<void> deletePlates(int id) async {
    try {
      await _firestore.collection('plates').doc(id.toString()).delete();
      print("Plates record deleted successfully!");
    } catch (e) {
      print("Error deleting plates record: $e");
    }
  }

  // Fetch all plates records
  Future<List<PlatesModel>> getAllPlates() async {
    try {
      final querySnapshot = await _firestore.collection('plates').get();
      return querySnapshot.docs
          .map((doc) => PlatesModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching plates records: $e");
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

  // Fetch plates records by customer ID
  Future<List<PlatesModel>> getPlatesByCustomerId(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('plates')
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => PlatesModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching plates records by customer ID: $e");
      return [];
    }
  }
}