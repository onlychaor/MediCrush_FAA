import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/app_colors.dart';
import '../models/medication.dart';
import 'tubes_feeding_screen.dart';

class DosageFormDetailScreen extends StatelessWidget {
  final Medication medication;
  final String dosageForm;

  const DosageFormDetailScreen({
    super.key,
    required this.medication,
    required this.dosageForm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight, // Màu xanh nhạt như cũ
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40), // Space from top
                    
                    // Main medication name
                    _buildMedicationName(),
                    const SizedBox(height: 30),
                    
                    // Form information block
                    _buildFormSection(context),
                    const SizedBox(height: 20),
                    
                    // Alteration information block
                    _buildAlterationSection(context),
                    
                    const SizedBox(height: 80), // Space for bottom navigation
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation Bar
            _buildBottomNavigation(context),
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

  Widget _buildFormSection(BuildContext context) {
    // Find corresponding dosage form
    String formToDisplay = dosageForm;
    if (medication.dosageForms.isNotEmpty) {
      final matchingForm = medication.dosageForms.firstWhere(
        (df) => df.form == dosageForm,
        orElse: () => medication.dosageForms.first,
      );
      formToDisplay = matchingForm.form;
    } else if (medication.form.isNotEmpty) {
      formToDisplay = medication.form;
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TubesFeedingScreen(medication: medication),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Form',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    formToDisplay,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlterationSection(BuildContext context) {
    // Find alteration from corresponding dosageForm
    List<String> alterations;
    
    if (medication.dosageForms.isNotEmpty) {
      final matchingForm = medication.dosageForms.firstWhere(
        (df) => df.form == dosageForm,
        orElse: () => medication.dosageForms.first,
      );
      alterations = matchingForm.alteration.isNotEmpty 
          ? [matchingForm.alteration]
          : _generateAlterations();
    } else if (medication.alteration.isNotEmpty) {
      alterations = [medication.alteration];
    } else {
      alterations = _generateAlterations();
    }
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TubesFeedingScreen(medication: medication),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alteration:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...alterations.map((alteration) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      alteration,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<String> _generateAlterations() {
    final form = dosageForm.toLowerCase();
    final alterations = <String>[];
    
    if (form.contains('extended release') || form.contains('er') || form.contains('xr')) {
      alterations.addAll([
        'Do not crush',
        'Do not chew',
        'Swallow whole with water',
      ]);
    } else if (form.contains('delayed release') || form.contains('dr')) {
      alterations.addAll([
        'Do not crush',
        'Do not chew',
        'Swallow whole with water',
      ]);
    } else if (form.contains('sprinkle')) {
      alterations.addAll([
        'May be opened and sprinkled on food',
        'Do not crush the contents',
      ]);
    } else if (form.contains('tablet')) {
      alterations.addAll([
        'May be split in half at scored line',
        'Do not crush unless directed',
      ]);
    } else if (form.contains('capsule')) {
      alterations.addAll([
        'Swallow whole with water',
        'Do not open unless directed',
      ]);
    } else {
      // Default
      alterations.addAll([
        'Follow package instructions',
        'Consult pharmacist if unsure',
      ]);
    }
    
    return alterations;
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      color: AppColors.primaryLight, // Màu nền giống content, không tạo thanh riêng biệt
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home button at bottom left
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
              
              // Report an issue button at bottom right
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
        ),
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
                          final text = '[MediCrush] Issue - ${medication.name} ($dosageForm) - $selected\n\n' + desc;
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
}
