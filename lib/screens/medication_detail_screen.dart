import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/medication.dart';
import 'dosage_form_detail_screen.dart';

class MedicationDetailScreen extends StatelessWidget {
  final Medication medication;

  const MedicationDetailScreen({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBBDEFB), // Màu xanh biển đậm hơn
      body: SafeArea(
        child: Column(
          children: [
            // Nội dung chính
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 60), // Khoảng cách từ trên xuống
                    
                    // Tên thuốc chính (đưa lên trên)
                    _buildMedicationName(),
                    const SizedBox(height: 30),
                    
                    // Danh sách dạng bào chế (đưa xuống dưới)
                    _buildDosageForms(context),
                    
                    const SizedBox(height: 80), // Khoảng cách cho nút Home ở dưới
                  ],
                ),
              ),
            ),
            
            // Nút Home ở dưới cùng
            _buildHomeButton(context),
          ],
        ),
      ),
    );
  }


  Widget _buildMedicationName() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.textPrimary,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        medication.name,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDosageForms(BuildContext context) {
    // Tạo danh sách các dạng bào chế dựa trên tên thuốc
    final dosageForms = _generateDosageForms();
    
    return Column(
      children: [
        // Danh sách dạng bào chế (không có tiêu đề)
        ...dosageForms.map((form) => _buildDosageFormItem(form, context)),
      ],
    );
  }

  Widget _buildDosageFormItem(String formName, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DosageFormDetailScreen(
                  medication: medication,
                  dosageForm: formName,
                ),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    formName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Nút mũi tên
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _generateDosageForms() {
    // Tạo danh sách dạng bào chế dựa trên tên thuốc
    final baseName = medication.name.toLowerCase();
    final forms = <String>[];
    
    // Kiểm tra tên thuốc để tạo dạng bào chế phù hợp
    if (baseName.contains('tablet') || baseName.contains('tab')) {
      forms.add('Tablet');
    }
    
    if (baseName.contains('capsule') || baseName.contains('cap')) {
      forms.add('Capsule');
    }
    
    if (baseName.contains('er') || baseName.contains('extended') || baseName.contains('xr')) {
      forms.add('Extended Release Tablet');
    }
    
    if (baseName.contains('sprinkle')) {
      forms.add('Sprinkle Capsule');
    }
    
    if (baseName.contains('dr') || baseName.contains('delayed')) {
      forms.add('Delayed Release Tablet');
    }
    
    if (baseName.contains('ld') || baseName.contains('low dose')) {
      forms.add('Low Dose Tablet');
    }
    
    // Nếu không tìm thấy dạng bào chế nào, sử dụng dạng mặc định
    if (forms.isEmpty) {
      forms.add('Tablet'); // Dạng mặc định
    }
    
    return forms;
  }

  Widget _buildHomeButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Home ở góc trái dưới
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // Nút Report an issue ở góc phải dưới
          GestureDetector(
            onTap: () {
              _showReportDialog(context);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.report_problem,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Report an issue',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController _feedbackController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Report an Issue',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please describe the issue you encountered:',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final feedback = _feedbackController.text.trim();
              if (feedback.isNotEmpty) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Thank you for your feedback! We will review this issue.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                    duration: const Duration(seconds: 3),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter your feedback before submitting.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
