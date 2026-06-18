import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'verification_controller.dart';
import 'review_view.dart';

class VerificationView extends StatelessWidget {
  VerificationView({super.key});

  final controller =
  Get.put(VerificationController());

  static const bg = Color(0xffEEF2FA);
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
          "Attendance Verification",
          style: TextStyle(
            color: text,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Obx(
            () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount:
          controller.attendanceList.length,
          itemBuilder: (context, index) {
            final employee =
            controller.attendanceList[index];

            return Container(
              margin:
              const EdgeInsets.only(
                bottom: 16,
              ),
              padding:
              const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(.05),
                    blurRadius: 12,
                  )
                ],
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    employee.employeeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    employee.employeeType,
                    style: const TextStyle(
                      color: sub,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        employee.clockInTime,
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(
                            Icons.business,
                            size: 18,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Home Office: ${employee.homeOffice}",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Checked In At: ${employee.checkedInAt}",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.home_work_outlined,
                        size: 18,
                        color: primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        employee.isWFH
                            ? "WFH: Yes"
                            : "WFH: No",
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: employee.reviewStatus ==
                          "approved"
                          ? Colors.green
                          .withOpacity(.15)
                          : employee.reviewStatus ==
                          "rejected"
                          ? Colors.red
                          .withOpacity(.15)
                          : Colors.orange
                          .withOpacity(.15),
                      borderRadius:
                      BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Text(
                      employee.reviewStatus ==
                          "approved"
                          ? "Verified"
                          : employee.reviewStatus ==
                          "rejected"
                          ? "Rejected"
                          : "Face Issue Flagged",
                      style: TextStyle(
                        color: employee.reviewStatus ==
                            "approved"
                            ? Colors.green
                            : employee.reviewStatus ==
                            "rejected"
                            ? Colors.red
                            : Colors.orange,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (employee.faceIssue)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ReviewView(
                                    employee: employee,
                                  ),
                            ),
                          );

                          controller
                              .attendanceList
                              .refresh();
                        },
                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          primary,
                          padding:
                          const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          "Review",
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}