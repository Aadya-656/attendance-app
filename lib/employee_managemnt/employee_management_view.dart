import 'employee_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'employee_controller.dart';
import 'add_employee_view.dart';

class EmployeeManagementView extends StatelessWidget {
  EmployeeManagementView({super.key});

  final controller = Get.put(EmployeeController());

  static const bg = Color(0xffEEF2FA);
  static const primary = Color(0xff4D6BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        title: const Text("Employee Management"),
        actions: [
          Obx(() {
            if (controller.role.value == "teamLead" ||
                controller.role.value == "projectHead") {
              return IconButton(
                onPressed: controller.exportCSV,
                icon: const Icon(Icons.download),
              );
            }
            return const SizedBox();
          }),
        ],
      ),

      body: Obx(
            () => Column(
          children: [
            _searchBar(),

            if (controller.role.value == "teamLead")
              _teamLeadDashboard(),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee =
                  controller.filteredEmployees[index];

                  return _employeeCard(employee);
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Obx(() {
        if (controller.role.value == "teamLead") {
          return FloatingActionButton(
            backgroundColor: primary,
            onPressed: () {
              Get.to(
                    () => AddEmployeeView(),
              );
            },
            child: const Icon(Icons.person_add),
          );
        }
        return const SizedBox();
      }),
    );
  }
  Widget _dashboardTile(
      String value,
      String label,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: (value) {
          controller.search.value = value;
        },
        decoration: InputDecoration(
          hintText: "Search employee...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _employeeCard(employee) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.name,
                      style: const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(employee.designation),
                    Text(employee.office),
                  ],
                ),

                if ([
                  "teamLead",
                  "projectHead"
                ].contains(controller.role.value))
                  Text(
                    "${employee.present}%",
                    style: const TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(
                            () => EmployeeProfileView(
                          employee: employee,
                        ),
                      );
                    },
                    child: const Text("View"),
                  ),
                ),

                if (controller.role.value ==
                    "teamLead") ...[
                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.block),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamLeadDashboard() {
    return SizedBox(
        width: double.infinity,
        child: Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 10),

        const Center(
          child: Text(
            "Attendance Analytics",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),

            const SizedBox(height: 4),

            Text(
              "Current Month Overview",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: _dashboardTile(
                    "88%",
                    "Present",
                    const Color(0xFF43A047),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dashboardTile(
                    "9%",
                    "Not Marked",
                    const Color(0xFFE57373),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _dashboardTile(
                    "2%",
                    "WFH",
                    const Color(0xFF4D6BFF),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _dashboardTile(
                    "1%",
                    "Tour",
                    const Color(0xFF4D6BFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
