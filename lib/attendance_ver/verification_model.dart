class VerificationModel {
  final String employeeName;
  final String employeeType;

  final String clockInTime;
  final String date;

  final String homeOffice;
  final String checkedInAt;

  final bool isWFH;
  final bool faceIssue;

  VerificationModel({
    required this.employeeName,
    required this.employeeType,
    required this.clockInTime,
    required this.date,
    required this.homeOffice,
    required this.checkedInAt,
    required this.isWFH,
    required this.faceIssue,
  });
}