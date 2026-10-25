import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/event_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize persistent Local Storage (SharedPreferences)
  final storageService = await StorageService.init();
  final apiService = ApiService();
  final notificationService = NotificationService();

  runApp(
    CampusEventHubApp(
      storageService: storageService,
      apiService: apiService,
      notificationService: notificationService,
    ),
  );
}

class CampusEventHubApp extends StatelessWidget {
  final StorageService storageService;
  final ApiService apiService;
  final NotificationService notificationService;

  const CampusEventHubApp({
    super.key,
    required this.storageService,
    required this.apiService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storageService),
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(storageService),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(storageService),
        ),
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(
            storageService,
            apiService,
            notificationService,
          ),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'CampusEventHub',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: SplashScreen(storageService: storageService),
          );
        },
      ),
    );
  }
}
