import 'dart:io';
import 'package:csv/csv.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'employee_model.dart';
import 'employee_repository.dart';

class EmployeeController extends GetxController {
  final repo = EmployeeRepository();

  var role = "teamLead".obs;
  var search = "".obs;

  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;

  List<EmployeeModel> get filteredEmployees {
    if (search.value.isEmpty) return employees;

    return employees.where((e) {
      return e.name.toLowerCase().contains(
        search.value.toLowerCase(),
      );
    }).toList();
  }

  @override
  void onInit() {
    employees.assignAll(repo.getEmployees());
    super.onInit();
  }

  Future<void> exportCSV() async {
    List<List<dynamic>> rows = [];

    rows.add([
      "Name",
      "Designation",
      "Office",
      "Present",
      "Absent"
    ]);

    for (var e in employees) {
      rows.add([
        e.name,
        e.designation,
        e.office,
        e.present,
        e.absent
      ]);
    }

    final String csv = const ListToCsvConverter().convert(rows);

    final Directory dir = await getTemporaryDirectory();
    final File file = File('${dir.path}/employees.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Employee Data',
    );
  }
}