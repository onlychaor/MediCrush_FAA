import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
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
      backgroundColor: AppColors.primaryLight, // Màu xanh nhạt như cũ
      body: SafeArea(
        child: Column(
          children: [
            // Nội dung chính
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    // Header: chỉ chứa tên thuốc
                    _buildMedicationHeader(),
                    const SizedBox(height: 30),
                    // Danh sách dạng bào chế
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

  Widget _buildMedicationHeader() {
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
    // debug logs removed for production
    
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
      // debug logs removed
      
      // Check if we should show all forms or filter generic ones
      final specificForms = forms.where((form) => 
        form.toLowerCase() != 'tablet' && 
        form.toLowerCase() != 'capsule').toList();
      
      // If there are both generic and specific forms, show all forms
      final hasGenericTablet = forms.any((form) => form.toLowerCase() == 'tablet');
      final hasGenericCapsule = forms.any((form) => form.toLowerCase() == 'capsule');
      
      if (specificForms.isNotEmpty && (hasGenericTablet || hasGenericCapsule)) {
        // Show all forms (both generic and specific)
        // debug logs removed
        return forms;
      } else if (specificForms.isNotEmpty) {
        // Only specific forms exist
        // debug logs removed
        return specificForms;
      }
      
      // Handle remaining cases
      if (hasGenericTablet && hasGenericCapsule) {
        // If both generic forms exist, return both
        // debug logs removed
        return forms;
      } else if (hasGenericTablet) {
        // Only generic tablet
        // debug logs removed
        return ['Tablet'];
      } else if (hasGenericCapsule) {
        // Only generic capsule
        // debug logs removed
        return ['Capsule'];
      }
      
      // debug logs removed
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
      color: AppColors.primaryLight, // Màu nền giống content, không tạo thanh riêng biệt
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Nút Report an issue ở góc phải dưới
          GestureDetector(
            onTap: () {
              _showReportSheet(context);
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportSheet(BuildContext context) {
    final TextEditingController descController = TextEditingController();
    final categories = <Map<String, String>>[
      {'id': 'wrong_data', 'name': 'Wrong data'},
      {'id': 'missing_data', 'name': 'Missing data'},
      {'id': 'translation', 'name': 'Translation'},
      {'id': 'ui_bug', 'name': 'UI / Bug'},
      {'id': 'improvement', 'name': 'Improvement'},
    ];
    String selected = 'wrong_data';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        final pickedImages = <XFile>[];
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.report_gmailerrorred, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Report an issue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Category', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in categories)
                      ChoiceChip(
                        label: Text(c['name']!),
                        selected: selected == c['id'],
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: selected == c['id'] ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (v) => setModalState(() => selected = c['id']!),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text('Description', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe the issue...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final imgs = await picker.pickMultiImage(imageQuality: 85);
                        if (imgs.isNotEmpty) {
                          setModalState(() {
                            pickedImages.clear();
                            pickedImages.addAll(imgs);
                          });
                        }
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add images'),
                    ),
                    const SizedBox(width: 12),
                    if (pickedImages.isNotEmpty)
                      Text('${pickedImages.length} selected', style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                if (pickedImages.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: pickedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(File(pickedImages[i].path), width: 70, height: 70, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final desc = descController.text.trim();
                          if (desc.isEmpty) {
                            ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Please enter description')));
                            return;
                          }
                          final text = '[MediCrush] Issue - ${medication.name} - $selected\n\n' + desc;
                          if (pickedImages.isNotEmpty) {
                            await Share.shareXFiles(pickedImages, text: text, subject: 'MediCrush Issue');
                          } else {
                            await Share.share(text, subject: 'MediCrush Issue');
                          }
                          if (ctx.mounted) Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // removed context builder per request
}
