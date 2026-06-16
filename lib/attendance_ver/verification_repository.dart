import 'verification_model.dart';

class VerificationRepository {
  List<VerificationModel> getAttendanceList() {
    return [
      VerificationModel(
        employeeName: "Amit Verma",
        employeeType: "Internal",
        date: "12 Jun 2026",
        clockInTime: "10:02 AM",
        homeOffice: "Chanakyapuri",
        checkedInAt: "Home",
        isWFH: true,
        faceIssue: true,
        officeLocation: "Delhi",
        reviewStatus: "flagged",
      ),

      VerificationModel(
        employeeName: "Priya Sharma",
        employeeType: "Internal",
        date: "12 Jun 2026",
        clockInTime: "09:48 AM",
        homeOffice: "ITO",
        checkedInAt: "ITO Office",
        isWFH: false,
        faceIssue: false,
        officeLocation: "Delhi",
        reviewStatus: "approved",
      ),

      VerificationModel(
        employeeName: "Rohan Mehta",
        employeeType: "External",
        date: "12 Jun 2026",
        clockInTime: "10:15 AM",
        homeOffice: "DMRC",
        checkedInAt: "Outside Location",
        isWFH: false,
        faceIssue: true,
        officeLocation: "Delhi",
        reviewStatus: "flagged",
      ),
    ];
  }
}