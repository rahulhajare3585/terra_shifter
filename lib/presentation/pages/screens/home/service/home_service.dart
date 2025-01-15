import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:terra_shifter/data/models/fuel_consumption.dart';
import 'package:terra_shifter/data/models/jcb_work.dart';
import 'package:terra_shifter/data/models/tractors_work.dart';
import 'package:terra_shifter/presentation/pages/screens/plates/model/plates.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all fuel consumptions
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
}