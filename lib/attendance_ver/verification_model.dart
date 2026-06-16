class VerificationModel {
  final String employeeName;
  final String employeeType;
  final String date;
  final String clockInTime;
  final String homeOffice;
  final String checkedInAt;
  final bool isWFH;
  final bool faceIssue;
  final String officeLocation;

  String reviewStatus;

  VerificationModel({
    required this.employeeName,
    required this.employeeType,
    required this.date,
    required this.clockInTime,
    required this.homeOffice,
    required this.checkedInAt,
    required this.isWFH,
    required this.faceIssue,
    required this.officeLocation,
    required this.reviewStatus,
  });
}