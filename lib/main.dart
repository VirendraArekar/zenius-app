import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/crm_repository.dart';
import 'data/repositories/attendance_repository.dart';
import 'data/repositories/activity_repository.dart';
import 'data/repositories/ai_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/crm_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/ai_chat_provider.dart';
import 'ui/screens/home_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final apiClient = ApiClient();
  final authRepo = AuthRepository(apiClient: apiClient);
  final crmRepo = CrmRepository(apiClient: apiClient);
  final attendanceRepo = AttendanceRepository(apiClient: apiClient);
  final activityRepo = ActivityRepository(apiClient: apiClient);
  final aiRepo = AiRepository(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository: authRepo)),
        ChangeNotifierProvider(create: (_) => DashboardProvider(crmRepository: crmRepo)),
        ChangeNotifierProvider(create: (_) => CrmProvider(crmRepository: crmRepo)),
        ChangeNotifierProvider(create: (_) => AttendanceProvider(attendanceRepository: attendanceRepo)),
        ChangeNotifierProvider(create: (_) => ActivityProvider(activityRepository: activityRepo)),
        ChangeNotifierProvider(create: (_) => AiChatProvider(aiRepository: aiRepo)),
      ],
      child: const ZeniusApp(),
    ),
  );
}

class ZeniusApp extends StatelessWidget {
  const ZeniusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return MaterialApp(
      title: 'Zenius One',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: auth.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeShell(),
    );
  }
}
