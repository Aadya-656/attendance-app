// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/clock_screen.dart';
import 'ui/clock_controller.dart';
import 'login_1/auth_controller.dart';
import 'login_1/welcome_screen.dart';
import 'login_1/login_screen.dart';
import 'login_1/admin_login_screen.dart';
import 'login_1/signup_screen.dart';
import 'login_1/otp_screen.dart';
import 'login_1/app_theme.dart';
import 'exec_dash_v1/dashboard_screen.dart';
import 'exec_dash_v1/controllers.dart';
import 'modules/profile_view.dart';
import 'modules/profile_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Attendance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(ClockController());
        Get.put(NavController());
        Get.put(CalendarController());
      }),
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/welcome',     page: () => const WelcomeScreen()),
        GetPage(name: '/login',       page: () => const LoginScreen()),
        GetPage(name: '/admin-login', page: () => const AdminLoginScreen()),
        GetPage(name: '/signup',      page: () => const SignupScreen()),
        GetPage(name: '/otp',         page: () => const OtpScreen()),
        GetPage(name: '/clock',       page: () => const ClockScreen()),
        GetPage(name: '/dashboard',   page: () => const DashboardScreen()),
        GetPage(name: '/profile',     page: () => ProfileView()),
      ],
    );
  }
}