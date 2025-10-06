import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoSync = true;

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
                    'Settings',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Manage account and app preferences',
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
                    // Profile Section
                    _buildProfileSection(),
                    const SizedBox(height: 25),
                    
                    // General Settings
                    _buildGeneralSettings(),
                    const SizedBox(height: 25),
                    
                    // Account Settings
                    _buildAccountSettings(),
                    const SizedBox(height: 25),
                    
                    // App Settings
                    _buildAppSettings(),
                    const SizedBox(height: 25),
                    
                    // Support
                    _buildSupportSection(),
                    const SizedBox(height: 25),
                    
                    // Danger Zone
                    _buildDangerZone(),
                    const SizedBox(height: 30),
                    
                    // Footer
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Người dùng MediCrush',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'user@medicrush.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _handleEditProfile(),
            icon: const Icon(
              Icons.edit,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cài đặt chung',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: Icons.notifications,
          title: 'Thông báo',
          subtitle: 'Nhận thông báo về cập nhật và tin tức',
          trailing: Switch(
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
        ),
        _buildSettingItem(
          icon: Icons.dark_mode,
          title: 'Chế độ tối',
          subtitle: 'Giao diện tối cho mắt dễ chịu hơn',
          trailing: Switch(
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
        ),
        _buildSettingItem(
          icon: Icons.sync,
          title: 'Đồng bộ tự động',
          subtitle: 'Tự động đồng bộ dữ liệu',
          trailing: Switch(
            value: _autoSync,
            onChanged: (value) {
              setState(() {
                _autoSync = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tài khoản',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: Icons.person,
          title: 'Thông tin cá nhân',
          subtitle: 'Chỉnh sửa thông tin tài khoản',
          onTap: () => _handleAccountAction('profile'),
        ),
        _buildSettingItem(
          icon: Icons.lock,
          title: 'Đổi mật khẩu',
          subtitle: 'Cập nhật mật khẩu bảo mật',
          onTap: () => _handleAccountAction('password'),
        ),
        _buildSettingItem(
          icon: Icons.security,
          title: 'Bảo mật',
          subtitle: 'Cài đặt bảo mật và quyền riêng tư',
          onTap: () => _handleAccountAction('security'),
        ),
      ],
    );
  }

  Widget _buildAppSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ứng dụng',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: Icons.language,
          title: 'Ngôn ngữ',
          subtitle: 'Tiếng Việt',
          onTap: () => _handleAppAction('language'),
        ),
        _buildSettingItem(
          icon: Icons.text_fields,
          title: 'Cỡ chữ',
          subtitle: 'Trung bình',
          onTap: () => _handleAppAction('font'),
        ),
        _buildSettingItem(
          icon: Icons.download,
          title: 'Tải xuống',
          subtitle: 'Quản lý dữ liệu đã tải',
          onTap: () => _handleAppAction('downloads'),
        ),
        _buildSettingItem(
          icon: Icons.delete,
          title: 'Xóa bộ nhớ đệm',
          subtitle: 'Giải phóng dung lượng',
          onTap: () => _handleAppAction('cache'),
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hỗ trợ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: Icons.help,
          title: 'Trợ giúp',
          subtitle: 'Câu hỏi thường gặp và hướng dẫn',
          onTap: () => _handleSupportAction('help'),
        ),
        _buildSettingItem(
          icon: Icons.email,
          title: 'Liên hệ',
          subtitle: 'Gửi phản hồi cho chúng tôi',
          onTap: () => _handleSupportAction('contact'),
        ),
        _buildSettingItem(
          icon: Icons.star,
          title: 'Đánh giá ứng dụng',
          subtitle: 'Chia sẻ trải nghiệm của bạn',
          onTap: () => _handleSupportAction('rate'),
        ),
        _buildSettingItem(
          icon: Icons.info,
          title: 'Về ứng dụng',
          subtitle: 'Phiên bản 1.0.0',
          onTap: () => _handleSupportAction('about'),
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khu vực nguy hiểm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Đăng xuất',
          onTap: () => _handleLogout(),
          isDanger: true,
        ),
        _buildSettingItem(
          icon: Icons.delete_forever,
          title: 'Xóa tài khoản',
          subtitle: 'Xóa vĩnh viễn tài khoản và dữ liệu',
          onTap: () => _handleDeleteAccount(),
          isDanger: true,
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDanger = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDanger 
                ? AppColors.error.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDanger ? AppColors.error : AppColors.primary,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDanger ? AppColors.error : AppColors.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        trailing: trailing ?? const Icon(
          Icons.chevron_right,
          color: AppColors.textLight,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Column(
        children: [
          Text(
            'MediCrush v1.0.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 5),
          Text(
            '© 2024 MediCrush Team',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _handleEditProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chỉnh sửa thông tin cá nhân'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleAccountAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn: $action'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleAppAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn: $action'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleSupportAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã chọn: $action'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã đăng xuất'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa tài khoản'),
          content: const Text(
            'Hành động này không thể hoàn tác. Bạn có chắc chắn muốn xóa tài khoản?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tài khoản đã được xóa'),
                    backgroundColor: AppColors.error,
                  ),
                );
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
