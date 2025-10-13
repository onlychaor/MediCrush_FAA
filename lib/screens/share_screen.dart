import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = '';

  List<Map<String, dynamic>> _getCategories(AppLocalizations l10n) {
    return [
      {'id': 'medication_info', 'name': l10n.medicationInfo, 'icon': Icons.medication, 'color': AppColors.primary},
      {'id': 'treatment_experience', 'name': l10n.treatmentExperience, 'icon': Icons.healing, 'color': AppColors.primary},
      {'id': 'side_effects', 'name': l10n.sideEffects, 'icon': Icons.warning, 'color': AppColors.primary},
      {'id': 'medical_question', 'name': l10n.medicalQuestion, 'icon': Icons.help_outline, 'color': AppColors.primary},
      {'id': 'drug_review', 'name': l10n.drugReview, 'icon': Icons.star_rate, 'color': AppColors.primary},
      {'id': 'medical_reference', 'name': l10n.medicalReference, 'icon': Icons.library_books, 'color': AppColors.primary},
    ];
  }


  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    l10n.shareWithCommunity,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.shareExperiences,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textWhite,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            // Nội dung chính
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Selection
                    _buildCategorySection(l10n),
                    const SizedBox(height: 25),
                    
                    // Content Input
                    _buildContentSection(l10n),
                    const SizedBox(height: 25),
                    
                    // Share Button
                    _buildShareButton(l10n),
                    const SizedBox(height: 30),
                    
                    // Recent Shares (chỉ hiện khi có dữ liệu)
                    if (_hasRecentShares()) ...[
                      _buildRecentShares(l10n),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(AppLocalizations l10n) {
    final categories = _getCategories(l10n);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectCategory,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = _selectedCategory == category['id'];
            
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category['id'];
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? category['color'] : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? category['color'] : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: category['color'].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ] : const [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category['icon'],
                      size: 24,
                      color: isSelected ? AppColors.textWhite : category['color'],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContentSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shareContent,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: CupertinoTextField(
            controller: _contentController,
            maxLines: 8,
            placeholder: _getContentPlaceholder(l10n),
            placeholderStyle: const TextStyle(color: AppColors.textLight),
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(15),
          ),
        ),
      ],
    );
  }



  Widget _buildShareButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: () => _handleShare(l10n),
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(25),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.paperplane, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.shareButton,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentShares(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentShares,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildRecentItem(
          icon: Icons.favorite,
          title: l10n.coldTreatmentExperience,
          time: '2 ${l10n.hoursAgo}',
        ),
        const SizedBox(height: 10),
        _buildRecentItem(
          icon: Icons.help,
          title: l10n.antibioticQuestion,
          time: '1 ${l10n.dayAgo}',
        ),
        const SizedBox(height: 10),
        _buildRecentItem(
          icon: Icons.info,
          title: l10n.covidVaccineInfo,
          time: '3 ${l10n.daysAgo}',
        ),
      ],
    );
  }

  Widget _buildRecentItem({
    required IconData icon,
    required String title,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _handleShare(AppLocalizations l10n) {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseEnterContent),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.pleaseSelectCategory),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    // Xử lý chia sẻ theo loại
    _processMedicalShare(l10n);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getSuccessMessage()),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Reset form
    _contentController.clear();
    setState(() {
      _selectedCategory = '';
    });
  }

  void _processMedicalShare(AppLocalizations l10n) {
    // Xử lý logic chia sẻ theo loại y tế
    switch (_selectedCategory) {
      case 'medication_info':
        _shareMedicationInfo();
        break;
      case 'treatment_experience':
        _shareTreatmentExperience();
        break;
      case 'side_effects':
        _shareSideEffects();
        break;
      case 'medical_question':
        _shareMedicalQuestion();
        break;
      case 'drug_review':
        _shareDrugReview();
        break;
      case 'medical_reference':
        _shareMedicalReference();
        break;
    }
  }

  void _shareMedicationInfo() {
    // Logic chia sẻ thông tin thuốc
    print('Chia sẻ thông tin thuốc: ${_contentController.text}');
  }

  void _shareTreatmentExperience() {
    // Logic chia sẻ kinh nghiệm điều trị
    print('Chia sẻ kinh nghiệm điều trị: ${_contentController.text}');
  }

  void _shareSideEffects() {
    // Logic chia sẻ tác dụng phụ
    print('Báo cáo tác dụng phụ: ${_contentController.text}');
  }

  void _shareMedicalQuestion() {
    // Logic chia sẻ câu hỏi y tế
    print('Câu hỏi y tế: ${_contentController.text}');
  }

  void _shareDrugReview() {
    // Logic chia sẻ đánh giá thuốc
    print('Đánh giá thuốc: ${_contentController.text}');
  }

  void _shareMedicalReference() {
    // Logic chia sẻ tài liệu y tế
    print('Tài liệu y tế: ${_contentController.text}');
  }

  String _getSuccessMessage() {
    switch (_selectedCategory) {
      case 'medication_info':
        return '✅ Đã chia sẻ thông tin thuốc thành công!';
      case 'treatment_experience':
        return '✅ Cảm ơn bạn đã chia sẻ kinh nghiệm điều trị!';
      case 'side_effects':
        return '✅ Báo cáo tác dụng phụ đã được ghi nhận!';
      case 'medical_question':
        return '✅ Câu hỏi y tế đã được đăng!';
      case 'drug_review':
        return '✅ Đánh giá thuốc đã được chia sẻ!';
      case 'medical_reference':
        return '✅ Tài liệu y tế đã được chia sẻ!';
      default:
        return '✅ Chia sẻ thành công!';
    }
  }

  bool _hasRecentShares() {
    // Trong thực tế, bạn sẽ kiểm tra từ database hoặc local storage
    // Hiện tại return false để ẩn section này
    return false;
  }

  String _getContentPlaceholder(AppLocalizations l10n) {
    switch (_selectedCategory) {
      case 'medication_info':
        return l10n.shareMedicationInfo;
      case 'treatment_experience':
        return l10n.shareTreatmentExperience;
      case 'side_effects':
        return l10n.reportSideEffects;
      case 'medical_question':
        return l10n.askMedicalQuestion;
      case 'drug_review':
        return l10n.reviewDrugEffectiveness;
      case 'medical_reference':
        return l10n.shareMedicalReference;
      default:
        return l10n.writeContentHere;
    }
  }
}
