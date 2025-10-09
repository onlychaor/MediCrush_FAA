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
    try {
      await _dbHelper.importMedications(medications);
      print('✅ Imported ${medications.length} medications successfully');
    } catch (e) {
      print('❌ Error importing medications: $e');
      rethrow;
    }
  }


  // Import data from JSON asset
  Future<void> importFromJSONAsset(String assetPath) async {
    try {
      final medications = await _jsonParser.parseFromAsset(assetPath);
      if (medications.isNotEmpty) {
        await importMedications(medications);
        print('✅ Imported ${medications.length} medications from JSON asset');
      } else {
        print('⚠️ No medications found in JSON asset');
      }
    } catch (e) {
      print('❌ Error importing from JSON asset: $e');
      rethrow;
    }
  }

  // Import data from JSON string
  Future<void> importFromJSONString(String jsonString) async {
    try {
      final medications = _jsonParser.parseFromString(jsonString);
      if (medications.isNotEmpty) {
        await importMedications(medications);
        print('✅ Imported ${medications.length} medications from JSON string');
      } else {
        print('⚠️ No medications found in JSON string');
      }
    } catch (e) {
      print('❌ Error importing from JSON string: $e');
      rethrow;
    }
  }


  // Check and import data if needed
  Future<void> ensureDataLoaded() async {
    final count = await _dbHelper.getMedicationCount();
    print('📊 Current medication count in database: $count');
    
    // Check if we need to verify dosage forms are properly loaded
    if (count > 0) {
      // Test a few medications to see if they have dosageForms
      try {
        final testMeds = await _dbHelper.searchMedications('Absorica');
        if (testMeds.isNotEmpty && testMeds.first.dosageForms.isEmpty) {
          print('⚠️ Database has medications but missing dosage forms. Reloading...');
          await forceReloadData();
          return;
        }
      } catch (e) {
        print('⚠️ Error checking dosage forms: $e');
      }
      print('✅ Database already has $count medications loaded with dosage forms');
      return;
    }
    
    if (count == 0) {
      print('🔄 Database is empty, importing data...');
      // Try importing from the latest JSON first
      try {
        print('📥 Attempting to import from medications_flutter_format.json...');
        await importFromJSONAsset('assets/data/medications_flutter_format.json');
        final newCount = await _dbHelper.getMedicationCount();
        print('✅ Successfully imported $newCount medications from Flutter format JSON');
      } catch (e) {
        print('⚠️ Flutter format JSON not found, trying unique JSON: $e');
        try {
          print('📥 Attempting to import from medications_unique.json...');
          await importFromJSONAsset('assets/data/medications_unique.json');
          final newCount = await _dbHelper.getMedicationCount();
          print('✅ Successfully imported $newCount medications from unique JSON');
        } catch (e2) {
          print('❌ Unique JSON asset not found: $e2');
          print('⚠️ No medication data available');
        }
      }
    }
  }
  
  // Force reload data from JSON (delete old data and reimport)
  Future<void> forceReloadData() async {
    print('🔄 Force reloading data from JSON...');
    await _dbHelper.deleteAllMedications();
    print('🗑️ Deleted all existing medications');
    
    try {
      print('📥 Importing from medications_flutter_format.json...');
      await importFromJSONAsset('assets/data/medications_flutter_format.json');
    final count = await _dbHelper.getMedicationCount();
      print('✅ Successfully imported $count medications');
    } catch (e) {
      print('⚠️ Error loading Flutter format JSON: $e');
      try {
        print('📥 Importing from medications_unique.json...');
        await importFromJSONAsset('assets/data/medications_unique.json');
        final count = await _dbHelper.getMedicationCount();
        print('✅ Successfully imported $count medications');
      } catch (e2) {
        print('❌ Error loading JSON files: $e2');
        rethrow;
      }
    }
  }

}
