import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../services/language_service.dart';
import '../l10n/app_localizations.dart';
import 'referral_screen.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final languageService = Provider.of<LanguageService>(context);
    
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.primary,
        middle: Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.textWhite,
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
                    _buildProfileSection(l10n),
                    const SizedBox(height: 25),
                    
                    // General Settings
                    _buildGeneralSettings(l10n),
                    const SizedBox(height: 25),
                    
                    // App Settings
                    _buildAppSettings(l10n, languageService),
                    const SizedBox(height: 25),
                    
                    // Rewards
                    _buildRewardsSection(l10n),
                    const SizedBox(height: 25),
                    
                    // Support
                    _buildSupportSection(l10n),
                    const SizedBox(height: 25),
                    
                    // Danger Zone
                    _buildDangerZone(l10n),
                    const SizedBox(height: 30),
                    
                    // Footer
                    _buildFooter(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n) {
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
                  l10n.medicrushUser,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  l10n.userEmail,
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
            onPressed: () => _handleEditProfile(),
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
          icon: CupertinoIcons.bell,
          title: l10n.notifications,
          subtitle: l10n.notificationsSubtitle,
          trailing: CupertinoSwitch(
            value: _notifications,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
        ),
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
        _buildSettingItem(
          icon: CupertinoIcons.arrow_2_circlepath,
          title: l10n.autoSync,
          subtitle: l10n.autoSyncSubtitle,
          trailing: CupertinoSwitch(
            value: _autoSync,
            activeColor: AppColors.primary,
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

  Widget _buildAppSettings(AppLocalizations l10n, LanguageService languageService) {
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
          icon: CupertinoIcons.globe,
          title: l10n.language,
          subtitle: languageService.getCurrentLanguageName(),
          onTap: () => _showLanguageDialog(l10n, languageService),
        ),
        _buildSettingItem(
          icon: CupertinoIcons.textformat_size,
          title: l10n.fontSize,
          subtitle: l10n.fontSizeSubtitle,
          onTap: () => _handleAppAction('font'),
        ),
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

  Widget _buildRewardsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rewards,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: CupertinoIcons.person_2,
          title: l10n.inviteFriends,
          subtitle: l10n.inviteAndEarn,
          onTap: () => _handleRewardAction('invite_friends'),
          isReward: true,
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
          icon: CupertinoIcons.question_circle,
          title: l10n.help,
          subtitle: l10n.helpSubtitle,
          onTap: () => _handleSupportAction('help'),
        ),
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

  Widget _buildDangerZone(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.dangerZone,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.error,
          ),
        ),
        const SizedBox(height: 15),
        _buildSettingItem(
          icon: CupertinoIcons.square_arrow_right,
          title: l10n.logout,
          onTap: () => _handleLogout(l10n),
          isDanger: true,
        ),
        _buildSettingItem(
          icon: CupertinoIcons.delete_solid,
          title: l10n.deleteAccount,
          subtitle: l10n.deleteAccountSubtitle,
          onTap: () => _handleDeleteAccount(l10n),
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

  void _showLanguageDialog(AppLocalizations l10n, LanguageService languageService) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(l10n.selectLanguage),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                await languageService.changeLanguage('en');
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _showSuccessMessage(l10n.languageChanged);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.languageEnglish),
                  if (languageService.locale.languageCode == 'en')
                    const Icon(CupertinoIcons.check_mark, color: AppColors.primary),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await languageService.changeLanguage('vi');
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _showSuccessMessage(l10n.languageChanged);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.languageVietnamese),
                  if (languageService.locale.languageCode == 'vi')
                    const Icon(CupertinoIcons.check_mark, color: AppColors.primary),
                ],
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                await languageService.changeLanguage('fr');
                if (context.mounted) {
                  Navigator.of(context).pop();
                  _showSuccessMessage(l10n.languageChanged);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l10n.languageFrench),
                  if (languageService.locale.languageCode == 'fr')
                    const Icon(CupertinoIcons.check_mark, color: AppColors.primary),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(),
            isDefaultAction: true,
            child: Text(l10n.cancel),
          ),
        );
      },
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

  void _handleEditProfile() {
    _showSuccessMessage(AppLocalizations.of(context)!.edit);
  }

  void _handleAppAction(String action) {
    _showSuccessMessage('Action: $action');
  }

  void _handleSupportAction(String action) {
    _showSuccessMessage('Action: $action');
  }

  void _handleRewardAction(String action) {
    if (action == 'invite_friends') {
      Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (context) => const ReferralScreen(),
        ),
      );
    } else {
      _showSuccessMessage('Reward Action: $action');
    }
  }

  void _handleLogout(AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(l10n.logoutTitle),
          content: Text(l10n.logoutMessage),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage(l10n.loggedOut);
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAccount(AppLocalizations l10n) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(l10n.deleteAccountTitle),
          content: Text(l10n.deleteAccountMessage),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
                _showSuccessMessage(l10n.accountDeleted);
              },
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
  }
}
