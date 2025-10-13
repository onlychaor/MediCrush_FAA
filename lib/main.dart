import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'screens/splash_screen.dart';
import 'database/data_importer.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize language service
  final languageService = LanguageService();
  await languageService.initialize();
  
  // Force reload data from JSON to ensure fresh data
  try {
    final importer = DataImporter();
    await importer.forceReloadData();
    print('✅ Data loaded successfully');
  } catch (e) {
    print('⚠️ Data loading error: $e');
    // Fallback to ensureDataLoaded if forceReloadData fails
    try {
      final importer = DataImporter();
      await importer.ensureDataLoaded();
    } catch (e2) {
      print('❌ Critical error loading data: $e2');
    }
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => languageService,
      child: const MediCrushApp(),
    ),
  );
}

class MediCrushApp extends StatelessWidget {
  const MediCrushApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style - đồng bộ màu xanh với header
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return CupertinoApp(
          title: 'MediCrush',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.cupertinoTheme,
          locale: languageService.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LanguageService.supportedLocales,
          home: const SplashScreen(),
        );
      },
    );
  }
}