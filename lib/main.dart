import 'package:finance_manager/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart'; // ✅ Correct provider package
import 'auth/auth_service.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/landing_screen.dart';
import 'theme/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const FinanceApp(),
    ),
  );
}

class FinanceApp extends StatelessWidget {
  const FinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme:
              themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: '/landing',
          routes: {
            '/landing': (context) => LandingScreen(),
            '/': (context) => const AuthWrapper(),
            '/profile': (context) => const ProfileScreen(),
            '/home': (context) => HomeScreen(),
            '/login_screen': (context) => LoginScreen(),
            '/registration_screen': (context) => RegisterScreen(),
          },
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return authService.user != null ? HomeScreen() : LoginScreen();
  }
}
