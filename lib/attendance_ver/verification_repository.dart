import 'verification_model.dart';

class VerificationRepository {
  List<VerificationModel> getAttendanceList() {
    return [

      VerificationModel(
        employeeName: "Reva Singh",
        employeeType: "Internal",
        clockInTime: "09:02 AM",
        date: "12 June 2026",
        homeOffice: "Chanakyapuri",
        checkedInAt: "Chanakyapuri",
        isWFH: false,
        faceIssue: true,
      ),

      VerificationModel(
        employeeName: "Ankit Sharma",
        employeeType: "Outsourced",
        clockInTime: "09:15 AM",
        date: "12 June 2026",
        homeOffice: "Chanakyapuri",
        checkedInAt: "Noida Office",
        isWFH: false,
        faceIssue: false,
      ),

      VerificationModel(
        employeeName: "Priya Sharma",
        employeeType: "Internal",
        clockInTime: "09:00 AM",
        date: "12 June 2026",
        homeOffice: "Chanakyapuri",
        checkedInAt: "Home",
        isWFH: true,
        faceIssue: false,
      ),
    ];
  }
}