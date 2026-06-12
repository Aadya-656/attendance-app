import 'package:flutter/material.dart';
import 'verification_model.dart';

class ReviewView extends StatelessWidget {
  final VerificationModel employee;

  const ReviewView({
    super.key,
    required this.employee,
  });

  static const bg = Color(0xffEEF2FA);
  static const primary = Color(0xff4D6BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          "Attendance Review",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    Text(
                      employee.employeeName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Type: ${employee.employeeType}",
                    ),

                    Text(
                      "Date: ${employee.date}",
                    ),

                    Text(
                      "Clock In: ${employee.clockInTime}",
                    ),

                    const Divider(height: 30),

                    Text(
                      "Home Office: ${employee.homeOffice}",
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Checked In At: ${employee.checkedInAt}",
                    ),

                    const SizedBox(height: 6),

                    Text(
                      employee.isWFH
                          ? "WFH: Yes"
                          : "WFH: No",
                    ),

                    const SizedBox(height: 24),

                    Container(
                      height: 220,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius:
                        BorderRadius.circular(
                            16),
                      ),

                      child: const Center(
                        child: Text(
                          "Captured Selfie",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(
                        color: employee.faceIssue
                            ? Colors.orange
                            .withOpacity(.12)
                            : Colors.green
                            .withOpacity(.12),

                        borderRadius:
                        BorderRadius.circular(
                            12),
                      ),

                      child: Text(
                        employee.faceIssue
                            ? "Face Issue Flagged"
                            : "Verified",

                        style: TextStyle(
                          color: employee.faceIssue
                              ? Colors.orange
                              : Colors.green,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    if (employee.faceIssue) ...[
                      SizedBox(
                        width: double.infinity,

                        child: ElevatedButton(
                          onPressed: () {},

                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            primary,
                            padding:
                            const EdgeInsets
                                .symmetric(
                              vertical: 14,
                            ),
                          ),

                          child: const Text(
                            "Approve",
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,

                        child: OutlinedButton(
                          onPressed: () {},

                          child: const Text(
                            "Escalate to Super Admin",
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}