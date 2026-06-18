import 'package:flutter/material.dart';
import 'verification_model.dart';

class ReviewView extends StatefulWidget {
  final VerificationModel employee;

  const ReviewView({
    super.key,
    required this.employee,
  });

  @override
  State<ReviewView> createState() =>
      _ReviewViewState();
}

class _ReviewViewState
    extends State<ReviewView> {
  static const bg = Color(0xffEEF2FA);
  static const primary = Color(0xff4D6BFF);

  String role = "teamLead";
  // teamLead / moduleLead / projectHead

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        title: const Text(
          "Attendance Review",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      widget.employee
                          .employeeName,
                      style:
                      const TextStyle(
                        fontSize: 22,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 8),

                    Text(
                      "Type: ${widget.employee.employeeType}",
                    ),

                    Text(
                      "Date: ${widget.employee.date}",
                    ),

                    Text(
                      "Clock In: ${widget.employee.clockInTime}",
                    ),

                    const Divider(),

                    Text(
                      "Home Office: ${widget.employee.homeOffice}",
                    ),

                    Text(
                      "Checked In At: ${widget.employee.checkedInAt}",
                    ),

                    Text(
                      widget.employee.isWFH
                          ? "WFH: Yes"
                          : "WFH: No",
                    ),

                    const SizedBox(
                        height: 20),

                    Container(
                      height: 220,
                      decoration:
                      BoxDecoration(
                        color: Colors
                            .grey.shade300,
                        borderRadius:
                        BorderRadius
                            .circular(
                            16),
                      ),
                      child:
                      const Center(
                        child: Text(
                          "Captured Selfie",
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 20),

                    Container(
                      padding:
                      const EdgeInsets
                          .all(12),
                      decoration:
                      BoxDecoration(
                        color: widget.employee
                            .reviewStatus ==
                            "approved"
                            ? Colors.green
                            .withOpacity(
                            .15)
                            : widget.employee
                            .reviewStatus ==
                            "rejected"
                            ? Colors.red
                            .withOpacity(
                            .15)
                            : Colors.orange
                            .withOpacity(
                            .15),
                        borderRadius:
                        BorderRadius
                            .circular(
                            12),
                      ),
                      child: Text(
                        widget.employee
                            .reviewStatus ==
                            "approved"
                            ? "Approved"
                            : widget.employee
                            .reviewStatus ==
                            "rejected"
                            ? "Rejected"
                            : "Face Issue Flagged",
                      ),
                    ),

                    const SizedBox(
                        height: 30),

                    if (widget.employee
                        .faceIssue &&
                        role ==
                            "teamLead" &&
                        widget.employee
                            .reviewStatus ==
                            "flagged")
                      Row(
                        children: [

                          Expanded(
                            child:
                            ElevatedButton(
                              onPressed: () {
                                setState(
                                      () {
                                    widget.employee.reviewStatus =
                                    "approved";

                                    widget.employee.faceIssue =
                                    false;
                                  },
                                );
                              },
                              style:
                              ElevatedButton.styleFrom(
                                backgroundColor:
                                primary,
                                padding:
                                const EdgeInsets.symmetric(
                                  vertical:
                                  14,
                                ),
                              ),
                              child:
                              const Text(
                                "Approve",
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 12),

                          Expanded(
                            child:
                            OutlinedButton(
                              onPressed: () {
                                setState(
                                      () {
                                    widget.employee.reviewStatus =
                                    "rejected";

                                    widget.employee.faceIssue =
                                    false;
                                  },
                                );
                              },
                              style:
                              OutlinedButton.styleFrom(
                                padding:
                                const EdgeInsets.symmetric(
                                  vertical:
                                  14,
                                ),
                              ),
                              child:
                              const Text(
                                "Reject",
                              ),
                            ),
                          ),
                        ],
                      ),
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
