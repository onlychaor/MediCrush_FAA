import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = '';
  String _selectedPrivacy = 'public';

  final List<Map<String, dynamic>> _categories = [
    {'id': 'experience', 'name': 'Kinh nghiệm', 'icon': Icons.favorite},
    {'id': 'question', 'name': 'Câu hỏi', 'icon': Icons.help},
    {'id': 'info', 'name': 'Thông tin', 'icon': Icons.info},
    {'id': 'review', 'name': 'Đánh giá', 'icon': Icons.star},
  ];

  final List<Map<String, dynamic>> _privacyOptions = [
    {'id': 'public', 'name': 'Công khai', 'icon': Icons.public},
    {'id': 'friends', 'name': 'Bạn bè', 'icon': Icons.people},
    {'id': 'private', 'name': 'Riêng tư', 'icon': Icons.lock},
  ];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  const Text(
                    'Share with Community',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Share experiences, questions or useful information',
                    style: TextStyle(
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
                    _buildCategorySection(),
                    const SizedBox(height: 25),
                    
                    // Content Input
                    _buildContentSection(),
                    const SizedBox(height: 25),
                    
                    // Attachment Options
                    _buildAttachmentSection(),
                    const SizedBox(height: 25),
                    
                    // Privacy Settings
                    _buildPrivacySection(),
                    const SizedBox(height: 25),
                    
                    // Share Button
                    _buildShareButton(),
                    const SizedBox(height: 30),
                    
                    // Recent Shares
                    _buildRecentShares(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn danh mục',
          style: TextStyle(
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
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
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

  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nội dung chia sẻ',
          style: TextStyle(
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
          child: TextField(
            controller: _contentController,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Viết nội dung của bạn ở đây...',
              hintStyle: TextStyle(color: AppColors.textLight),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đính kèm',
          style: TextStyle(
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
                label: 'Hình ảnh',
                onTap: () => _handleAttachment('image'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttachmentButton(
                icon: Icons.attach_file,
                label: 'Tài liệu',
                onTap: () => _handleAttachment('document'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildAttachmentButton(
                icon: Icons.location_on,
                label: 'Vị trí',
                onTap: () => _handleAttachment('location'),
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

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quyền riêng tư',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: _privacyOptions.map((option) {
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

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleShare,
        icon: const Icon(Icons.send),
        label: const Text(
          'Chia sẻ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentShares() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chia sẻ gần đây',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildRecentItem(
          icon: Icons.favorite,
          title: 'Kinh nghiệm điều trị cảm cúm',
          time: '2 giờ trước',
        ),
        const SizedBox(height: 10),
        _buildRecentItem(
          icon: Icons.help,
          title: 'Câu hỏi về thuốc kháng sinh',
          time: '1 ngày trước',
        ),
        const SizedBox(height: 10),
        _buildRecentItem(
          icon: Icons.info,
          title: 'Thông tin về vaccine COVID-19',
          time: '3 ngày trước',
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

  void _handleAttachment(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn đính kèm: $type'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleShare() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập nội dung để chia sẻ'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn danh mục'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nội dung đã được chia sẻ thành công!'),
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
