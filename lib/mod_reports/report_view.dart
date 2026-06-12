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
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Attendance",
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(
            () => Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),

              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "July 2026",
                    style: TextStyle(
                      color: sub,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Column(
                    children: [

                      const Text(
                        "Attendance Percentage",
                        style: TextStyle(
                          color: sub,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "${controller.report.value.attendancePercentage.toStringAsFixed(1)}%",
                        style: const TextStyle(
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                          color: text,
                        ),
                      ),

                      const SizedBox(height: 18),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}