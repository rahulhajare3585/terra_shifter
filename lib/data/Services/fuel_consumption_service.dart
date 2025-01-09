import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';

class FuelConsumptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new fuel consumption entry
  Future<void> addFuelConsumption(FuelConsumption fuelConsumption) async {
    try {
      await _firestore
          .collection('fuel_consumptions')
          .doc(fuelConsumption.id)
          .set(fuelConsumption.toMap());
      print("Fuel consumption added successfully!");
    } catch (e) {
      print("Error adding fuel consumption: $e");
    }
  }

  // Read or fetch a fuel consumption entry by id
  Future<FuelConsumption?> getFuelConsumption(String id) async {
    try {
      final docSnapshot =
          await _firestore.collection('fuel_consumptions').doc(id).get();
      if (docSnapshot.exists) {
        return FuelConsumption.fromMap(docSnapshot.data()!);
      }
      return null;
    } catch (e) {
      print("Error fetching fuel consumption: $e");
      return null;
    }
  }

  // Update an existing fuel consumption entry
  Future<void> updateFuelConsumption(FuelConsumption fuelConsumption) async {
    try {
      await _firestore
          .collection('fuel_consumptions')
          .doc(fuelConsumption.id)
          .update(fuelConsumption.toMap());
      print("Fuel consumption updated successfully!");
    } catch (e) {
      print("Error updating fuel consumption: $e");
    }
  }

  // Delete a fuel consumption entry by id
  Future<void> deleteFuelConsumption(String id) async {
    try {
      await _firestore.collection('fuel_consumptions').doc(id).delete();
      print("Fuel consumption deleted successfully!");
    } catch (e) {
      print("Error deleting fuel consumption: $e");
    }
  }

  // Fetch all fuel consumption entries
  Future<List<FuelConsumption>> getAllFuelConsumptions() async {
    try {
      final querySnapshot = await _firestore.collection('fuel_consumptions').get();
      return querySnapshot.docs
          .map((doc) => FuelConsumption.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print("Error fetching fuel consumptions: $e");
      return [];
    }
  }
}