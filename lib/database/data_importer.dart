import '../models/medication.dart';
import 'database_helper.dart';
import 'json_parser.dart';

class DataImporter {
  static final DataImporter _instance = DataImporter._internal();
  factory DataImporter() => _instance;
  DataImporter._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final JSONParser _jsonParser = JSONParser();

  // Import medication data from list
  Future<void> importMedications(List<Medication> medications) async {
    await _dbHelper.importMedications(medications);
  }


  // Import data from JSON asset
  Future<void> importFromJSONAsset(String assetPath) async {
    final medications = await _jsonParser.parseFromAsset(assetPath);
    if (medications.isNotEmpty) {
      await importMedications(medications);
    }
  }

  // Import data from JSON string
  Future<void> importFromJSONString(String jsonString) async {
    final medications = _jsonParser.parseFromString(jsonString);
    if (medications.isNotEmpty) {
      await importMedications(medications);
    }
  }


  // Check and import data if needed
  Future<void> ensureDataLoaded() async {
    final count = await _dbHelper.getMedicationCount();
    
    // Check if we need to verify dosage forms are properly loaded
    if (count > 0) {
      // Test a few medications to see if they have dosageForms
      try {
        final testMeds = await _dbHelper.searchMedications('Absorica');
        if (testMeds.isNotEmpty && testMeds.first.dosageForms.isEmpty) {
          // missing dosage forms -> reload
          await forceReloadData();
          return;
        }
      } catch (e) {
        // ignore
      }
      return;
    }
    
    if (count == 0) {
      // import from the latest JSON
      await importFromJSONAsset('assets/data/medications_flutter_format.json');
      await _dbHelper.getMedicationCount();
    }
  }
  
  // Force reload data from JSON (delete old data and reimport)
  Future<void> forceReloadData() async {
    // reload from JSON
    await _dbHelper.deleteAllMedications();
    
    await importFromJSONAsset('assets/data/medications_flutter_format.json');
    await _dbHelper.getMedicationCount();
  }

}
