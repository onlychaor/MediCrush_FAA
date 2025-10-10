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
  String _selectedPrivacy = 'public';

  List<Map<String, dynamic>> _getCategories(AppLocalizations l10n) {
    return [
      {'id': 'experience', 'name': l10n.experience, 'icon': Icons.favorite},
      {'id': 'question', 'name': l10n.question, 'icon': Icons.help},
      {'id': 'info', 'name': l10n.info, 'icon': Icons.info},
      {'id': 'review', 'name': l10n.review, 'icon': Icons.star},
    ];
  }

  List<Map<String, dynamic>> _getPrivacyOptions(AppLocalizations l10n) {
    return [
      {'id': 'public', 'name': l10n.public, 'icon': Icons.public},
      {'id': 'friends', 'name': l10n.friends, 'icon': Icons.people},
      {'id': 'private', 'name': l10n.private, 'icon': Icons.lock},
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
                    
                    // Attachment Options
                    _buildAttachmentSection(l10n),
                    const SizedBox(height: 25),
                    
                    // Privacy Settings
                    _buildPrivacySection(l10n),
                    const SizedBox(height: 25),
                    
                    // Share Button
                    _buildShareButton(l10n),
                    const SizedBox(height: 30),
                    
                    // Recent Shares
                    _buildRecentShares(l10n),
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
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: const [
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
                      color: isSelected ? AppColors.textWhite : AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.textWhite : AppColors.primary,
                      ),
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
            placeholder: l10n.writeContentHere,
            placeholderStyle: const TextStyle(color: AppColors.textLight),
            decoration: const BoxDecoration(),
            padding: const EdgeInsets.all(15),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.attachments,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildAttachmentButton(
                icon: Icons.camera_alt,
                label: l10n.image,
                onTap: () => _handleAttachment('image', l10n),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttachmentButton(
                icon: Icons.attach_file,
                label: l10n.document,
                onTap: () => _handleAttachment('document', l10n),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttachmentButton(
                icon: Icons.location_on,
                label: l10n.location,
                onTap: () => _handleAttachment('location', l10n),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacySection(AppLocalizations l10n) {
    final privacyOptions = _getPrivacyOptions(l10n);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.privacy,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: privacyOptions.map((option) {
            final isSelected = _selectedPrivacy == option['id'];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPrivacy = option['id'];
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        option['icon'],
                        size: 20,
                        color: isSelected ? AppColors.textWhite : AppColors.primary,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        option['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.textWhite : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
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

  void _handleAttachment(String type, AppLocalizations l10n) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.attachmentSelected}: $type'),
        backgroundColor: AppColors.primary,
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
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.shareSuccess),
        backgroundColor: AppColors.success,
      ),
    );
    
    // Reset form
    _contentController.clear();
    setState(() {
      _selectedCategory = '';
      _selectedPrivacy = 'public';
    });
  }
}
