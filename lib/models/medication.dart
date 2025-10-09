import 'dosage_form.dart';

class Medication {
  final String id;
  final String name;
  final String genericName;
  final String category;
  final String description;
  final String dosage;
  final List<String> sideEffects;
  final List<String> contraindications;
  final String manufacturer;
  final String form;
  final String alteration;
  final String reference;
  final List<DosageForm> dosageForms;

  const Medication({
    required this.id,
    required this.name,
    required this.genericName,
    required this.category,
    required this.description,
    required this.dosage,
    required this.sideEffects,
    required this.contraindications,
    required this.manufacturer,
    this.form = '',
    this.alteration = '',
    this.reference = '',
    this.dosageForms = const [],
  });

  // Get sample medications (fallback)
  static List<Medication> getSampleMedications() {
    return [
      const Medication(
        id: '1',
        name: 'Paracetamol',
        genericName: 'Acetaminophen',
        category: 'Analgesic',
        description: 'Thuốc giảm đau và hạ sốt',
        dosage: '500mg - 1000mg mỗi 4-6 giờ',
        sideEffects: ['Buồn nôn', 'Phát ban', 'Tổn thương gan (nếu dùng quá liều)'],
        contraindications: ['Suy gan nặng', 'Dị ứng với paracetamol'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '2',
        name: 'Ibuprofen',
        genericName: 'Ibuprofen',
        category: 'NSAID',
        description: 'Thuốc chống viêm, giảm đau và hạ sốt',
        dosage: '200mg - 400mg mỗi 6-8 giờ',
        sideEffects: ['Đau dạ dày', 'Chóng mặt', 'Đau đầu'],
        contraindications: ['Loét dạ dày', 'Suy tim', 'Mang thai 3 tháng cuối'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '3',
        name: 'Aspirin',
        genericName: 'Acetylsalicylic acid',
        category: 'NSAID',
        description: 'Thuốc chống viêm, giảm đau và chống kết tập tiểu cầu',
        dosage: '75mg - 325mg mỗi ngày',
        sideEffects: ['Chảy máu dạ dày', 'Ù tai', 'Phát ban'],
        contraindications: ['Loét dạ dày', 'Rối loạn đông máu', 'Trẻ em dưới 16 tuổi'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '4',
        name: 'Amoxicillin',
        genericName: 'Amoxicillin',
        category: 'Antibiotic',
        description: 'Kháng sinh penicillin điều trị nhiễm khuẩn',
        dosage: '250mg - 500mg mỗi 8 giờ',
        sideEffects: ['Tiêu chảy', 'Buồn nôn', 'Phát ban'],
        contraindications: ['Dị ứng penicillin', 'Nhiễm trùng do virus'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '5',
        name: 'Omeprazole',
        genericName: 'Omeprazole',
        category: 'Proton Pump Inhibitor',
        description: 'Thuốc ức chế bơm proton điều trị loét dạ dày',
        dosage: '20mg - 40mg mỗi ngày',
        sideEffects: ['Đau đầu', 'Buồn nôn', 'Tiêu chảy'],
        contraindications: ['Dị ứng với omeprazole'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '6',
        name: 'Metformin',
        genericName: 'Metformin',
        category: 'Antidiabetic',
        description: 'Thuốc điều trị đái tháo đường type 2',
        dosage: '500mg - 2000mg mỗi ngày',
        sideEffects: ['Buồn nôn', 'Tiêu chảy', 'Vị kim loại'],
        contraindications: ['Suy thận', 'Suy gan', 'Nhiễm toan lactic'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '7',
        name: 'Lisinopril',
        genericName: 'Lisinopril',
        category: 'ACE Inhibitor',
        description: 'Thuốc điều trị tăng huyết áp và suy tim',
        dosage: '5mg - 40mg mỗi ngày',
        sideEffects: ['Ho khan', 'Chóng mặt', 'Mệt mỏi'],
        contraindications: ['Mang thai', 'Hẹp động mạch thận', 'Phù mạch'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '8',
        name: 'Atorvastatin',
        genericName: 'Atorvastatin',
        category: 'Statin',
        description: 'Thuốc giảm cholesterol và ngăn ngừa bệnh tim mạch',
        dosage: '10mg - 80mg mỗi ngày',
        sideEffects: ['Đau cơ', 'Đau đầu', 'Buồn nôn'],
        contraindications: ['Bệnh gan hoạt động', 'Mang thai', 'Cho con bú'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '9',
        name: 'Levothyroxine',
        genericName: 'Levothyroxine',
        category: 'Thyroid Hormone',
        description: 'Thuốc thay thế hormone tuyến giáp',
        dosage: '25mcg - 200mcg mỗi ngày',
        sideEffects: ['Tim đập nhanh', 'Đổ mồ hôi', 'Mất ngủ'],
        contraindications: ['Cường giáp không được điều trị', 'Nhồi máu cơ tim cấp'],
        manufacturer: 'Various',
      ),
      const Medication(
        id: '10',
        name: 'Sertraline',
        genericName: 'Sertraline',
        category: 'SSRI',
        description: 'Thuốc chống trầm cảm và lo âu',
        dosage: '50mg - 200mg mỗi ngày',
        sideEffects: ['Buồn nôn', 'Mất ngủ', 'Giảm ham muốn'],
        contraindications: ['Dùng MAOI', 'Mang thai', 'Cho con bú'],
        manufacturer: 'Various',
      ),
    ];
  }

  // Tìm kiếm mờ (fuzzy search) - giữ lại để tương thích
  bool matchesSearch(String query) {
    if (query.isEmpty) return true;
    
    final lowerQuery = query.toLowerCase();
    final lowerName = name.toLowerCase();
    final lowerGenericName = genericName.toLowerCase();
    final lowerCategory = category.toLowerCase();
    
    // Search in name, generic name and category
    return lowerName.contains(lowerQuery) ||
           lowerGenericName.contains(lowerQuery) ||
           lowerCategory.contains(lowerQuery);
  }

  // Factory constructor từ Map (cho SQLite)
  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      genericName: map['generic_name'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      dosage: map['dosage'] ?? '',
      sideEffects: (map['side_effects'] as String?)?.split('|') ?? [],
      contraindications: (map['contraindications'] as String?)?.split('|') ?? [],
      manufacturer: map['manufacturer'] ?? '',
      form: map['form'] ?? '',
      alteration: map['alteration'] ?? '',
      reference: map['reference'] ?? '',
    );
  }

  // Chuyển đổi thành Map (cho SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'generic_name': genericName,
      'category': category,
      'description': description,
      'dosage': dosage,
      'side_effects': sideEffects.join('|'),
      'contraindications': contraindications.join('|'),
      'manufacturer': manufacturer,
      'form': form,
      'alteration': alteration,
      'reference': reference,
    };
  }

  // Generate unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
