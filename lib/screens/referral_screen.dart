import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final String _inviteCode = 'MEDI2024';
  int _friendsInvited = 0; // Reset to 0 - only successful invites
  int _pendingInvites = 0; // Reset to 0 - pending invites
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          l10n.referralProgram,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: AppColors.textWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Header Section
              _buildHeaderSection(l10n),
              const SizedBox(height: 30),
              
              // Invite Code Section
              _buildInviteCodeSection(l10n),
              const SizedBox(height: 30),
              
              // Send Invite Section
              _buildSendInviteSection(l10n),
              const SizedBox(height: 30),
              
              // Share Options
              _buildShareOptions(l10n),
              const SizedBox(height: 30),
              
              // Milestones Section
              _buildMilestonesSection(l10n),
              const SizedBox(height: 30),
              
              // Progress Section
              _buildProgressSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              CupertinoIcons.person_2_fill,
              size: 25,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.inviteAndEarn,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${l10n.successfulInvites}: $_friendsInvited',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${l10n.pendingInvites}: $_pendingInvites',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteCodeSection(AppLocalizations l10n) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourInviteCode,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _inviteCode,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  onPressed: () => _copyInviteCode(l10n),
                  child: Text(
                    l10n.copyCode,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendInviteSection(AppLocalizations l10n) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.inviteDetails,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          
          // Contact input
          Text(
            l10n.sendInviteTo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _contactController,
            placeholder: l10n.enterPhoneOrEmail,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 15),
          
          // Custom message
          Text(
            l10n.customMessage,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          CupertinoTextField(
            controller: _messageController,
            placeholder: l10n.writePersonalMessage,
            maxLines: 3,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          
          // Send button
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              onPressed: () => _sendInvite(l10n),
              child: Text(
                l10n.sendInvite,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShareOptions(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.shareInviteCode,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _shareViaWhatsApp(l10n),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.textWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    CupertinoIcons.share,
                    color: AppColors.textWhite,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.shareInviteCode,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildShareButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.textWhite,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesSection(AppLocalizations l10n) {
    final milestones = [
      {'count': 10, 'points': 100, 'claimed': _friendsInvited >= 10},
      {'count': 20, 'points': 250, 'claimed': _friendsInvited >= 20},
      {'count': 50, 'points': 750, 'claimed': _friendsInvited >= 50},
      {'count': 100, 'points': 2000, 'claimed': _friendsInvited >= 100},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.referralMilestones,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        ...milestones.map((milestone) => _buildMilestoneItem(
          l10n,
          milestone['count'] as int,
          milestone['points'] as int,
          milestone['claimed'] as bool,
        )),
      ],
    );
  }

  Widget _buildMilestoneItem(AppLocalizations l10n, int count, int points, bool claimed) {
    final isAchieved = _friendsInvited >= count;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: claimed 
            ? AppColors.success.withOpacity(0.1)
            : isAchieved 
                ? AppColors.primary.withOpacity(0.1)
                : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: claimed 
              ? AppColors.success
              : isAchieved 
                  ? AppColors.primary
                  : AppColors.border,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: claimed 
                  ? AppColors.success
                  : isAchieved 
                      ? AppColors.primary
                      : AppColors.textLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              claimed 
                  ? CupertinoIcons.check_mark
                  : isAchieved 
                      ? CupertinoIcons.gift_fill
                      : CupertinoIcons.lock_fill,
              color: AppColors.textWhite,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count ${l10n.friendsInvited}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: claimed 
                        ? AppColors.success
                        : isAchieved 
                            ? AppColors.primary
                            : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$points Points',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isAchieved && !claimed)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              onPressed: () => _claimMilestone(l10n, count, points),
              child: Text(
                l10n.claimMilestone,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (claimed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.milestoneClaimed,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(AppLocalizations l10n) {
    final nextMilestone = _getNextMilestone();
    final progress = _friendsInvited / nextMilestone;
    
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.progressToNextMilestone,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '$_friendsInvited / $nextMilestone friends',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8,
          ),
          const SizedBox(height: 10),
          Text(
            '${(progress * 100).toInt()}% complete',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  int _getNextMilestone() {
    if (_friendsInvited < 10) return 10;
    if (_friendsInvited < 20) return 20;
    if (_friendsInvited < 50) return 50;
    return 100;
  }

  void _copyInviteCode(AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: _inviteCode));
    _showSuccessMessage(l10n.codeCopied);
  }

  void _sendInvite(AppLocalizations l10n) {
    if (_contactController.text.isEmpty) {
      _showSuccessMessage(l10n.pleaseEnterContact);
      return;
    }
    
    setState(() {
      _pendingInvites++;
    });
    
    _contactController.clear();
    _messageController.clear();
    
    _showSuccessMessage(l10n.inviteSentSuccessfully);
  }

  void _shareViaWhatsApp(AppLocalizations l10n) {
    _showSuccessMessage(l10n.sharingViaWhatsApp);
  }

  void _shareViaSMS(AppLocalizations l10n) {
    _showSuccessMessage(l10n.sharingViaSMS);
  }

  void _shareViaEmail(AppLocalizations l10n) {
    _showSuccessMessage(l10n.sharingViaEmail);
  }

  void _claimMilestone(AppLocalizations l10n, int count, int points) {
    _showSuccessMessage('${l10n.claimed} $points ${l10n.points} ${l10n.forMilestone} $count ${l10n.friends}!');
  }

  void _showSuccessMessage(String message) {
    final l10n = AppLocalizations.of(context)!;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}
