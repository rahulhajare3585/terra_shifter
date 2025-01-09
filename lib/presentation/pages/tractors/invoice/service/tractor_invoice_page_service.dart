import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/customer.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';

class TractorInvoicePageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all tractor works related to a customer ID
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

  // Fetch a particular customer by ID
  Future<Customer?> getCustomerById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('customers').doc(id).get();
      if (docSnapshot.exists) {
        return Customer.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching customer: $e");
      return null;
    }
  }
}