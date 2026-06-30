import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:clock_camera_v4/mod_reports/report_view.dart';

/// Attendance summary screen. Previously its own standalone app
/// (launched via a plain MaterialApp); now wired in as the '/profile'
/// route inside the shared GetMaterialApp in main.dart.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Raghav Malhotra",
                            style: TextStyle(
                              color: text,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Designation + office on one line
                          Row(
                            children: [
                              const Text(
                                "BITS",
                                style: TextStyle(
                                  color: sub,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "•",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: sub.withOpacity(.6),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.location_on_outlined,
                                size: 13,
                                color: sub.withOpacity(.7),
                              ),
                              const SizedBox(width: 3),
                              const Flexible(
                                child: Text(
                                  "Chanakyapuri Home Office",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: sub,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
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
                        Color base = Colors.grey.shade300;

                        if (i < calendarColors.length) {
                          base = calendarColors[i];
                        }

                        final Color bgTint = base.withOpacity(0.12);
                        final Color fg = base == Colors.grey.shade300
                            ? Colors.grey
                            : base;

                        return Container(
                          decoration: BoxDecoration(
                            color: bgTint,
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
