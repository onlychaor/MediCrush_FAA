import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/language_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageService = Provider.of<LanguageService>(context);
    
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.surface, // solid light background for readability
        middle: Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                    // Profile Section
                    _buildProfileSection(l10n, languageService),
                    const SizedBox(height: 25),
                    
                    // General Settings
                    _buildGeneralSettings(l10n),
                    const SizedBox(height: 25),
                    
                    // App Settings
                    _buildAppSettings(l10n),
                    const SizedBox(height: 25),
                    
                    
                    // Support
                    _buildSupportSection(l10n),
                    const SizedBox(height: 25),
                    
                    
                    // Footer
                    _buildFooter(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n, LanguageService languageService) {
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
              CupertinoIcons.person_fill,
              size: 30,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageService.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'user@medicrush.com',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showEditNameDialog(languageService),
            child: const Icon(
              CupertinoIcons.pencil,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.generalSettings,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: CupertinoIcons.moon,
          title: l10n.darkMode,
          subtitle: l10n.darkModeSubtitle,
          trailing: CupertinoSwitch(
            value: _darkMode,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettings(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.application,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: CupertinoIcons.cloud_download,
          title: l10n.download,
          subtitle: l10n.downloadSubtitle,
          onTap: () => _handleAppAction('downloads'),
        ),
        _buildSettingItem(
          icon: CupertinoIcons.trash,
          title: l10n.clearCache,
          subtitle: l10n.clearCacheSubtitle,
          onTap: () => _handleAppAction('cache'),
        ),
      ],
    );
  }

  Widget _buildSupportSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.support,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: CupertinoIcons.mail,
          title: l10n.contact,
          subtitle: l10n.contactSubtitle,
          onTap: () => _handleSupportAction('contact'),
        ),
        _buildSettingItem(
          icon: CupertinoIcons.star,
          title: l10n.rateApp,
          subtitle: l10n.rateAppSubtitle,
          onTap: () => _handleSupportAction('rate'),
        ),
        _buildSettingItem(
          icon: CupertinoIcons.info_circle,
          title: l10n.about,
          subtitle: l10n.aboutSubtitle,
          onTap: () => _handleSupportAction('about'),
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
    bool isReward = false,
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
      child: CupertinoListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDanger 
                ? AppColors.error.withOpacity(0.1)
                : isReward
                    ? AppColors.reward.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDanger 
                ? AppColors.error 
                : isReward
                    ? AppColors.reward
                    : AppColors.primary,
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
          CupertinoIcons.chevron_right,
          color: AppColors.textLight,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFooter(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            l10n.version,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            l10n.copyright,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  void _handleAppAction(String action) {
    _showSuccessMessage('Action: $action');
  }

  void _handleSupportAction(String action) async {
    if (action == 'contact') {
      try {
        final Uri emailUri = Uri.parse('mailto:info@getfreeaiapps.app');
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          _showSuccessMessage('Could not open email client');
        }
      } catch (e) {
        _showSuccessMessage('Error opening email: $e');
      }
    } else {
      _showSuccessMessage('Action: $action');
    }
  }

  void _showEditNameDialog(LanguageService languageService) {
    final controller = TextEditingController(text: languageService.userName);
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Edit Name'),
        content: Column(
          children: [
            const SizedBox(height: 8),
            CupertinoTextField(
              controller: controller,
              placeholder: 'Enter your name',
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await languageService.updateUserName(name);
              }
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
