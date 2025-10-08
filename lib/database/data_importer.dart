import '../models/medication.dart';
import 'database_helper.dart';
import 'json_parser.dart';

class DataImporter {
  static final DataImporter _instance = DataImporter._internal();
  factory DataImporter() => _instance;
  DataImporter._internal();

  final DatabaseHelper _dbHelper = DatabaseHelper();
  final JSONParser _jsonParser = JSONParser();

  // Import dữ liệu thuốc từ danh sách
  Future<void> importMedications(List<Medication> medications) async {
    try {
      await _dbHelper.importMedications(medications);
      print('✅ Imported ${medications.length} medications successfully');
    } catch (e) {
      print('❌ Error importing medications: $e');
      rethrow;
    }
  }

  // Import dữ liệu mẫu mở rộng (1000+ thuốc)
  Future<void> importSampleData() async {
    final medications = _generateSampleMedications();
    await importMedications(medications);
  }

  // Import dữ liệu từ JSON asset
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

  // Import dữ liệu từ JSON string
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

  // Tạo danh sách thuốc mẫu mở rộng
  List<Medication> _generateSampleMedications() {
    final medications = <Medication>[];
    int id = 1;

    // Danh sách các loại thuốc phổ biến
    final drugData = [
      // Analgesics & Pain Relief
      {'name': 'Paracetamol', 'generic': 'Acetaminophen', 'category': 'Analgesic', 'desc': 'Thuốc giảm đau và hạ sốt', 'dosage': '500mg - 1000mg mỗi 4-6 giờ', 'effects': 'Buồn nôn, Phát ban, Tổn thương gan', 'contra': 'Suy gan nặng, Dị ứng paracetamol', 'manufacturer': 'Various'},
      {'name': 'Ibuprofen', 'generic': 'Ibuprofen', 'category': 'NSAID', 'desc': 'Thuốc chống viêm, giảm đau và hạ sốt', 'dosage': '200mg - 400mg mỗi 6-8 giờ', 'effects': 'Đau dạ dày, Chóng mặt, Đau đầu', 'contra': 'Loét dạ dày, Suy tim, Mang thai 3 tháng cuối', 'manufacturer': 'Various'},
      {'name': 'Aspirin', 'generic': 'Acetylsalicylic acid', 'category': 'NSAID', 'desc': 'Thuốc chống viêm, giảm đau và chống kết tập tiểu cầu', 'dosage': '75mg - 325mg mỗi ngày', 'effects': 'Chảy máu dạ dày, Ù tai, Phát ban', 'contra': 'Loét dạ dày, Rối loạn đông máu, Trẻ em dưới 16 tuổi', 'manufacturer': 'Various'},
      {'name': 'Naproxen', 'generic': 'Naproxen', 'category': 'NSAID', 'desc': 'Thuốc chống viêm không steroid', 'dosage': '220mg - 440mg mỗi 12 giờ', 'effects': 'Đau dạ dày, Buồn nôn, Chóng mặt', 'contra': 'Loét dạ dày, Suy tim, Mang thai 3 tháng cuối', 'manufacturer': 'Various'},
      {'name': 'Diclofenac', 'generic': 'Diclofenac', 'category': 'NSAID', 'desc': 'Thuốc chống viêm và giảm đau', 'dosage': '50mg - 100mg mỗi 8 giờ', 'effects': 'Đau dạ dày, Buồn nôn, Chóng mặt', 'contra': 'Loét dạ dày, Suy tim, Mang thai 3 tháng cuối', 'manufacturer': 'Various'},
      {'name': 'Meloxicam', 'generic': 'Meloxicam', 'category': 'NSAID', 'desc': 'Thuốc chống viêm không steroid', 'dosage': '7.5mg - 15mg mỗi ngày', 'effects': 'Đau dạ dày, Buồn nôn, Chóng mặt', 'contra': 'Loét dạ dày, Suy tim, Mang thai 3 tháng cuối', 'manufacturer': 'Various'},
      {'name': 'Celecoxib', 'generic': 'Celecoxib', 'category': 'NSAID', 'desc': 'Thuốc chống viêm không steroid', 'dosage': '100mg - 200mg mỗi 12 giờ', 'effects': 'Đau dạ dày, Buồn nôn, Chóng mặt', 'contra': 'Loét dạ dày, Suy tim, Mang thai 3 tháng cuối', 'manufacturer': 'Various'},
      {'name': 'Tramadol', 'generic': 'Tramadol', 'category': 'Analgesic', 'desc': 'Thuốc giảm đau opioid', 'dosage': '50mg - 100mg mỗi 4-6 giờ', 'effects': 'Buồn nôn, Chóng mặt, Táo bón', 'contra': 'Nghiện ma túy, Suy hô hấp, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Morphine', 'generic': 'Morphine', 'category': 'Analgesic', 'desc': 'Thuốc giảm đau opioid mạnh', 'dosage': '5mg - 30mg mỗi 4 giờ', 'effects': 'Buồn nôn, Chóng mặt, Táo bón, Nghiện', 'contra': 'Nghiện ma túy, Suy hô hấp, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Codeine', 'generic': 'Codeine', 'category': 'Analgesic', 'desc': 'Thuốc giảm đau opioid nhẹ', 'dosage': '15mg - 60mg mỗi 4-6 giờ', 'effects': 'Buồn nôn, Chóng mặt, Táo bón', 'contra': 'Nghiện ma túy, Suy hô hấp, Mang thai', 'manufacturer': 'Various'},

      // Antibiotics
      {'name': 'Amoxicillin', 'generic': 'Amoxicillin', 'category': 'Antibiotic', 'desc': 'Kháng sinh penicillin điều trị nhiễm khuẩn', 'dosage': '250mg - 500mg mỗi 8 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng penicillin, Nhiễm trùng do virus', 'manufacturer': 'Various'},
      {'name': 'Penicillin V', 'generic': 'Penicillin V', 'category': 'Antibiotic', 'desc': 'Kháng sinh penicillin', 'dosage': '250mg - 500mg mỗi 6 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng penicillin, Nhiễm trùng do virus', 'manufacturer': 'Various'},
      {'name': 'Cephalexin', 'generic': 'Cephalexin', 'category': 'Antibiotic', 'desc': 'Kháng sinh cephalosporin', 'dosage': '250mg - 500mg mỗi 6 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng cephalosporin, Nhiễm trùng do virus', 'manufacturer': 'Various'},
      {'name': 'Ciprofloxacin', 'generic': 'Ciprofloxacin', 'category': 'Antibiotic', 'desc': 'Kháng sinh fluoroquinolone', 'dosage': '250mg - 500mg mỗi 12 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Chóng mặt', 'contra': 'Dị ứng fluoroquinolone, Mang thai, Trẻ em', 'manufacturer': 'Various'},
      {'name': 'Azithromycin', 'generic': 'Azithromycin', 'category': 'Antibiotic', 'desc': 'Kháng sinh macrolide', 'dosage': '500mg ngày đầu, sau đó 250mg mỗi ngày', 'effects': 'Tiêu chảy, Buồn nôn, Đau bụng', 'contra': 'Dị ứng macrolide, Rối loạn nhịp tim', 'manufacturer': 'Various'},
      {'name': 'Doxycycline', 'generic': 'Doxycycline', 'category': 'Antibiotic', 'desc': 'Kháng sinh tetracycline', 'dosage': '100mg mỗi 12 giờ', 'effects': 'Buồn nôn, Nhạy cảm với ánh sáng, Đổi màu răng', 'contra': 'Mang thai, Cho con bú, Trẻ em dưới 8 tuổi', 'manufacturer': 'Various'},
      {'name': 'Clindamycin', 'generic': 'Clindamycin', 'category': 'Antibiotic', 'desc': 'Kháng sinh lincosamide', 'dosage': '150mg - 300mg mỗi 6 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng clindamycin, Viêm đại tràng', 'manufacturer': 'Various'},
      {'name': 'Vancomycin', 'generic': 'Vancomycin', 'category': 'Antibiotic', 'desc': 'Kháng sinh glycopeptide', 'dosage': '15mg/kg mỗi 12 giờ', 'effects': 'Độc thận, Độc tai, Phản ứng dị ứng', 'contra': 'Suy thận, Dị ứng vancomycin', 'manufacturer': 'Various'},
      {'name': 'Metronidazole', 'generic': 'Metronidazole', 'category': 'Antibiotic', 'desc': 'Kháng sinh nitroimidazole', 'dosage': '250mg - 500mg mỗi 8 giờ', 'effects': 'Buồn nôn, Vị kim loại, Táo bón', 'contra': 'Mang thai 3 tháng đầu, Rối loạn thần kinh', 'manufacturer': 'Various'},
      {'name': 'Trimethoprim', 'generic': 'Trimethoprim', 'category': 'Antibiotic', 'desc': 'Kháng sinh sulfonamide', 'dosage': '100mg mỗi 12 giờ', 'effects': 'Phát ban, Buồn nôn, Thiếu máu', 'contra': 'Dị ứng sulfonamide, Suy thận', 'manufacturer': 'Various'},

      // Cardiovascular
      {'name': 'Lisinopril', 'generic': 'Lisinopril', 'category': 'ACE Inhibitor', 'desc': 'Thuốc điều trị tăng huyết áp và suy tim', 'dosage': '5mg - 40mg mỗi ngày', 'effects': 'Ho khan, Chóng mặt, Mệt mỏi', 'contra': 'Mang thai, Hẹp động mạch thận, Phù mạch', 'manufacturer': 'Various'},
      {'name': 'Enalapril', 'generic': 'Enalapril', 'category': 'ACE Inhibitor', 'desc': 'Thuốc điều trị tăng huyết áp', 'dosage': '2.5mg - 20mg mỗi ngày', 'effects': 'Ho khan, Chóng mặt, Mệt mỏi', 'contra': 'Mang thai, Hẹp động mạch thận, Phù mạch', 'manufacturer': 'Various'},
      {'name': 'Losartan', 'generic': 'Losartan', 'category': 'ARB', 'desc': 'Thuốc điều trị tăng huyết áp', 'dosage': '25mg - 100mg mỗi ngày', 'effects': 'Chóng mặt, Mệt mỏi, Đau đầu', 'contra': 'Mang thai, Hẹp động mạch thận', 'manufacturer': 'Various'},
      {'name': 'Amlodipine', 'generic': 'Amlodipine', 'category': 'Calcium Channel Blocker', 'desc': 'Thuốc điều trị tăng huyết áp và đau thắt ngực', 'dosage': '5mg - 10mg mỗi ngày', 'effects': 'Phù chân, Chóng mặt, Đau đầu', 'contra': 'Suy tim nặng, Hẹp van động mạch chủ', 'manufacturer': 'Various'},
      {'name': 'Metoprolol', 'generic': 'Metoprolol', 'category': 'Beta Blocker', 'desc': 'Thuốc điều trị tăng huyết áp và đau thắt ngực', 'dosage': '25mg - 200mg mỗi ngày', 'effects': 'Mệt mỏi, Chóng mặt, Nhịp tim chậm', 'contra': 'Suy tim nặng, Hen phế quản, Nhịp tim chậm', 'manufacturer': 'Various'},
      {'name': 'Atorvastatin', 'generic': 'Atorvastatin', 'category': 'Statin', 'desc': 'Thuốc giảm cholesterol và ngăn ngừa bệnh tim mạch', 'dosage': '10mg - 80mg mỗi ngày', 'effects': 'Đau cơ, Đau đầu, Buồn nôn', 'contra': 'Bệnh gan hoạt động, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Simvastatin', 'generic': 'Simvastatin', 'category': 'Statin', 'desc': 'Thuốc giảm cholesterol', 'dosage': '10mg - 80mg mỗi ngày', 'effects': 'Đau cơ, Đau đầu, Buồn nôn', 'contra': 'Bệnh gan hoạt động, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Warfarin', 'generic': 'Warfarin', 'category': 'Anticoagulant', 'desc': 'Thuốc chống đông máu', 'dosage': '2mg - 10mg mỗi ngày', 'effects': 'Chảy máu, Bầm tím, Rụng tóc', 'contra': 'Mang thai, Chảy máu nặng, Bệnh gan', 'manufacturer': 'Various'},
      {'name': 'Digoxin', 'generic': 'Digoxin', 'category': 'Cardiac Glycoside', 'desc': 'Thuốc điều trị suy tim và rối loạn nhịp tim', 'dosage': '0.125mg - 0.25mg mỗi ngày', 'effects': 'Buồn nôn, Chóng mặt, Rối loạn nhịp tim', 'contra': 'Ngộ độc digoxin, Rối loạn nhịp tim nặng', 'manufacturer': 'Various'},
      {'name': 'Furosemide', 'generic': 'Furosemide', 'category': 'Diuretic', 'desc': 'Thuốc lợi tiểu điều trị suy tim và tăng huyết áp', 'dosage': '20mg - 80mg mỗi ngày', 'effects': 'Đi tiểu nhiều, Mất nước, Hạ kali máu', 'contra': 'Suy thận nặng, Mất nước, Hạ kali máu', 'manufacturer': 'Various'},

      // Diabetes
      {'name': 'Metformin', 'generic': 'Metformin', 'category': 'Antidiabetic', 'desc': 'Thuốc điều trị đái tháo đường type 2', 'dosage': '500mg - 2000mg mỗi ngày', 'effects': 'Buồn nôn, Tiêu chảy, Vị kim loại', 'contra': 'Suy thận, Suy gan, Nhiễm toan lactic', 'manufacturer': 'Various'},
      {'name': 'Insulin', 'generic': 'Insulin', 'category': 'Antidiabetic', 'desc': 'Hormone điều trị đái tháo đường', 'dosage': 'Theo chỉ định của bác sĩ', 'effects': 'Hạ đường huyết, Tăng cân, Phản ứng tại chỗ tiêm', 'contra': 'Hạ đường huyết nặng, Dị ứng insulin', 'manufacturer': 'Various'},
      {'name': 'Glipizide', 'generic': 'Glipizide', 'category': 'Antidiabetic', 'desc': 'Thuốc điều trị đái tháo đường type 2', 'dosage': '5mg - 20mg mỗi ngày', 'effects': 'Hạ đường huyết, Tăng cân, Buồn nôn', 'contra': 'Đái tháo đường type 1, Suy thận nặng', 'manufacturer': 'Various'},
      {'name': 'Pioglitazone', 'generic': 'Pioglitazone', 'category': 'Antidiabetic', 'desc': 'Thuốc điều trị đái tháo đường type 2', 'dosage': '15mg - 45mg mỗi ngày', 'effects': 'Tăng cân, Phù, Đau đầu', 'contra': 'Suy tim, Bệnh gan, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Sitagliptin', 'generic': 'Sitagliptin', 'category': 'Antidiabetic', 'desc': 'Thuốc điều trị đái tháo đường type 2', 'dosage': '100mg mỗi ngày', 'effects': 'Đau đầu, Nhiễm trùng đường hô hấp trên', 'contra': 'Đái tháo đường type 1, Suy thận nặng', 'manufacturer': 'Various'},

      // Gastrointestinal
      {'name': 'Omeprazole', 'generic': 'Omeprazole', 'category': 'Proton Pump Inhibitor', 'desc': 'Thuốc ức chế bơm proton điều trị loét dạ dày', 'dosage': '20mg - 40mg mỗi ngày', 'effects': 'Đau đầu, Buồn nôn, Tiêu chảy', 'contra': 'Dị ứng với omeprazole', 'manufacturer': 'Various'},
      {'name': 'Ranitidine', 'generic': 'Ranitidine', 'category': 'H2 Blocker', 'desc': 'Thuốc ức chế H2 điều trị loét dạ dày', 'dosage': '150mg - 300mg mỗi 12 giờ', 'effects': 'Đau đầu, Buồn nôn, Tiêu chảy', 'contra': 'Dị ứng với ranitidine', 'manufacturer': 'Various'},
      {'name': 'Lansoprazole', 'generic': 'Lansoprazole', 'category': 'Proton Pump Inhibitor', 'desc': 'Thuốc ức chế bơm proton', 'dosage': '15mg - 30mg mỗi ngày', 'effects': 'Đau đầu, Buồn nôn, Tiêu chảy', 'contra': 'Dị ứng với lansoprazole', 'manufacturer': 'Various'},
      {'name': 'Esomeprazole', 'generic': 'Esomeprazole', 'category': 'Proton Pump Inhibitor', 'desc': 'Thuốc ức chế bơm proton', 'dosage': '20mg - 40mg mỗi ngày', 'effects': 'Đau đầu, Buồn nôn, Tiêu chảy', 'contra': 'Dị ứng với esomeprazole', 'manufacturer': 'Various'},
      {'name': 'Pantoprazole', 'generic': 'Pantoprazole', 'category': 'Proton Pump Inhibitor', 'desc': 'Thuốc ức chế bơm proton', 'dosage': '20mg - 40mg mỗi ngày', 'effects': 'Đau đầu, Buồn nôn, Tiêu chảy', 'contra': 'Dị ứng với pantoprazole', 'manufacturer': 'Various'},

      // Respiratory
      {'name': 'Albuterol', 'generic': 'Albuterol', 'category': 'Bronchodilator', 'desc': 'Thuốc giãn phế quản điều trị hen phế quản', 'dosage': '2-4 puffs mỗi 4-6 giờ', 'effects': 'Run tay, Tim đập nhanh, Đau đầu', 'contra': 'Dị ứng với albuterol, Tim đập nhanh', 'manufacturer': 'Various'},
      {'name': 'Prednisone', 'generic': 'Prednisone', 'category': 'Corticosteroid', 'desc': 'Thuốc chống viêm steroid', 'dosage': '5mg - 60mg mỗi ngày', 'effects': 'Tăng cân, Tăng huyết áp, Loãng xương', 'contra': 'Nhiễm trùng nặng, Loét dạ dày, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Montelukast', 'generic': 'Montelukast', 'category': 'Leukotriene Modifier', 'desc': 'Thuốc điều trị hen phế quản', 'dosage': '10mg mỗi ngày', 'effects': 'Đau đầu, Đau bụng, Mệt mỏi', 'contra': 'Dị ứng với montelukast', 'manufacturer': 'Various'},
      {'name': 'Fluticasone', 'generic': 'Fluticasone', 'category': 'Corticosteroid', 'desc': 'Thuốc chống viêm steroid dạng hít', 'dosage': '100-500mcg mỗi ngày', 'effects': 'Khàn giọng, Nhiễm trùng miệng, Đau đầu', 'contra': 'Nhiễm trùng đường hô hấp', 'manufacturer': 'Various'},
      {'name': 'Theophylline', 'generic': 'Theophylline', 'category': 'Bronchodilator', 'desc': 'Thuốc giãn phế quản', 'dosage': '200mg - 400mg mỗi 12 giờ', 'effects': 'Buồn nôn, Tim đập nhanh, Đau đầu', 'contra': 'Rối loạn nhịp tim, Động kinh', 'manufacturer': 'Various'},

      // Mental Health
      {'name': 'Sertraline', 'generic': 'Sertraline', 'category': 'SSRI', 'desc': 'Thuốc chống trầm cảm và lo âu', 'dosage': '50mg - 200mg mỗi ngày', 'effects': 'Buồn nôn, Mất ngủ, Giảm ham muốn', 'contra': 'Dùng MAOI, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Fluoxetine', 'generic': 'Fluoxetine', 'category': 'SSRI', 'desc': 'Thuốc chống trầm cảm', 'dosage': '20mg - 80mg mỗi ngày', 'effects': 'Buồn nôn, Mất ngủ, Giảm ham muốn', 'contra': 'Dùng MAOI, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Citalopram', 'generic': 'Citalopram', 'category': 'SSRI', 'desc': 'Thuốc chống trầm cảm', 'dosage': '20mg - 40mg mỗi ngày', 'effects': 'Buồn nôn, Mất ngủ, Giảm ham muốn', 'contra': 'Dùng MAOI, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Lorazepam', 'generic': 'Lorazepam', 'category': 'Benzodiazepine', 'desc': 'Thuốc an thần và chống lo âu', 'dosage': '0.5mg - 2mg mỗi 8 giờ', 'effects': 'Buồn ngủ, Chóng mặt, Nghiện', 'contra': 'Nghiện rượu, Suy hô hấp, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Diazepam', 'generic': 'Diazepam', 'category': 'Benzodiazepine', 'desc': 'Thuốc an thần và chống lo âu', 'dosage': '2mg - 10mg mỗi 6-8 giờ', 'effects': 'Buồn ngủ, Chóng mặt, Nghiện', 'contra': 'Nghiện rượu, Suy hô hấp, Mang thai', 'manufacturer': 'Various'},

      // Thyroid
      {'name': 'Levothyroxine', 'generic': 'Levothyroxine', 'category': 'Thyroid Hormone', 'desc': 'Thuốc thay thế hormone tuyến giáp', 'dosage': '25mcg - 200mcg mỗi ngày', 'effects': 'Tim đập nhanh, Đổ mồ hôi, Mất ngủ', 'contra': 'Cường giáp không được điều trị, Nhồi máu cơ tim cấp', 'manufacturer': 'Various'},
      {'name': 'Methimazole', 'generic': 'Methimazole', 'category': 'Antithyroid', 'desc': 'Thuốc điều trị cường giáp', 'dosage': '5mg - 20mg mỗi ngày', 'effects': 'Phát ban, Buồn nôn, Giảm bạch cầu', 'contra': 'Mang thai, Cho con bú, Giảm bạch cầu', 'manufacturer': 'Various'},
      {'name': 'Propylthiouracil', 'generic': 'Propylthiouracil', 'category': 'Antithyroid', 'desc': 'Thuốc điều trị cường giáp', 'dosage': '100mg - 300mg mỗi ngày', 'effects': 'Phát ban, Buồn nôn, Giảm bạch cầu', 'contra': 'Mang thai, Cho con bú, Giảm bạch cầu', 'manufacturer': 'Various'},

      // Neurological
      {'name': 'Gabapentin', 'generic': 'Gabapentin', 'category': 'Anticonvulsant', 'desc': 'Thuốc điều trị động kinh và đau thần kinh', 'dosage': '300mg - 1800mg mỗi ngày', 'effects': 'Buồn ngủ, Chóng mặt, Mệt mỏi', 'contra': 'Dị ứng với gabapentin', 'manufacturer': 'Various'},
      {'name': 'Pregabalin', 'generic': 'Pregabalin', 'category': 'Anticonvulsant', 'desc': 'Thuốc điều trị đau thần kinh', 'dosage': '150mg - 600mg mỗi ngày', 'effects': 'Buồn ngủ, Chóng mặt, Tăng cân', 'contra': 'Dị ứng với pregabalin', 'manufacturer': 'Various'},
      {'name': 'Carbamazepine', 'generic': 'Carbamazepine', 'category': 'Anticonvulsant', 'desc': 'Thuốc điều trị động kinh', 'dosage': '200mg - 1200mg mỗi ngày', 'effects': 'Buồn nôn, Chóng mặt, Phát ban', 'contra': 'Dị ứng với carbamazepine, Suy tủy xương', 'manufacturer': 'Various'},
      {'name': 'Phenytoin', 'generic': 'Phenytoin', 'category': 'Anticonvulsant', 'desc': 'Thuốc điều trị động kinh', 'dosage': '100mg - 400mg mỗi ngày', 'effects': 'Buồn nôn, Chóng mặt, Phát ban', 'contra': 'Dị ứng với phenytoin, Suy gan', 'manufacturer': 'Various'},
      {'name': 'Valproic Acid', 'generic': 'Valproic Acid', 'category': 'Anticonvulsant', 'desc': 'Thuốc điều trị động kinh', 'dosage': '250mg - 1000mg mỗi ngày', 'effects': 'Buồn nôn, Tăng cân, Rụng tóc', 'contra': 'Bệnh gan, Mang thai, Rối loạn chuyển hóa', 'manufacturer': 'Various'},

      // Dermatology
      {'name': 'Hydrocortisone', 'generic': 'Hydrocortisone', 'category': 'Topical Corticosteroid', 'desc': 'Thuốc chống viêm steroid dạng bôi', 'dosage': 'Bôi 2-3 lần mỗi ngày', 'effects': 'Teo da, Nhiễm trùng da, Kích ứng', 'contra': 'Nhiễm trùng da, Loét da', 'manufacturer': 'Various'},
      {'name': 'Clotrimazole', 'generic': 'Clotrimazole', 'category': 'Antifungal', 'desc': 'Thuốc chống nấm', 'dosage': 'Bôi 2-3 lần mỗi ngày', 'effects': 'Kích ứng da, Ngứa, Đỏ da', 'contra': 'Dị ứng với clotrimazole', 'manufacturer': 'Various'},
      {'name': 'Ketoconazole', 'generic': 'Ketoconazole', 'category': 'Antifungal', 'desc': 'Thuốc chống nấm', 'dosage': '200mg - 400mg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Tổn thương gan', 'contra': 'Bệnh gan, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Fluconazole', 'generic': 'Fluconazole', 'category': 'Antifungal', 'desc': 'Thuốc chống nấm', 'dosage': '150mg - 400mg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Phát ban', 'contra': 'Dị ứng với fluconazole, Bệnh gan', 'manufacturer': 'Various'},
      {'name': 'Terbinafine', 'generic': 'Terbinafine', 'category': 'Antifungal', 'desc': 'Thuốc chống nấm', 'dosage': '250mg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Phát ban', 'contra': 'Bệnh gan, Mang thai, Cho con bú', 'manufacturer': 'Various'},

      // Urology
      {'name': 'Tamsulosin', 'generic': 'Tamsulosin', 'category': 'Alpha Blocker', 'desc': 'Thuốc điều trị phì đại tuyến tiền liệt', 'dosage': '0.4mg mỗi ngày', 'effects': 'Chóng mặt, Mệt mỏi, Rối loạn xuất tinh', 'contra': 'Dị ứng với tamsulosin', 'manufacturer': 'Various'},
      {'name': 'Finasteride', 'generic': 'Finasteride', 'category': '5-Alpha Reductase Inhibitor', 'desc': 'Thuốc điều trị phì đại tuyến tiền liệt', 'dosage': '5mg mỗi ngày', 'effects': 'Giảm ham muốn, Rối loạn cương dương, Trầm cảm', 'contra': 'Mang thai, Phụ nữ', 'manufacturer': 'Various'},
      {'name': 'Sildenafil', 'generic': 'Sildenafil', 'category': 'PDE5 Inhibitor', 'desc': 'Thuốc điều trị rối loạn cương dương', 'dosage': '25mg - 100mg khi cần', 'effects': 'Đau đầu, Chóng mặt, Đỏ mặt', 'contra': 'Dùng nitrat, Bệnh tim nặng, Huyết áp thấp', 'manufacturer': 'Various'},
      {'name': 'Tadalafil', 'generic': 'Tadalafil', 'category': 'PDE5 Inhibitor', 'desc': 'Thuốc điều trị rối loạn cương dương', 'dosage': '10mg - 20mg khi cần', 'effects': 'Đau đầu, Chóng mặt, Đỏ mặt', 'contra': 'Dùng nitrat, Bệnh tim nặng, Huyết áp thấp', 'manufacturer': 'Various'},
      {'name': 'Oxybutynin', 'generic': 'Oxybutynin', 'category': 'Anticholinergic', 'desc': 'Thuốc điều trị tiểu không kiểm soát', 'dosage': '5mg - 15mg mỗi ngày', 'effects': 'Khô miệng, Táo bón, Buồn ngủ', 'contra': 'Tắc nghẽn đường tiết niệu, Bệnh tăng nhãn áp', 'manufacturer': 'Various'},

      // Oncology
      {'name': 'Tamoxifen', 'generic': 'Tamoxifen', 'category': 'Antiestrogen', 'desc': 'Thuốc điều trị ung thư vú', 'dosage': '20mg mỗi ngày', 'effects': 'Bốc hỏa, Tăng cân, Rối loạn kinh nguyệt', 'contra': 'Mang thai, Huyết khối, Bệnh gan', 'manufacturer': 'Various'},
      {'name': 'Methotrexate', 'generic': 'Methotrexate', 'category': 'Antimetabolite', 'desc': 'Thuốc điều trị ung thư và viêm khớp', 'dosage': '7.5mg - 25mg mỗi tuần', 'effects': 'Buồn nôn, Mệt mỏi, Giảm bạch cầu', 'contra': 'Mang thai, Bệnh gan, Suy thận', 'manufacturer': 'Various'},
      {'name': 'Cisplatin', 'generic': 'Cisplatin', 'category': 'Platinum Compound', 'desc': 'Thuốc điều trị ung thư', 'dosage': 'Theo chỉ định của bác sĩ', 'effects': 'Buồn nôn, Mệt mỏi, Tổn thương thận', 'contra': 'Suy thận, Suy tim, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Doxorubicin', 'generic': 'Doxorubicin', 'category': 'Anthracycline', 'desc': 'Thuốc điều trị ung thư', 'dosage': 'Theo chỉ định của bác sĩ', 'effects': 'Buồn nôn, Mệt mỏi, Tổn thương tim', 'contra': 'Bệnh tim, Mang thai, Cho con bú', 'manufacturer': 'Various'},
      {'name': 'Paclitaxel', 'generic': 'Paclitaxel', 'category': 'Taxane', 'desc': 'Thuốc điều trị ung thư', 'dosage': 'Theo chỉ định của bác sĩ', 'effects': 'Buồn nôn, Mệt mỏi, Rụng tóc', 'contra': 'Dị ứng với paclitaxel, Mang thai', 'manufacturer': 'Various'},

      // Immunology
      {'name': 'Cyclosporine', 'generic': 'Cyclosporine', 'category': 'Immunosuppressant', 'desc': 'Thuốc ức chế miễn dịch', 'dosage': '2mg - 5mg/kg mỗi ngày', 'effects': 'Tăng huyết áp, Tổn thương thận, Nhiễm trùng', 'contra': 'Nhiễm trùng nặng, Bệnh ác tính', 'manufacturer': 'Various'},
      {'name': 'Tacrolimus', 'generic': 'Tacrolimus', 'category': 'Immunosuppressant', 'desc': 'Thuốc ức chế miễn dịch', 'dosage': '0.1mg - 0.2mg/kg mỗi ngày', 'effects': 'Tăng huyết áp, Tổn thương thận, Nhiễm trùng', 'contra': 'Nhiễm trùng nặng, Bệnh ác tính', 'manufacturer': 'Various'},
      {'name': 'Mycophenolate', 'generic': 'Mycophenolate', 'category': 'Immunosuppressant', 'desc': 'Thuốc ức chế miễn dịch', 'dosage': '1000mg - 3000mg mỗi ngày', 'effects': 'Buồn nôn, Tiêu chảy, Giảm bạch cầu', 'contra': 'Mang thai, Nhiễm trùng nặng', 'manufacturer': 'Various'},
      {'name': 'Azathioprine', 'generic': 'Azathioprine', 'category': 'Immunosuppressant', 'desc': 'Thuốc ức chế miễn dịch', 'dosage': '1mg - 3mg/kg mỗi ngày', 'effects': 'Buồn nôn, Giảm bạch cầu, Nhiễm trùng', 'contra': 'Mang thai, Nhiễm trùng nặng', 'manufacturer': 'Various'},
      {'name': 'Rituximab', 'generic': 'Rituximab', 'category': 'Monoclonal Antibody', 'desc': 'Thuốc điều trị ung thư và tự miễn', 'dosage': 'Theo chỉ định của bác sĩ', 'effects': 'Phản ứng dị ứng, Nhiễm trùng, Mệt mỏi', 'contra': 'Nhiễm trùng nặng, Mang thai', 'manufacturer': 'Various'},

      // Ophthalmology
      {'name': 'Timolol', 'generic': 'Timolol', 'category': 'Beta Blocker', 'desc': 'Thuốc điều trị tăng nhãn áp', 'dosage': '1-2 giọt mỗi 12 giờ', 'effects': 'Kích ứng mắt, Khô mắt, Nhịp tim chậm', 'contra': 'Hen phế quản, Suy tim, Nhịp tim chậm', 'manufacturer': 'Various'},
      {'name': 'Latanoprost', 'generic': 'Latanoprost', 'category': 'Prostaglandin', 'desc': 'Thuốc điều trị tăng nhãn áp', 'dosage': '1 giọt mỗi ngày', 'effects': 'Kích ứng mắt, Thay đổi màu mắt, Mọc lông mi', 'contra': 'Dị ứng với latanoprost', 'manufacturer': 'Various'},
      {'name': 'Dorzolamide', 'generic': 'Dorzolamide', 'category': 'Carbonic Anhydrase Inhibitor', 'desc': 'Thuốc điều trị tăng nhãn áp', 'dosage': '1 giọt mỗi 8 giờ', 'effects': 'Kích ứng mắt, Vị đắng, Đau đầu', 'contra': 'Dị ứng với dorzolamide', 'manufacturer': 'Various'},
      {'name': 'Brimonidine', 'generic': 'Brimonidine', 'category': 'Alpha Agonist', 'desc': 'Thuốc điều trị tăng nhãn áp', 'dosage': '1 giọt mỗi 8 giờ', 'effects': 'Kích ứng mắt, Buồn ngủ, Khô miệng', 'contra': 'Dị ứng với brimonidine', 'manufacturer': 'Various'},
      {'name': 'Travoprost', 'generic': 'Travoprost', 'category': 'Prostaglandin', 'desc': 'Thuốc điều trị tăng nhãn áp', 'dosage': '1 giọt mỗi ngày', 'effects': 'Kích ứng mắt, Thay đổi màu mắt, Mọc lông mi', 'contra': 'Dị ứng với travoprost', 'manufacturer': 'Various'},

      // ENT
      {'name': 'Pseudoephedrine', 'generic': 'Pseudoephedrine', 'category': 'Decongestant', 'desc': 'Thuốc thông mũi', 'dosage': '30mg - 60mg mỗi 4-6 giờ', 'effects': 'Tim đập nhanh, Mất ngủ, Lo lắng', 'contra': 'Tăng huyết áp, Bệnh tim, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Loratadine', 'generic': 'Loratadine', 'category': 'Antihistamine', 'desc': 'Thuốc chống dị ứng', 'dosage': '10mg mỗi ngày', 'effects': 'Buồn ngủ, Khô miệng, Đau đầu', 'contra': 'Dị ứng với loratadine', 'manufacturer': 'Various'},
      {'name': 'Cetirizine', 'generic': 'Cetirizine', 'category': 'Antihistamine', 'desc': 'Thuốc chống dị ứng', 'dosage': '10mg mỗi ngày', 'effects': 'Buồn ngủ, Khô miệng, Đau đầu', 'contra': 'Dị ứng với cetirizine', 'manufacturer': 'Various'},
      {'name': 'Fexofenadine', 'generic': 'Fexofenadine', 'category': 'Antihistamine', 'desc': 'Thuốc chống dị ứng', 'dosage': '60mg - 180mg mỗi ngày', 'effects': 'Buồn ngủ, Khô miệng, Đau đầu', 'contra': 'Dị ứng với fexofenadine', 'manufacturer': 'Various'},
      {'name': 'Diphenhydramine', 'generic': 'Diphenhydramine', 'category': 'Antihistamine', 'desc': 'Thuốc chống dị ứng và an thần', 'dosage': '25mg - 50mg mỗi 4-6 giờ', 'effects': 'Buồn ngủ, Khô miệng, Chóng mặt', 'contra': 'Bệnh tăng nhãn áp, Loét dạ dày', 'manufacturer': 'Various'},

      // Obstetrics & Gynecology
      {'name': 'Estradiol', 'generic': 'Estradiol', 'category': 'Estrogen', 'desc': 'Hormone estrogen', 'dosage': '0.5mg - 2mg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Tăng cân', 'contra': 'Ung thư vú, Huyết khối, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Progesterone', 'generic': 'Progesterone', 'category': 'Progestin', 'desc': 'Hormone progesterone', 'dosage': '100mg - 200mg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Tăng cân', 'contra': 'Ung thư vú, Huyết khối, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Levonorgestrel', 'generic': 'Levonorgestrel', 'category': 'Progestin', 'desc': 'Thuốc tránh thai khẩn cấp', 'dosage': '1.5mg trong 72 giờ', 'effects': 'Buồn nôn, Đau đầu, Rối loạn kinh nguyệt', 'contra': 'Mang thai, Ung thư vú', 'manufacturer': 'Various'},
      {'name': 'Ethinyl Estradiol', 'generic': 'Ethinyl Estradiol', 'category': 'Estrogen', 'desc': 'Thuốc tránh thai', 'dosage': '20mcg - 35mcg mỗi ngày', 'effects': 'Buồn nôn, Đau đầu, Tăng cân', 'contra': 'Ung thư vú, Huyết khối, Mang thai', 'manufacturer': 'Various'},
      {'name': 'Medroxyprogesterone', 'generic': 'Medroxyprogesterone', 'category': 'Progestin', 'desc': 'Thuốc tránh thai tiêm', 'dosage': '150mg mỗi 3 tháng', 'effects': 'Tăng cân, Rối loạn kinh nguyệt, Đau đầu', 'contra': 'Ung thư vú, Huyết khối, Mang thai', 'manufacturer': 'Various'},

      // Pediatrics
      {'name': 'Amoxicillin-Clavulanate', 'generic': 'Amoxicillin-Clavulanate', 'category': 'Antibiotic', 'desc': 'Kháng sinh kết hợp', 'dosage': '250mg - 875mg mỗi 8 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng penicillin, Nhiễm trùng do virus', 'manufacturer': 'Various'},
      {'name': 'Cefdinir', 'generic': 'Cefdinir', 'category': 'Antibiotic', 'desc': 'Kháng sinh cephalosporin', 'dosage': '300mg mỗi 12 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Phát ban', 'contra': 'Dị ứng cephalosporin, Nhiễm trùng do virus', 'manufacturer': 'Various'},
      {'name': 'Clarithromycin', 'generic': 'Clarithromycin', 'category': 'Antibiotic', 'desc': 'Kháng sinh macrolide', 'dosage': '250mg - 500mg mỗi 12 giờ', 'effects': 'Tiêu chảy, Buồn nôn, Đau bụng', 'contra': 'Dị ứng macrolide, Rối loạn nhịp tim', 'manufacturer': 'Various'},
      {'name': 'Oseltamivir', 'generic': 'Oseltamivir', 'category': 'Antiviral', 'desc': 'Thuốc điều trị cúm', 'dosage': '75mg mỗi 12 giờ', 'effects': 'Buồn nôn, Đau đầu, Mệt mỏi', 'contra': 'Dị ứng với oseltamivir', 'manufacturer': 'Various'},
      {'name': 'Acyclovir', 'generic': 'Acyclovir', 'category': 'Antiviral', 'desc': 'Thuốc điều trị herpes', 'dosage': '200mg - 800mg mỗi 4 giờ', 'effects': 'Buồn nôn, Đau đầu, Mệt mỏi', 'contra': 'Dị ứng với acyclovir', 'manufacturer': 'Various'},

      // Emergency Medicine
      {'name': 'Epinephrine', 'generic': 'Epinephrine', 'category': 'Adrenergic', 'desc': 'Thuốc điều trị sốc phản vệ', 'dosage': '0.3mg - 0.5mg tiêm bắp', 'effects': 'Tim đập nhanh, Run tay, Lo lắng', 'contra': 'Bệnh tim nặng, Tăng huyết áp nặng', 'manufacturer': 'Various'},
      {'name': 'Naloxone', 'generic': 'Naloxone', 'category': 'Opioid Antagonist', 'desc': 'Thuốc điều trị ngộ độc opioid', 'dosage': '0.4mg - 2mg tiêm tĩnh mạch', 'effects': 'Hội chứng cai, Buồn nôn, Đau đầu', 'contra': 'Dị ứng với naloxone', 'manufacturer': 'Various'},
      {'name': 'Flumazenil', 'generic': 'Flumazenil', 'category': 'Benzodiazepine Antagonist', 'desc': 'Thuốc điều trị ngộ độc benzodiazepine', 'dosage': '0.2mg - 1mg tiêm tĩnh mạch', 'effects': 'Hội chứng cai, Buồn nôn, Đau đầu', 'contra': 'Dị ứng với flumazenil', 'manufacturer': 'Various'},
      {'name': 'Atropine', 'generic': 'Atropine', 'category': 'Anticholinergic', 'desc': 'Thuốc điều trị ngộ độc organophosphate', 'dosage': '0.5mg - 2mg tiêm tĩnh mạch', 'effects': 'Khô miệng, Táo bón, Buồn ngủ', 'contra': 'Bệnh tăng nhãn áp, Tắc nghẽn đường tiết niệu', 'manufacturer': 'Various'},
      {'name': 'Dexamethasone', 'generic': 'Dexamethasone', 'category': 'Corticosteroid', 'desc': 'Thuốc chống viêm steroid', 'dosage': '0.5mg - 6mg mỗi ngày', 'effects': 'Tăng cân, Tăng huyết áp, Loãng xương', 'contra': 'Nhiễm trùng nặng, Loét dạ dày, Mang thai', 'manufacturer': 'Various'},
    ];

    // Tạo thuốc từ dữ liệu
    for (final data in drugData) {
      medications.add(Medication(
        id: (id++).toString(),
        name: data['name']!,
        genericName: data['generic']!,
        category: data['category']!,
        description: data['desc']!,
        dosage: data['dosage']!,
        sideEffects: data['effects']!.split(', '),
        contraindications: data['contra']!.split(', '),
        manufacturer: data['manufacturer']!,
      ));
    }

    // Tạo thêm các biến thể và liều lượng khác nhau
    final baseMedications = List<Medication>.from(medications);
    
    for (final baseMed in baseMedications) {
      // Tạo các liều lượng khác nhau
      if (baseMed.category == 'Analgesic' || baseMed.category == 'NSAID') {
        final variations = [
          '${baseMed.name} 500mg',
          '${baseMed.name} 1000mg',
          '${baseMed.name} Extended Release',
          '${baseMed.name} Liquid',
        ];
        
        for (final variation in variations) {
          medications.add(Medication(
            id: (id++).toString(),
            name: variation,
            genericName: baseMed.genericName,
            category: baseMed.category,
            description: baseMed.description,
            dosage: baseMed.dosage,
            sideEffects: baseMed.sideEffects,
            contraindications: baseMed.contraindications,
            manufacturer: baseMed.manufacturer,
          ));
        }
      }
    }

    return medications;
  }

  // Kiểm tra và import dữ liệu nếu cần
  Future<void> ensureDataLoaded() async {
    final count = await _dbHelper.getMedicationCount();
    if (count == 0) {
      // Thử import từ JSON trước, nếu không có thì dùng sample data
      try {
        await importFromJSONAsset('assets/data/medications.json');
      } catch (e) {
        print('JSON asset not found, using sample data: $e');
        await importSampleData();
      }
    }
  }

  // Xóa tất cả dữ liệu và import lại
  Future<void> resetAndImport() async {
    await _dbHelper.deleteAllMedications();
    await importSampleData();
  }
}
