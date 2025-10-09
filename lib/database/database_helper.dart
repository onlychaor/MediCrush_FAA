import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medication.dart';
import '../models/dosage_form.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'medications.db');
    return     await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medications (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        generic_name TEXT NOT NULL,
        category TEXT NOT NULL,
        description TEXT NOT NULL,
        dosage TEXT NOT NULL,
        side_effects TEXT NOT NULL,
        contraindications TEXT NOT NULL,
        manufacturer TEXT NOT NULL,
        form TEXT,
        alteration TEXT,
        reference TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE dosage_forms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        medication_id TEXT NOT NULL,
        form TEXT NOT NULL,
        alteration TEXT NOT NULL,
        reference TEXT NOT NULL,
        FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for optimized searching
    await db.execute('''
      CREATE INDEX idx_medications_name ON medications(name)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_medications_generic_name ON medications(generic_name)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_medications_category ON medications(category)
    ''');

    // Insert dữ liệu mẫu
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Thêm bảng dosage_forms
      await db.execute('''
        CREATE TABLE dosage_forms (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          medication_id TEXT NOT NULL,
          form TEXT NOT NULL,
          alteration TEXT NOT NULL,
          reference TEXT NOT NULL,
          FOREIGN KEY (medication_id) REFERENCES medications (id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleMedications = Medication.getSampleMedications();
    
    for (final medication in sampleMedications) {
      await db.insert('medications', {
        'id': medication.id,
        'name': medication.name,
        'generic_name': medication.genericName,
        'category': medication.category,
        'description': medication.description,
        'dosage': medication.dosage,
        'side_effects': medication.sideEffects.join('|'),
        'contraindications': medication.contraindications.join('|'),
        'manufacturer': medication.manufacturer,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  // Add new medication
  Future<int> insertMedication(Medication medication) async {
    final db = await database;
    
    final result = await db.insert('medications', {
      'id': medication.id,
      'name': medication.name,
      'generic_name': medication.genericName,
      'category': medication.category,
      'description': medication.description,
      'dosage': medication.dosage,
      'side_effects': medication.sideEffects.join('|'),
      'contraindications': medication.contraindications.join('|'),
      'manufacturer': medication.manufacturer,
      'form': medication.form,
      'alteration': medication.alteration,
      'reference': medication.reference,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });
    
    // Thêm dosage forms
    for (final dosageForm in medication.dosageForms) {
      await db.insert('dosage_forms', {
        'medication_id': medication.id,
        'form': dosageForm.form,
        'alteration': dosageForm.alteration,
        'reference': dosageForm.reference,
      });
    }
    
    return result;
  }

  // Get all medications
  Future<List<Medication>> getAllMedications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('medications');
    return await Future.wait(maps.map((map) => _mapToMedicationWithDosageForms(map)));
  }

  // Search medications
  Future<List<Medication>> searchMedications(String query) async {
    if (query.trim().isEmpty) {
      return getAllMedications();
    }

    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: '''
        name LIKE ? OR 
        generic_name LIKE ? OR 
        category LIKE ? OR
        description LIKE ?
      ''',
      whereArgs: ['%$query%', '%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    
    return await Future.wait(maps.map((map) => _mapToMedicationWithDosageForms(map)));
  }

  // Tìm kiếm nâng cao với ranking
  Future<List<Medication>> searchMedicationsAdvanced(String query) async {
    if (query.trim().isEmpty) {
      return getAllMedications();
    }

    final db = await database;
    final lowerQuery = query.toLowerCase();
    
    print('🔍 Database search for: "$query"');
    print('🔍 Lower query: "$lowerQuery"');
    
    // Tìm kiếm với ranking: tên chính xác > tên bắt đầu > tên chứa > generic > category
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT *, 
        CASE 
          WHEN LOWER(name) = ? THEN 1
          WHEN LOWER(name) LIKE ? THEN 2
          WHEN LOWER(name) LIKE ? THEN 3
          WHEN LOWER(generic_name) LIKE ? THEN 4
          WHEN LOWER(category) LIKE ? THEN 5
          WHEN LOWER(description) LIKE ? THEN 6
          ELSE 7
        END as rank
      FROM medications 
      WHERE LOWER(name) LIKE ? OR 
            LOWER(generic_name) LIKE ? OR 
            LOWER(category) LIKE ? OR
            LOWER(description) LIKE ?
      ORDER BY rank ASC, name ASC
    ''', [
      lowerQuery,                    // rank 1: exact match
      '$lowerQuery%',               // rank 2: starts with
      '%$lowerQuery%',              // rank 3: contains
      '%$lowerQuery%',              // rank 4: generic name
      '%$lowerQuery%',              // rank 5: category
      '%$lowerQuery%',              // rank 6: description
      '%$lowerQuery%',              // where conditions
      '%$lowerQuery%',
      '%$lowerQuery%',
      '%$lowerQuery%',
    ]);
    
    print('🔍 Raw query results: ${maps.length} rows');
    if (maps.isNotEmpty) {
      print('🔍 First result: ${maps.first['name']}');
    }
    
    return await Future.wait(maps.map((map) => _mapToMedicationWithDosageForms(map)));
  }

  // Get medications by category
  Future<List<Medication>> getMedicationsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
    );
    
    return List.generate(maps.length, (i) => _mapToMedication(maps[i]));
  }

  // Lấy tất cả danh mục
  Future<List<String>> getAllCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT category FROM medications ORDER BY category ASC'
    );
    
    return maps.map((map) => map['category'] as String).toList();
  }

  // Get medication by ID
  Future<Medication?> getMedicationById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isNotEmpty) {
      return await _mapToMedicationWithDosageForms(maps.first);
    }
    return null;
  }

  // Update medication
  Future<int> updateMedication(Medication medication) async {
    final db = await database;
    return await db.update(
      'medications',
      {
        'name': medication.name,
        'generic_name': medication.genericName,
        'category': medication.category,
        'description': medication.description,
        'dosage': medication.dosage,
        'side_effects': medication.sideEffects.join('|'),
        'contraindications': medication.contraindications.join('|'),
        'manufacturer': medication.manufacturer,
        'form': medication.form,
        'alteration': medication.alteration,
        'reference': medication.reference,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [medication.id],
    );
  }

  // Delete medication
  Future<int> deleteMedication(String id) async {
    final db = await database;
    return await db.delete(
      'medications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete all medications
  Future<int> deleteAllMedications() async {
    final db = await database;
    // Delete dosage_forms first (foreign key constraint)
    await db.delete('dosage_forms');
    return await db.delete('medications');
  }

  // Count medications
  Future<int> getMedicationCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM medications');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Import dữ liệu từ danh sách
  Future<void> importMedications(List<Medication> medications) async {
    final db = await database;
    
    await db.transaction((txn) async {
      for (final medication in medications) {
        // Insert medication
        await txn.insert('medications', {
          'id': medication.id,
          'name': medication.name,
          'generic_name': medication.genericName,
          'category': medication.category,
          'description': medication.description,
          'dosage': medication.dosage,
          'side_effects': medication.sideEffects.join('|'),
          'contraindications': medication.contraindications.join('|'),
          'manufacturer': medication.manufacturer,
          'form': medication.form,
          'alteration': medication.alteration,
          'reference': medication.reference,
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
        
        // Insert dosage forms
        for (final dosageForm in medication.dosageForms) {
          await txn.insert('dosage_forms', {
            'medication_id': medication.id,
            'form': dosageForm.form,
            'alteration': dosageForm.alteration,
            'reference': dosageForm.reference,
          });
        }
      }
    });
  }

  // Chuyển đổi Map thành Medication object với dosageForms
  Future<Medication> _mapToMedicationWithDosageForms(Map<String, dynamic> map) async {
    final db = await database;
    final dosageFormsMaps = await db.query(
      'dosage_forms',
      where: 'medication_id = ?',
      whereArgs: [map['id']],
    );
    
    final dosageForms = dosageFormsMaps.map((dfMap) => DosageForm(
      form: dfMap['form'] as String,
      alteration: dfMap['alteration'] as String,
      reference: dfMap['reference'] as String,
    )).toList();
    
    return Medication(
      id: map['id'],
      name: map['name'],
      genericName: map['generic_name'],
      category: map['category'],
      description: map['description'],
      dosage: map['dosage'],
      sideEffects: (map['side_effects'] as String).split('|'),
      contraindications: (map['contraindications'] as String).split('|'),
      manufacturer: map['manufacturer'],
      form: map['form'] ?? '',
      alteration: map['alteration'] ?? '',
      reference: map['reference'] ?? '',
      dosageForms: dosageForms,
    );
  }

  // Chuyển đổi Map thành Medication object (backward compatibility)
  Medication _mapToMedication(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      genericName: map['generic_name'],
      category: map['category'],
      description: map['description'],
      dosage: map['dosage'],
      sideEffects: (map['side_effects'] as String).split('|'),
      contraindications: (map['contraindications'] as String).split('|'),
      manufacturer: map['manufacturer'],
      form: map['form'] ?? '',
      alteration: map['alteration'] ?? '',
      reference: map['reference'] ?? '',
      dosageForms: [],
    );
  }

  // Đóng database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
