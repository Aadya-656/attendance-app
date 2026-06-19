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

  // Observable variable to track search bar visibility
  final RxBool isSearchExpanded = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Obx(() {
          if (isSearchExpanded.value) {
            return TextField(
              autofocus: true,
              onChanged: (value) {
                controller.search.value = value;
              },
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                hintText: "Search employee...",
                border: InputBorder.none,
              ),
            );
          }
          return const Text("Employee Management");
        }),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(isSearchExpanded.value ? Icons.close : Icons.search),
              onPressed: () {
                isSearchExpanded.value = !isSearchExpanded.value;
                if (!isSearchExpanded.value) {
                  controller.search.value = ""; // Clear search on collapse
                }
              },
            );
          }),
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
            if (controller.role.value == "teamLead")
              _teamLeadDashboard(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredEmployees.length,
                itemBuilder: (context, index) {
                  final employee = controller.filteredEmployees[index];
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${employee.designation} • ${employee.office}",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (["teamLead", "projectHead"].contains(controller.role.value))
                  Text(
                    "${employee.present}%",
                    style: const TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
                if (controller.role.value == "teamLead") ...[
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
          Positioned(
            top: -12,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              color: bg,
              child: const Text(
                "Attendance Analytics",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}