import 'employee_model.dart';

class EmployeeRepository {
  List<EmployeeModel> getEmployees() {
    return [

      EmployeeModel(
        name: "Ramesh Kumar",
        designation: "Engineer",
        office: "ITO",
        present: 92,
        absent: 8,
        late: 2,
        leave: 1,
        tour: 1,
        wfh: 0,
        faceIssue: 0,
      ),

      EmployeeModel(
        name: "Priya Sharma",
        designation: "Analyst",
        office: "DMRC",
        present: 88,
        absent: 12,
        late: 3,
        leave: 2,
        tour: 1,
        wfh: 1,
        faceIssue: 0,
      ),

      EmployeeModel(
        name: "Amit Verma",
        designation: "Developer",
        office: "Chanakyapuri",
        present: 95,
        absent: 5,
        late: 1,
        leave: 1,
        tour: 1,
        wfh: 0,
        faceIssue: 0,
      ),
    ];
  }
}