import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers.dart';

// ── Public Holiday data (Central Govt 2026) ───────────────────────────────────
final Map<String, String> _govtHolidays = {
  '2026-01-01': 'New Year\'s Day',
  '2026-01-14': 'Makar Sankranti',
  '2026-01-26': 'Republic Day',
  '2026-03-20': 'Holi',
  '2026-04-02': 'Ram Navami',
  '2026-04-03': 'Good Friday',
  '2026-04-14': 'Dr. Ambedkar Jayanti',
  '2026-05-01': 'Labour Day',
  '2026-06-27': 'Eid ul-Adha',
  '2026-08-15': 'Independence Day',
  '2026-10-02': 'Gandhi Jayanti',
  '2026-10-20': 'Dussehra',
  '2026-11-04': 'Diwali',
  '2026-11-05': 'Diwali (Lakshmi Puja)',
  '2026-11-15': 'Guru Nanak Jayanti',
  '2026-12-25': 'Christmas Day',
};

String _key(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

enum _DayType { working, weekend, holiday, today }

_DayType _typeOf(DateTime d) {
  if (d.weekday == DateTime.saturday || d.weekday == DateTime.sunday) {
    return _DayType.weekend;
  }
  if (_govtHolidays.containsKey(_key(d))) return _DayType.holiday;
  final now = DateTime.now();
  if (d.year == now.year && d.month == now.month && d.day == now.day) {
    return _DayType.today;
  }
  return _DayType.working;
}

const _shortMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

// ── CalendarSection ───────────────────────────────────────────────────────────

class CalendarSection extends StatelessWidget {
  const CalendarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CalendarController>();

    return Obx(() {
      final year = ctrl.year.value;
      final selectedMonth = ctrl.selectedMonth.value;

      // Yearly stats — recomputed reactively whenever year changes
      int workingDays = 0, weekendDays = 0, holidays = 0;
      for (int m = 1; m <= 12; m++) {
        final days = DateUtils.getDaysInMonth(year, m);
        for (int d = 1; d <= days; d++) {
          final dt = DateTime(year, m, d);
          final t = _typeOf(dt);
          if (t == _DayType.working || t == _DayType.today) workingDays++;
          if (t == _DayType.weekend) weekendDays++;
          if (t == _DayType.holiday) holidays++;
        }
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Year selector ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ANNUAL CALENDAR',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7A99),
                          letterSpacing: 1.0),
                    ),
                    const SizedBox(height: 2),
                    Text('$year',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3A52))),
                  ],
                ),
                Row(
                  children: [
                    _YearNavButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: ctrl.decrementYear,
                    ),
                    const SizedBox(width: 4),
                    _YearNavButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: ctrl.incrementYear,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Summary strip ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                    child: _StatChip(
                        label: 'Working Days',
                        value: '$workingDays',
                        color: const Color(0xFF1565C0))),
                const SizedBox(width: 8),
                Expanded(
                    child: _StatChip(
                        label: 'Weekends',
                        value: '$weekendDays',
                        color: const Color(0xFF90A4C8))),
                const SizedBox(width: 8),
                Expanded(
                    child: _StatChip(
                        label: 'Holidays',
                        value: '$holidays',
                        color: const Color(0xFF607D8B))),
              ],
            ),

            const SizedBox(height: 14),

            // ── Legend ───────────────────────────────────────────────────────
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE3E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _LegendDot(
                      color: const Color(0xFF1565C0), label: 'Working'),
                  _LegendDot(
                      color: const Color(0xFFE3E8F0), label: 'Weekend'),
                  _LegendDot(
                      color: const Color(0xFF607D8B), label: 'Holiday'),
                  _LegendDot(
                      color: const Color(0xFF0D47A1),
                      label: 'Today',
                      ring: true),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Month filter chips ───────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MonthChip(
                    label: 'All',
                    selected: selectedMonth == null,
                    onTap: () => ctrl.selectMonth(null),
                  ),
                  ...List.generate(12, (i) {
                    final m = i + 1;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: _MonthChip(
                        label: _shortMonths[i],
                        selected: selectedMonth == m,
                        onTap: () => ctrl.selectMonth(m),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Month grids ──────────────────────────────────────────────────
            ...List.generate(12, (i) {
              final m = i + 1;
              if (selectedMonth != null && selectedMonth != m) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _MonthGrid(
                  year: year,
                  month: m,
                  onTap: (dt) {
                    final holiday = _govtHolidays[_key(dt)];
                    if (holiday != null) {
                      SnackbarService.showComingSoon(holiday);
                    }
                  },
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// ── Month Grid ────────────────────────────────────────────────────────────────

class _MonthGrid extends StatelessWidget {
  final int year;
  final int month;
  final void Function(DateTime) onTap;

  const _MonthGrid(
      {required this.year, required this.month, required this.onTap});

  static const _weekLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final startOffset = (firstDay.weekday - 1) % 7;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month title row
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_monthNames[month - 1]} $year',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3A52)),
                ),
                Builder(builder: (ctx) {
                  int hCount = 0;
                  for (int d = 1; d <= daysInMonth; d++) {
                    if (_govtHolidays
                        .containsKey(_key(DateTime(year, month, d)))) {
                      hCount++;
                    }
                  }
                  if (hCount == 0) return const SizedBox.shrink();
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBDD5F5)),
                    ),
                    child: Text(
                      '$hCount holiday${hCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }),
              ],
            ),
          ),

          // Week header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: _weekLabels
                  .map((l) => Expanded(
                child: Center(
                  child: Text(l,
                      style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9BAABF))),
                ),
              ))
                  .toList(),
            ),
          ),

          const SizedBox(height: 4),

          // Day cells
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              children: List.generate(rows, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: List.generate(7, (col) {
                      final cellIndex = row * 7 + col;
                      final dayNum = cellIndex - startOffset + 1;
                      if (dayNum < 1 || dayNum > daysInMonth) {
                        return const Expanded(child: SizedBox(height: 32));
                      }
                      final dt = DateTime(year, month, dayNum);
                      final type = _typeOf(dt);
                      return Expanded(
                          child: _DayCell(
                              dt: dt,
                              type: type,
                              onTap: () => onTap(dt)));
                    }),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime dt;
  final _DayType type;
  final VoidCallback onTap;
  const _DayCell(
      {required this.dt, required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    bool ring = false;
    bool dot = false;

    switch (type) {
      case _DayType.today:
        bg = const Color(0xFF1565C0);
        text = Colors.white;
        ring = true;
        break;
      case _DayType.holiday:
        bg = const Color(0xFF607D8B).withOpacity(0.12);
        text = const Color(0xFF607D8B);
        dot = true;
        break;
      case _DayType.weekend:
        bg = Colors.transparent;
        text = const Color(0xFFB0BEC5);
        break;
      case _DayType.working:
        bg = Colors.transparent;
        text = const Color(0xFF2D3A52);
        break;
    }

    return GestureDetector(
      onTap: type == _DayType.holiday ? onTap : null,
      child: Container(
        height: 32,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
          border: ring
              ? Border.all(color: const Color(0xFF0D47A1), width: 1.5)
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${dt.day}',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: type == _DayType.today
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: text),
            ),
            if (dot)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: const BoxDecoration(
                      color: Color(0xFF607D8B), shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E8F0)),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 10.5, color: Color(0xFF9BAABF))),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool ring;
  const _LegendDot(
      {required this.color, required this.label, this.ring = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: ring
                ? Border.all(color: const Color(0xFF0D47A1), width: 1.5)
                : null,
          ),
        ),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: Color(0xFF6B7A99))),
      ],
    );
  }
}

class _YearNavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _YearNavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: const Color(0xFFE3E8F0)),
        ),
        child: Icon(icon, size: 18, color: const Color(0xFF1565C0)),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MonthChip(
      {required this.label,
        required this.selected,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFFE3E8F0)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
              selected ? Colors.white : const Color(0xFF6B7A99)),
        ),
      ),
    );
  }
}