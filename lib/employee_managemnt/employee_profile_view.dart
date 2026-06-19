import 'package:flutter/material.dart';
import 'employee_model.dart';

class EmployeeProfileView extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeProfileView({
    super.key,
    required this.employee,
  });

  static const _bg = Color(0xffEEF2FA);
  static const _primary = Color(0xff4D6BFF);
  static const _green = Color(0xff4CAF50);
  static const _red = Color(0xffEF5350);
  static const _blue = Color(0xff5C8DFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          "Employee Profile",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xffE0E0E0), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Identity card ─────────────────────────────
            _Card(
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        employee.name[0],
                        style: const TextStyle(
                          color: _primary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              employee.designation,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "•",
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[400]),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.location_on_outlined,
                                size: 13, color: Colors.grey[400]),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                employee.office,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Section label ─────────────────────────────
            Padding(
              padding: const EdgeInsets.only(left: 2, bottom: 14),
              child: Text(
                "ATTENDANCE",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[500],
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // ── Attendance stat boxes ─────────────────────
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    label: "Present",
                    value: "${employee.present}%",
                    color: _green,
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatBox(
                    label: "Absent",
                    value: "${employee.absent}%",
                    color: _red,
                    icon: Icons.cancel_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Progress card — bordered, title floats on the outline ──
            _BorderedCard(
              label: "Attendance Overview",
              color: _primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: employee.present / 100,
                      minHeight: 10,
                      backgroundColor: _red.withOpacity(0.15),
                      color: _green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _LegendDot(color: _green, label: "Present"),
                      _LegendDot(color: _red, label: "Absent"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attendance Calendar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: _primary,
                      ),
                    ],
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
                      Color bg;
                      Color fg;

                      if (i % 7 == 0) {
                        bg = _red.withOpacity(0.12);
                        fg = _red;
                      } else if (i % 5 == 0) {
                        bg = _blue.withOpacity(0.14);
                        fg = _blue;
                      } else {
                        bg = _green.withOpacity(0.12);
                        fg = _green;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "${i + 1}",
                            style: TextStyle(
                              color: fg,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _LegendDot(color: _green, label: "Present"),
                      _LegendDot(color: _red, label: "Absent"),
                      _LegendDot(color: _blue, label: "WFH"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Reusable white card wrapper (shadow style)
// ─────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// Bordered card with a label floating on the top outline
// (same trick used on the stat boxes)
// ─────────────────────────────────────────────
class _BorderedCard extends StatelessWidget {
  final String label;
  final Widget child;
  final Color color;

  const _BorderedCard({
    required this.label,
    required this.child,
    this.color = const Color(0xff4D6BFF),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.30), width: 1.2),
          ),
          child: child,
        ),
        Positioned(
          left: 16,
          top: -9,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            color: const Color(0xffEEF2FA), // matches page background
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color.withOpacity(0.9),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Compact stat box (Present / Absent)
// Label floats on the outline (top-left), icon + value sit inline
// ─────────────────────────────────────────────
class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.35), width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 14,
          top: -7,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            color: const Color(0xffEEF2FA),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.9),
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Legend dot for progress bar / calendar
// ─────────────────────────────────────────────
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}