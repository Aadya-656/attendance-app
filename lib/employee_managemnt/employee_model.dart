class EmployeeModel {
  final String name;
  final String designation;
  final String office;

  final double present;
  final double absent;

  final double late;
  final double leave;
  final double tour;
  final double wfh;
  final double faceIssue;

  EmployeeModel({
    required this.name,
    required this.designation,
    required this.office,
    required this.present,
    required this.absent,
    required this.late,
    required this.leave,
    required this.tour,
    required this.wfh,
    required this.faceIssue,
  });
}