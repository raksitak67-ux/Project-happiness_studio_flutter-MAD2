import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'services/app_database.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.instance.database;
  runApp(const HappinessStudioApp());
}

class HappinessStudioApp extends StatelessWidget {
  const HappinessStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Happiness Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const LoginScreen(),
    );
  }
}
