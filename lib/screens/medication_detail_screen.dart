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
                    const SizedBox(height: 60), // Space from top
                    
                    // Main medication name (brought to top)
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
    // Generate list of dosage forms based on medication name
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
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    formName,
                    style: TextStyle(
                      fontSize: formName.length > 25 ? 15 : 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Arrow icon
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
    print('🔍 Generating dosage forms for: ${medication.name}');
    print('🔍 DosageForms count: ${medication.dosageForms.length}');
    print('🔍 Form field: "${medication.form}"');
    
    // Special handling for Aspirin - show all forms (remove special logic)
    // if (medication.name.toLowerCase().contains('aspirin') && 
    //     medication.dosageForms.isNotEmpty) {
    //   final forms = medication.dosageForms.map((df) => df.form).toList();
    //   // Filter to show only chewable forms for Aspirin
    //   final chewableForms = forms.where((form) => 
    //     form.toLowerCase().contains('chewable')).toList();
    //   if (chewableForms.isNotEmpty) {
    //     print('🔍 Aspirin special handling - returning chewable forms: $chewableForms');
    //     return chewableForms;
    //   }
    // }
    
    // Ưu tiên sử dụng dosageForms nếu có
    if (medication.dosageForms.isNotEmpty) {
      final forms = medication.dosageForms.map((df) => df.form).toList();
      print('🔍 Using dosageForms from JSON: $forms');
      
      // Check if we should show all forms or filter generic ones
      final specificForms = forms.where((form) => 
        form.toLowerCase() != 'tablet' && 
        form.toLowerCase() != 'capsule').toList();
      
      // If there are both generic and specific forms, show all forms
      final hasGenericTablet = forms.any((form) => form.toLowerCase() == 'tablet');
      final hasGenericCapsule = forms.any((form) => form.toLowerCase() == 'capsule');
      
      if (specificForms.isNotEmpty && (hasGenericTablet || hasGenericCapsule)) {
        // Show all forms (both generic and specific)
        print('🔍 Showing all forms (generic + specific), returning: $forms');
        return forms;
      } else if (specificForms.isNotEmpty) {
        // Only specific forms exist
        print('🔍 Only specific forms exist, returning: $specificForms');
        return specificForms;
      }
      
      // Handle remaining cases
      if (hasGenericTablet && hasGenericCapsule) {
        // If both generic forms exist, return both
        print('🔍 Both generic forms exist, returning: $forms');
        return forms;
      } else if (hasGenericTablet) {
        // Only generic tablet
        print('🔍 Only generic tablet, returning: [Tablet]');
        return ['Tablet'];
      } else if (hasGenericCapsule) {
        // Only generic capsule
        print('🔍 Only generic capsule, returning: [Capsule]');
        return ['Capsule'];
      }
      
      print('🔍 No generic forms to filter, returning: $forms');
      return forms;
    }
    
    // Nếu medication có form data, sử dụng nó
    if (medication.form.isNotEmpty) {
      return [medication.form];
    }
    
    // Generate dosage forms list based on medication name with comprehensive detection
    final baseName = medication.name.toLowerCase();
    final forms = <String>[];
    
    // Comprehensive dosage form detection
    if (baseName.contains('sublingual')) {
      forms.add('Sublingual Tablet');
    }
    
    if (baseName.contains('buccal') && baseName.contains('film')) {
      forms.add('Buccal Film');
    }
    
    if (baseName.contains('chewable') || baseName.contains('chew')) {
      forms.add('Chewable Tablet');
    }
    
    if (baseName.contains('enteric') || baseName.contains('ec')) {
      forms.add('Enteric Coated Tablet');
    }
    
    if (baseName.contains('odt') || baseName.contains('orally disintegrating')) {
      forms.add('ODT Tablet');
    }
    
    if (baseName.contains('disintegrating')) {
      forms.add('Disintegrating Tablet');
    }
    
    if (baseName.contains('film coated') || baseName.contains('fc')) {
      forms.add('Film Coated Tablet');
    }
    
    if (baseName.contains('liquid-filled')) {
      forms.add('Liquid-filled Capsule');
    }
    
    if ((baseName.contains('extended') || baseName.contains('er') || baseName.contains('xr')) && 
        baseName.contains('capsule')) {
      forms.add('Extended Release Capsule');
    }
    
    if (baseName.contains('extended-release') && baseName.contains('disintegrating')) {
      forms.add('Extended-release Orally Disintegrating Tablet');
    }
    
    if (baseName.contains('xr-odt') || (baseName.contains('xr') && baseName.contains('odt'))) {
      forms.add('Extended-release Orally Disintegrating Tablet');
    }
    
    if ((baseName.contains('extended') || baseName.contains('er') || baseName.contains('xr')) && 
        baseName.contains('tablet')) {
      forms.add('Extended Release Tablet');
    }
    
    if ((baseName.contains('delayed') || baseName.contains('dr')) && 
        baseName.contains('capsule')) {
      forms.add('Delayed Release Capsule');
    }
    
    if ((baseName.contains('delayed') || baseName.contains('dr')) && 
        baseName.contains('tablet')) {
      forms.add('Delayed Release Tablet');
    }
    
    if (baseName.contains('capsule') || baseName.contains('cap')) {
      forms.add('Capsule');
    }
    
    // Only add generic Tablet if no specific tablet type was already added
    if ((baseName.contains('tablet') || baseName.contains('tab')) && 
        !forms.any((form) => form.toLowerCase().contains('tablet'))) {
      forms.add('Tablet');
    }
    
    // Remove duplicates while preserving order
    final uniqueForms = <String>[];
    for (final form in forms) {
      if (!uniqueForms.contains(form)) {
        uniqueForms.add(form);
      }
    }
    
    // If no dosage form found, use default form
    if (uniqueForms.isEmpty) {
      uniqueForms.add('Tablet'); // Default form
    }
    
    return uniqueForms;
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
