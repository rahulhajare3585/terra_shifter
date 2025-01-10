import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';

class JcbWorkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new JcbWork
  Future<void> addJcbWork(JcbWork jcbWork) async {
    try {
      // Check if the JcbWork with the given id already exists
      final docSnapshot =
          await _firestore.collection('jcb_works').doc(jcbWork.id).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('jcb_works')
            .doc(jcbWork.id)
            .set(jcbWork.toJson());
        print("JcbWork added successfully!");
      } else {
        print("JcbWork with id ${jcbWork.id} already exists.");
      }
    } catch (e) {
      print("Error adding JcbWork: $e");
    }
  }

  // Read or fetch a JcbWork by id
  Future<JcbWork?> getJcbWork(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('jcb_works').doc(id).get();
      if (docSnapshot.exists) {
        return JcbWork.fromJson(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching JcbWork: $e");
      return null;
    }
  }

  // Update an existing JcbWork
  Future<void> updateJcbWork(JcbWork jcbWork) async {
    try {
      await _firestore
          .collection('jcb_works')
          .doc(jcbWork.id)
          .update(jcbWork.toJson());
      print("JcbWork updated successfully!");
    } catch (e) {
      print("Error updating JcbWork: $e");
    }
  }

  // Delete a JcbWork by id
  Future<void> deleteJcbWork(String id) async {
    try {
      await _firestore.collection('jcb_works').doc(id).delete();
      print("JcbWork deleted successfully!");
    } catch (e) {
      print("Error deleting JcbWork: $e");
    }
  }

  // Fetch all JcbWorks
  Future<List<JcbWork>> getAllJcbWorks() async {
    try {
      final querySnapshot = await _firestore.collection('jcb_works').get();
      return querySnapshot.docs
          .map((doc) => JcbWork.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching JcbWorks: $e");
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

  // Fetch JcbWorks by customerId
  Future<List<JcbWork>> getJcbWorksByCustomerId(String customerId) async {
    try {
      final querySnapshot = await _firestore
          .collection('jcb_works')
          .where('customerId', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => JcbWork.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching JcbWorks by customerId: $e");
      return [];
    }
  }
  
}