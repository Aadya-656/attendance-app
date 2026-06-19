import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'employee_controller.dart';
import 'employee_model.dart';

class CreateEmployeeView extends StatefulWidget {
  const CreateEmployeeView({super.key});

  @override
  State<CreateEmployeeView> createState() =>
      _CreateEmployeeViewState();
}

class _CreateEmployeeViewState
    extends State<CreateEmployeeView> {
  static const Color _bg = Color(0xffEEF2FA);
  static const Color _primary = Color(0xff4D6BFF);

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _designationController =
  TextEditingController();
  final _officeController =
  TextEditingController();

  final _emailController =
  TextEditingController();
  final _phoneController =
  TextEditingController();
  final _employeeIdController =
  TextEditingController();
  final _projectController =
  TextEditingController();
  final _shiftController =
  TextEditingController();
  final _employmentTillController =
  TextEditingController();

  final EmployeeController _employeeController =
  Get.find<EmployeeController>();

  @override
  void dispose() {
    _nameController.dispose();
    _designationController.dispose();
    _officeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _projectController.dispose();
    _shiftController.dispose();
    _employmentTillController.dispose();
    super.dispose();
  }

  void _createEmployee() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _employeeController.employees.add(
      EmployeeModel(
        name: _nameController.text.trim(),
        designation:
        _designationController.text.trim(),
        office: _officeController.text.trim(),
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
      "${_nameController.text} created successfully",
      backgroundColor: const Color(0xff4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          "Create Employee",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xffE0E0E0),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(
                controller: _nameController,
                label: "Full Name",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _designationController,
                label: "Designation",
                icon: Icons.badge_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _officeController,
                label: "Office",
                icon: Icons.location_on_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _phoneController,
                label: "Mobile Number",
                icon: Icons.phone_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _employeeIdController,
                label: "Employee ID",
                icon: Icons.badge,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _projectController,
                label: "Project",
                icon: Icons.code_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller: _shiftController,
                label: "Shift",
                icon: Icons.schedule_outlined,
              ),

              const SizedBox(height: 14),

              _field(
                controller:
                _employmentTillController,
                label: "Employment Till",
                icon: Icons.calendar_today_outlined,
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _createEmployee,
                  icon: const Icon(
                    Icons.person_add_alt_1,
                  ),
                  label: const Text(
                    "Create Employee",
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor:
                    Colors.white,
                    elevation: 0,
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Required";
        }

        final text = value.trim();

        // Email validation
        if (label == "Email") {
          final emailRegex =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

          if (!emailRegex.hasMatch(text)) {
            return "Enter a valid email (e.g. name@gmail.com)";
          }
        }

        // Phone validation (10 digits)
        if (label == "Mobile Number") {
          final phoneRegex = RegExp(r'^[0-9]{10}$');

          if (!phoneRegex.hasMatch(text)) {
            return "Enter a valid 10-digit mobile number";
          }
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xffE0E0E0),
          ),
        ),
      ),
    );
  }
}