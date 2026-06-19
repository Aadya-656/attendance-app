// lib/main.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:clock_camera_v4/employee_managemnt/employee_controller.dart';
import 'ui/clock_screen.dart';
import 'ui/clock_controller.dart';
import 'login_1/auth_controller.dart';
import 'login_1/welcome_screen.dart';
import 'login_1/login_screen.dart';
import 'login_1/admin_login_screen.dart';
import 'login_1/signup_screen.dart';
import 'login_1/otp_screen.dart';
import 'login_1/app_theme.dart';
import 'login_1/splash_screen.dart';
import 'exec_dash_v1/dashboard_screen.dart';
import 'exec_dash_v1/controllers.dart';
import 'package:clock_camera_v4/mod_reports/report_view.dart';

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
        Get.put(EmployeeController());
      }),

      initialRoute: '/splash',

      getPages: [
        GetPage(name: '/splash',      page: () => const SplashScreen()),
        GetPage(name: '/welcome',     page: () => const WelcomeScreen()),
        GetPage(name: '/login',       page: () => const LoginScreen()),
        GetPage(name: '/admin-login', page: () => const AdminLoginScreen()),
        GetPage(name: '/signup',      page: () => const SignupScreen()),
        GetPage(name: '/otp',         page: () => const OtpScreen()),
        GetPage(name: '/clock',       page: () => const ClockScreen()),
        GetPage(name: '/dashboard',   page: () => const DashboardScreen()),
        GetPage(name: '/profile',     page: () => const ProfilePage()),
      ],
    );
  }
}

/// Attendance summary screen. Previously its own standalone app
/// (launched via a plain MaterialApp); now wired in as the '/profile'
/// route inside the shared GetMaterialApp above.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const bg = Color(0xffEEF2FA);
  static const card = Colors.white;
  static const primary = Color(0xff4D6BFF);
  static const text = Color(0xff222222);
  static const sub = Color(0xff777C85);

  final List<Color> calendarColors = const [
    Colors.green,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.blue,
    Colors.green,
    Colors.green,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.blue,
  ];

  final List<String> attendanceStatus = const [
    "Present",
    "Present",
    "Absent",
    "Others",
    "Others",
    "Present",
    "Others",
    "Present",
    "Absent",
    "Present",
    "Others",
    "Others",
    "Present",
    "Present",
    "Present",
    "Absent",
    "Others",
    "Others",
  ];

  Future<void> exportCSV(BuildContext context) async {
    try {
      PermissionStatus status = await Permission.storage.request();

      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Storage permission denied"),
          ),
        );
        return;
      }

      final List<List<dynamic>> rows = [];

      rows.add(["Day", "Status"]);

      for (int i = 0; i < attendanceStatus.length; i++) {
        rows.add(["Day ${i + 1}", attendanceStatus[i]]);
      }

      final csv = const ListToCsvConverter().convert(rows);

      final directory = Directory('/storage/emulated/0/Download');

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final path = "${directory.path}/attendance_report.csv";

      final file = File(path);

      await file.writeAsString(csv);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("CSV saved in Downloads folder"),
        ),
      );

      print("Saved at: $path");
    } catch (e) {
      print("Export error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Widget legend(Color c, String t) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: c,
        ),
        const SizedBox(width: 6),
        Text(
          t,
          style: const TextStyle(
            color: sub,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  BoxDecoration cardStyle() {
    return BoxDecoration(
      color: card,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 18,
          offset: const Offset(0, 6),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: cardStyle(),
                child: Row(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary.withOpacity(.15),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: primary,
                        size: 38,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Raghav Malhotra",
                            style: TextStyle(
                              color: text,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "BITS",
                            style: TextStyle(color: sub),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Chanakyapuri Home Office",
                            style: TextStyle(
                              color: sub,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: cardStyle(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Attendance",
                          style: TextStyle(
                            color: text,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: primary,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "JULY 2026",
                      style: TextStyle(
                        color: primary,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 35,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, i) {
                        Color c = Colors.grey.shade200;

                        if (i < calendarColors.length) {
                          c = calendarColors[i];
                        }

                        return Container(
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              "${i + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => ReportView());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: const Text("Reports"),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => exportCSV(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: primary),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: const Text(
                              "Export CSV",
                              style: TextStyle(color: primary),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Wrap(
                      spacing: 14,
                      runSpacing: 10,
                      children: [
                        legend(Colors.green, "Present"),
                        legend(Colors.red, "Absent"),
                        legend(Colors.blue, "Others"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}