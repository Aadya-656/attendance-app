// lib/attendance/attendance_model.dart

enum ClockStatus { clockedIn, clockedOut }
enum LocationStatus { withinRadius, outsideRadius, loading }

const List<Map<String, String>> kRemoteLocations = [
  {'id': '1', 'name': 'Work From Home'},
  {'id': '2', 'name': 'ITO'},
  {'id': '3', 'name': 'Chanakyapuri'},
  {'id': '4', 'name': 'DMRC'},
  {'id': '5', 'name': 'Tour'},
];