import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'employee_controller.dart';
import 'employee_model.dart';

class AddEmployeeView extends StatelessWidget {
  AddEmployeeView({super.key});

  final controller =
  Get.find<EmployeeController>();

  final nameController =
  TextEditingController();

  final designationController =
  TextEditingController();

  final officeController =
  TextEditingController();

  static const bg =
  Color(0xffEEF2FA);

  static const primary =
  Color(0xff4D6BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      appBar: AppBar(
        title: const Text("Add Employee"),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Card(
          child: Padding(
            padding:
            const EdgeInsets.all(20),

            child: Column(
              children: [

                TextField(
                  controller:
                  nameController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Employee Name",
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextField(
                  controller:
                  designationController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Designation",
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                TextField(
                  controller:
                  officeController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Office",
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.employees.add(
                        EmployeeModel(
                          name:
                          nameController.text,
                          designation:
                          designationController
                              .text,
                          office:
                          officeController.text,
                          present: 0,
                          absent: 0,
                          late: 0,
                          leave: 0,
                          tour: 0,
                          wfh: 0,
                          faceIssue: 0,
                        ),
                      );

                      Get.back();

                      Get.snackbar(
                        "Success",
                        "Employee Added",
                      );
                    },
                    child: const Text(
                      "Save Employee",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}