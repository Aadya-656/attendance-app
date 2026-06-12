import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';
import 'attendance_section.dart';
import 'calendar_section.dart';
import 'package:clock_camera_v4/attendance_ver/verification_view.dart'; // adjust import path as needed
import 'package:clock_camera_v4/location_dir/location_directory_view.dart'; // adjust import path as needed
import 'package:clock_camera_v4/employee_managemnt/employee_management_view.dart'; // adjust import path as needed

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.bar_chart_rounded,
                  color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CRIS',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2),
                ),
                Text(
                  'Executive Dashboard',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFBDD5F5),
                      letterSpacing: 0.3),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 22),
            tooltip: 'Notifications',
            onPressed: () => SnackbarService.showComingSoon('Notifications'),
          ),
          IconButton(
            icon:
            const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
            tooltip: 'Filters',
            onPressed: () => SnackbarService.showComingSoon('Filters'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, left: 4),
            child: GestureDetector(
              onTap: () => SnackbarService.showComingSoon('Profile'),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Text(
                  'AD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => IndexedStack(
        index: nav.selectedTab.value,
        children: const [
          AttendanceSection(),
          CalendarSection(),
          _ReportsTab(),
        ],
      )),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border:
          Border(top: BorderSide(color: Color(0xFFE3E8F0), width: 1)),
        ),
        child: Obx(() => NavigationBar(
          selectedIndex: nav.selectedTab.value,
          onDestinationSelected: nav.changeTab,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFDEEAFC),
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.people_outline_rounded,
                  color: Color(0xFF6B7A99), size: 22),
              selectedIcon: Icon(Icons.people_rounded,
                  color: Color(0xFF1565C0), size: 22),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined,
                  color: Color(0xFF6B7A99), size: 22),
              selectedIcon: Icon(Icons.calendar_month_rounded,
                  color: Color(0xFF1565C0), size: 22),
              label: 'Calendar',
            ),
            NavigationDestination(
              icon: Icon(Icons.insert_chart_outlined_rounded,
                  color: Color(0xFF6B7A99), size: 22),
              selectedIcon: Icon(Icons.insert_chart_rounded,
                  color: Color(0xFF1565C0), size: 22),
              label: 'Reports',
            ),
          ],
        )),
      ),
    );
  }
}

// ── Reports Tab ───────────────────────────────────────────────────────────────

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2340),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Select a report to view',
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7A99)),
          ),
          const SizedBox(height: 24),
          _ReportTile(
            icon: Icons.fact_check_outlined,
            label: 'Attendance Verification',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VerificationView()),
            ),
          ),
          const SizedBox(height: 12),
          _ReportTile(
            icon: Icons.badge_outlined,
            label: 'Employee Management',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EmployeeManagementView()),
            ),
          ),
          const SizedBox(height: 12),
          _ReportTile(
            icon: Icons.location_on_outlined,
            label: 'Location Directory',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LocationDirectoryView()),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ReportTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE3E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF1565C0), size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1A2340),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: Color(0xFF6B7A99), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}