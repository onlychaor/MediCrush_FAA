import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/medication.dart';

class JSONParser {
  static final JSONParser _instance = JSONParser._internal();
  factory JSONParser() => _instance;
  JSONParser._internal();

  // Parse JSON từ asset
  Future<List<Medication>> parseFromAsset(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      return _parseJSONString(jsonString);
    } catch (e) {
      print('Error loading JSON from asset: $e');
      return [];
    }
  }

  // Parse JSON từ string
  List<Medication> parseFromString(String jsonString) {
    return _parseJSONString(jsonString);
  }

  List<Medication> _parseJSONString(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> medicationsJson = jsonData['medications'] ?? [];
      
      return medicationsJson.map((json) => _parseMedication(json)).toList();
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  }

  Medication _parseMedication(Map<String, dynamic> json) {
    return Medication(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      genericName: json['generic_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      dosage: json['dosage']?.toString() ?? '',
      sideEffects: _parseStringList(json['side_effects']),
      contraindications: _parseStringList(json['contraindications']),
      manufacturer: json['manufacturer']?.toString() ?? '',
    );
  }

  List<String> _parseStringList(dynamic data) {
    if (data == null) return [];
    if (data is List) {
      return data.map((item) => item.toString()).toList();
    }
    return [];
  }

  // Export dữ liệu ra JSON
  String exportToJSON(List<Medication> medications) {
    final Map<String, dynamic> jsonData = {
      'medications': medications.map((med) => _medicationToJson(med)).toList(),
    };
    
    return const JsonEncoder.withIndent('  ').convert(jsonData);
  }

  Map<String, dynamic> _medicationToJson(Medication medication) {
    return {
      'id': medication.id,
      'name': medication.name,
      'generic_name': medication.genericName,
      'category': medication.category,
      'description': medication.description,
      'dosage': medication.dosage,
      'side_effects': medication.sideEffects,
      'contraindications': medication.contraindications,
      'manufacturer': medication.manufacturer,
    };
  }

  // Tạo template JSON
  String generateTemplate() {
    return const JsonEncoder.withIndent('  ').convert({
      'medications': [
        {
          'id': '1',
          'name': 'Tên thuốc',
          'generic_name': 'Tên generic',
          'category': 'Danh mục',
          'description': 'Mô tả thuốc',
          'dosage': 'Liều dùng',
          'side_effects': ['Tác dụng phụ 1', 'Tác dụng phụ 2'],
          'contraindications': ['Chống chỉ định 1', 'Chống chỉ định 2'],
          'manufacturer': 'Nhà sản xuất'
        }
      ]
    });
  }
}
