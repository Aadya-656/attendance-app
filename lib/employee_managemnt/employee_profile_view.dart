import 'package:flutter/material.dart';
import 'employee_model.dart';

class EmployeeProfileView
    extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeProfileView({
    super.key,
    required this.employee,
  });

  static const bg =
  Color(0xffEEF2FA);

  @override
  Widget build(BuildContext context) {
    final others =
        employee.late +
            employee.leave +
            employee.tour +
            employee.wfh +
            employee.faceIssue;

    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        title:
        const Text("Employee Profile"),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Card(
          child: Padding(
            padding:
            const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  employee.name,
                  style:
                  const TextStyle(
                    fontSize: 22,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                Text(
                  employee.designation,
                ),

                Text(employee.office),

                const Divider(),

                Text(
                  "Present : ${employee.present}%",
                ),

                Text(
                  "Absent : ${employee.absent}%",
                ),

                Tooltip(
                  message:
                  "Late: ${employee.late}%\n"
                      "Leave: ${employee.leave}%\n"
                      "Tour: ${employee.tour}%\n"
                      "WFH: ${employee.wfh}%\n"
                      "Face Issue: ${employee.faceIssue}%",
                  child: Text(
                    "Others : $others%",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}