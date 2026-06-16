import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:clock_camera_v4/mod_reports/report_view.dart';

import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller = Get.put(ProfileController());

  static const Color _bg      = Color(0xFFF5F5F7);
  static const Color _card    = Colors.white;
  static const Color _primary = Color(0xFF2563EB);
  static const Color _text    = Color(0xFF111111);
  static const Color _sub     = Color(0xFF888888);

  // ── Sample attendance data (replace with real data from your API) ────────────
  // true = present, false = absent, null = future / weekend
  static final Map<int, bool?> _attendance = {
    1: true,  2: true,  3: false, 4: true,  5: true,
    8: true,  9: true,  10: true, 11: false, 12: true,
    15: true, 16: true,
  };

  static const int _totalDays     = 16; // working days elapsed
  static const int _presentDays   = 13;
  static const int _absentDays    = 3;
  static const double _percentage = 81.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _text, size: 20),
        ),
        title: const Text('Profile',
            style: TextStyle(
                color: _text,
                fontWeight: FontWeight.w700,
                fontSize: 17)),
      ),
      body: Obx(() {
        if (controller.profile.value == null) {
          return const Center(child: CircularProgressIndicator(color: _primary));
        }
        final user = controller.profile.value!;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(user),
              const SizedBox(height: 20),
              _summaryRow(),
              const SizedBox(height: 20),
              _calendarCard(),
              const SizedBox(height: 20),
              _reportButton(),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  // ── Profile header card ────────────────────────────────────────────────────
  Widget _profileCard(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _text)),
                const SizedBox(height: 3),
                Text(user.designation,
                    style: const TextStyle(fontSize: 14, color: _sub)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_city_outlined,
                        size: 13, color: _sub),
                    const SizedBox(width: 4),
                    Text(user.office,
                        style:
                        const TextStyle(fontSize: 13, color: _sub)),
                  ],
                ),
                const SizedBox(height: 3),
                const Row(
                  children: [
                    Icon(Icons.school_outlined, size: 13, color: _sub),
                    SizedBox(width: 4),
                    Text('Home Org: BITS Pilani',
                        style: TextStyle(fontSize: 13, color: _sub)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary tiles ──────────────────────────────────────────────────────────
  Widget _summaryRow() {
    return Row(
      children: [
        _summaryTile('$_presentDays', 'Present', const Color(0xFF2563EB),
            const Color(0xFFEFF6FF)),
        const SizedBox(width: 12),
        _summaryTile('$_absentDays', 'Absent', const Color(0xFFDC2626),
            const Color(0xFFFFF3F3)),
        const SizedBox(width: 12),
        _summaryTile('${_percentage.toStringAsFixed(0)}%', 'Rate',
            const Color(0xFF059669), const Color(0xFFECFDF5)),
      ],
    );
  }

  Widget _summaryTile(
      String value, String label, Color valueColor, Color bg) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: valueColor)),
            const SizedBox(height: 3),
            Text(label,
                style:
                const TextStyle(fontSize: 12, color: _sub)),
          ],
        ),
      ),
    );
  }

  // ── Calendar card ──────────────────────────────────────────────────────────
  Widget _calendarCard() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    // weekday: Mon=1 … Sun=7; shift so Sun=0
    final startOffset = (firstDay.weekday % 7); // 0=Sun,1=Mon…6=Sat

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined,
                  size: 17, color: _sub),
              const SizedBox(width: 6),
              Text(
                _monthName(now.month) + ' ${now.year}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _sub),
              ),
              const Spacer(),
              _legendDot(const Color(0xFF2563EB), 'Present'),
              const SizedBox(width: 10),
              _legendDot(const Color(0xFFDC2626), 'Absent'),
            ],
          ),
          const SizedBox(height: 16),

          // Day-of-week headers
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map((d) => Expanded(
              child: Center(
                child: Text(d,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _sub)),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 10),

          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemCount: startOffset + daysInMonth,
            itemBuilder: (_, i) {
              if (i < startOffset) return const SizedBox();
              final day = i - startOffset + 1;
              final status = _attendance[day];
              final isToday = day == now.day;
              final isFuture = day > now.day;

              Color bg;
              Color textColor;

              if (isToday) {
                bg = _primary;
                textColor = Colors.white;
              } else if (isFuture || status == null) {
                bg = const Color(0xFFF0F0F0);
                textColor = const Color(0xFFBBBBBB);
              } else if (status == true) {
                bg = const Color(0xFFEFF6FF);
                textColor = _primary;
              } else {
                bg = const Color(0xFFFFF3F3);
                textColor = const Color(0xFFDC2626);
              }

              return Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(7),
                  border: isToday
                      ? Border.all(color: _primary.withValues(alpha: 0.4), width: 1.5)
                      : null,
                ),
                child: Center(
                  child: Text('$day',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: textColor)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(fontSize: 11, color: _sub)),
      ],
    );
  }

  // ── View full report button ────────────────────────────────────────────────
  Widget _reportButton() {
    return GestureDetector(
      onTap: () => Get.to(() => ReportView()),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('View Full Report',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  BoxDecoration _cardDecor() => BoxDecoration(
    color: _card,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 6))
    ],
  );

  String _monthName(int m) => const [
    '', 'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ][m];
}