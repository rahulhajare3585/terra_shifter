// services/customer_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    try {
      // Check if the customer with the given id already exists
      final docSnapshot =
          await _firestore.collection('customers').doc(customer.id).get();

      if (!docSnapshot.exists) {
        await _firestore
            .collection('customers')
            .doc(customer.id)
            .set(customer.toMap());
        print("Customer added successfully!");
      } else {
        print("Customer with id ${customer.id} already exists.");
      }
    } catch (e) {
      print("Error adding customer: $e");
    }
  }

  // Read or fetch a customer by id
  Future<Customer?> getCustomer(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('customers').doc(id).get();
      if (docSnapshot.exists) {
        return Customer.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching customer: $e");
      return null;
    }
  }

  // Update an existing customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.id)
          .update(customer.toMap());
      print("Customer updated successfully!");
    } catch (e) {
      print("Error updating customer: $e");
    }
  }

  // Delete a customer by id
  Future<void> deleteCustomer(String id) async {
    try {
      await _firestore.collection('customers').doc(id).delete();
      print("Customer deleted successfully!");
    } catch (e) {
      print("Error deleting customer: $e");
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
