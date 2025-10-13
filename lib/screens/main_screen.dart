import 'package:flutter/cupertino.dart';
import 'home_screen.dart';
import 'share_screen.dart';
import 'settings_screen.dart';
import '../theme/app_colors.dart';
import '../l10n/app_localizations.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppColors.surface,
        activeColor: AppColors.primary,
        inactiveColor: AppColors.textLight,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.home),
            activeIcon: const Icon(CupertinoIcons.house_fill),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.share),
            activeIcon: const Icon(CupertinoIcons.share_solid),
            label: l10n.share,
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.settings),
            activeIcon: const Icon(CupertinoIcons.settings_solid),
            label: l10n.settings,
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeScreen();
          case 1:
            return const ShareScreen();
          case 2:
            return const SettingsScreen();
          default:
            return const HomeScreen();
        }
      },
    );
  }
}
