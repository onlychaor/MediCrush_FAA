import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'database/data_importer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  
  runApp(const MediCrushApp());
}

class MediCrushApp extends StatelessWidget {
  const MediCrushApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'MediCrush',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}