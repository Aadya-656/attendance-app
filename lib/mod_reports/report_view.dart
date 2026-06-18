import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'report_controller.dart';

class ReportView extends StatelessWidget {
  ReportView({super.key});

  final controller = Get.put(
    ReportController(),
  );

  static const bg = Color(0xffEEF2FA);
  static const card = Colors.white;
  static const primary = Color(0xff4D6BFF);
  static const text = Color(0xff222222);
  static const sub = Color(0xff777C85);

  @override
  Widget build(BuildContext context) {
    final present = 10;
    final absent = 3;
    final wfh = 3;
    final tour = 2;

    final totalDays =
        present + absent + wfh + tour;

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Attendance Report",
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(
            () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              /// TOP CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius:
                  BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(.05),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),

                child: Column(
                  children: [
                    const Text(
                      "JULY 2026",
                      style: TextStyle(
                        color: sub,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "${controller.report.value.attendancePercentage.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 58,
                        fontWeight:
                        FontWeight.bold,
                        color: primary,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Overall Attendance",
                      style: TextStyle(
                        color: sub,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// PRESENT
              _reportBox(
                "Present",
                "$present/$totalDays",
                Colors.green.withOpacity(.08),
              ),

              /// ABSENT
              _reportBox(
                "Absent",
                "$absent/$totalDays",
                Colors.red.withOpacity(.08),
              ),

              /// WFH
              _reportBox(
                "WFH",
                "$wfh/$totalDays",
                primary.withOpacity(.06),
              ),

              /// TOUR
              _reportBox(
                "Tour",
                "$tour/$totalDays",
                primary.withOpacity(.06),
              ),

              /// TOTAL
              _reportBox(
                "Total Working Days",
                "$totalDays",
                Colors.grey.shade50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reportBox(
      String title,
      String value,
      Color bgColor,
      ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: text,
              fontWeight:
              FontWeight.w500,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: primary,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}