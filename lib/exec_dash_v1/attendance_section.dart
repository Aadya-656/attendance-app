import 'package:flutter/material.dart';
import 'controllers.dart';
import 'package:clock_camera_v4/attendance_ver/verification_view.dart';
import 'package:clock_camera_v4/employee_managemnt/add_employee_view.dart';

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  // ── Mock data ────────────────────────────────────────────────────────────────
  static const int totalEmployees = 1240;
  static const int clockedIn = 1087;
  static const int onLeave = 43;
  static const int absent = 71;

  static const List<Map<String, dynamic>> locations = [
    {'name': 'ITO', 'present': 412, 'total': 480, 'icon': Icons.business_rounded},
    {'name': 'Chanakyapuri', 'present': 318, 'total': 360, 'icon': Icons.account_balance_rounded},
    {'name': 'DMRC', 'present': 196, 'total': 230, 'icon': Icons.train_rounded},
    {'name': 'Work from Home', 'present': 161, 'total': 170, 'icon': Icons.home_work_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateStr =
        '${_weekday(today.weekday)}, ${today.day} ${_month(today.month)} ${today.year}';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Date header ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TODAY\'S ATTENDANCE',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7A99),
                        letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 2),
                  Text(dateStr,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3A52))),
                ],
              ),
              _ExportButton(
                  onTap: () => SnackbarService.showComingSoon('Export Report')),
            ],
          ),

          const SizedBox(height: 18),

          // ── KPI row ───────────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                flex: 5,
                child: _KpiCard(
                  label: 'CLOCKED IN',
                  value: '$clockedIn',
                  sub: 'of $totalEmployees employees',
                  color: const Color(0xFF1565C0),
                  icon: Icons.fingerprint_rounded,
                  highlight: true,
                  onTap: () =>
                      SnackbarService.showComingSoon('Clocked In Detail'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _KpiCard(
                      label: 'ABSENT',
                      value: '$absent',
                      sub: 'unexcused',
                      color: const Color(0xFF546E7A),
                      icon: Icons.person_off_outlined,
                      highlight: false,
                      onTap: () =>
                          SnackbarService.showComingSoon('Absences Detail'),
                    ),
                    const SizedBox(height: 10),
                    _KpiCard(
                      label: 'ON LEAVE',
                      value: '$onLeave',
                      sub: 'approved',
                      color: const Color(0xFF7E94B0),
                      icon: Icons.event_busy_outlined,
                      highlight: false,
                      onTap: () =>
                          SnackbarService.showComingSoon('Leave Detail'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ── Attendance rate bar ───────────────────────────────────────────────
          const _AttendanceRateBar(
            clockedIn: clockedIn,
            onLeave: onLeave,
            absent: absent,
            total: totalEmployees,
          ),

          const SizedBox(height: 24),

          // ── Quick actions ─────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.person_add_outlined,
                  label: 'Employee\nApprovals',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddEmployeeView()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _QuickActionButton(
                  icon: Icons.fact_check_outlined,
                  label: 'Attendance\nVerification',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VerificationView()),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Section title ─────────────────────────────────────────────────────
          const Text(
            'LOCATION BREAKDOWN',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7A99),
                letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),

          // ── Location cards ────────────────────────────────────────────────────
          ...locations.map((loc) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LocationCard(
              name: loc['name'],
              present: loc['present'],
              total: loc['total'],
              icon: loc['icon'],
              onTap: () =>
                  SnackbarService.showComingSoon('${loc['name']} Detail'),
            ),
          )),
        ],
      ),
    );
  }

  String _weekday(int d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];

  String _month(int m) => [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m - 1];
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _ExportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ExportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFBDD5F5)),
          borderRadius: BorderRadius.circular(7),
          color: const Color(0xFFF0F6FF),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download_rounded, size: 14, color: Color(0xFF1565C0)),
            SizedBox(width: 5),
            Text('Export',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1565C0))),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final IconData icon;
  final bool highlight;
  final VoidCallback onTap;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
    required this.icon,
    required this.highlight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: highlight ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: highlight
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFE3E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                      color: highlight
                          ? Colors.white.withOpacity(0.75)
                          : const Color(0xFF6B7A99)),
                ),
                Icon(icon,
                    size: 16,
                    color: highlight
                        ? Colors.white.withOpacity(0.7)
                        : color.withOpacity(0.5)),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: highlight ? 34 : 26,
                  fontWeight: FontWeight.w700,
                  color:
                  highlight ? Colors.white : const Color(0xFF2D3A52),
                  height: 1.0),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(
                  fontSize: 11,
                  color: highlight
                      ? Colors.white.withOpacity(0.65)
                      : const Color(0xFF9BAABF)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttendanceRateBar extends StatelessWidget {
  final int clockedIn, onLeave, absent, total;
  const _AttendanceRateBar(
      {required this.clockedIn,
        required this.onLeave,
        required this.absent,
        required this.total});

  @override
  Widget build(BuildContext context) {
    final pIn = clockedIn / total;
    final pLeave = onLeave / total;
    final pAbsent = absent / total;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: (pIn * 1000).round(),
                    child: Container(color: const Color(0xFF1565C0)),
                  ),
                  Expanded(
                    flex: (pLeave * 1000).round(),
                    child: Container(color: const Color(0xFF90A4C8)),
                  ),
                  Expanded(
                    flex: (pAbsent * 1000).round(),
                    child: Container(color: const Color(0xFFCDD6E8)),
                  ),
                  Expanded(
                    flex: (1000 - (pIn + pLeave + pAbsent) * 1000)
                        .round()
                        .abs(),
                    child: Container(color: const Color(0xFFEDF0F5)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _BarLegend(
                  color: const Color(0xFF1565C0), label: 'Present'),
              const SizedBox(width: 14),
              _BarLegend(
                  color: const Color(0xFF90A4C8), label: 'On Leave'),
              const SizedBox(width: 14),
              _BarLegend(
                  color: const Color(0xFFCDD6E8), label: 'Absent'),
              const Spacer(),
              Text(
                '${(pIn * 100).toStringAsFixed(1)}% attendance',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1565C0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _BarLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 8,
            height: 8,
            decoration:
            BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF9BAABF))),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFBDD5F5)),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF1565C0)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2340),
                    height: 1.35,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: Color(0xFFBDD5F5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String name;
  final int present;
  final int total;
  final IconData icon;
  final VoidCallback onTap;

  const _LocationCard({
    required this.name,
    required this.present,
    required this.total,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = present / total;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE3E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F6FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child:
              Icon(icon, size: 18, color: const Color(0xFF1565C0)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3A52))),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 4,
                      backgroundColor: const Color(0xFFEDF0F5),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF1565C0)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$present',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3A52)),
                ),
                Text(
                  'of $total',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9BAABF)),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: Color(0xFFCDD6E8)),
          ],
        ),
      ),
    );
  }
}