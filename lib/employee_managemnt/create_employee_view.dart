import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'employee_controller.dart';
import 'employee_model.dart';
import '../login_1/app_theme.dart';
import '../login_1/app_widgets.dart';

class CreateEmployeeView extends StatefulWidget {
  const CreateEmployeeView({super.key});

  @override
  State<CreateEmployeeView> createState() => _CreateEmployeeViewState();
}

class _CreateEmployeeViewState extends State<CreateEmployeeView> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────────────────
  final _nameController           = TextEditingController();
  final _emailController          = TextEditingController();
  final _phoneController          = TextEditingController();
  final _employeeIdController     = TextEditingController();
  final _projectController        = TextEditingController();
  final _employmentTillController = TextEditingController();

  // ── Office dropdown ──────────────────────────────────────
  static const List<String> _officeLocations = [
    'Chanakyapuri',
    'ITO',
    'DMRC',
  ];
  String? _selectedOffice;

  // ── Live validity flags ──────────────────────────────────
  bool _emailTouched = false;
  bool _phoneTouched = false;

  bool get _isEmailValid {
    final v = _emailController.text.trim();
    if (v.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v);
  }

  bool get _isPhoneValid =>
      RegExp(r'^[0-9]{10}$').hasMatch(_phoneController.text.trim());

  final EmployeeController _employeeController = Get.find<EmployeeController>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() => _emailTouched = _emailTouched || _emailController.text.isNotEmpty);
    });
    _phoneController.addListener(() {
      setState(() => _phoneTouched = _phoneTouched || _phoneController.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _projectController.dispose();
    _employmentTillController.dispose();
    super.dispose();
  }

  // ── Reusable border helper ───────────────────────────────
  OutlineInputBorder _outlineBorder(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: 1.5),
      );

  void _addEmployee() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedOffice == null) {
      Get.snackbar(
        'Required',
        'Please select an office location.',
        backgroundColor: Colors.white,
        colorText: AppColors.textPrimary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
      );
      return;
    }

    _employeeController.employees.add(
      EmployeeModel(
        name: _nameController.text.trim(),
        designation: 'General Shift',
        office: _selectedOffice!,
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
      "${_nameController.text} added successfully",
      backgroundColor: const Color(0xff4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Derive border colors live
    final emailBorderColor = (_emailTouched && !_isEmailValid)
        ? AppColors.error
        : AppColors.border;
    final phoneBorderColor = (_phoneTouched && !_isPhoneValid)
        ? AppColors.error
        : AppColors.border;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  'Add Employee',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Register a new employee record for your\norganisation.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),
                const SectionDivider(label: 'PERSONAL DETAILS'),
                const SizedBox(height: 20),

                // ── Full Name ────────────────────────────────
                AppTextField(
                  label: 'Full Name',
                  hint: 'As per government ID',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      size: 18, color: AppColors.textHint),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),

                // ── Email — manual TextFormField with fixed box border ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'official@example.gov.in',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                        prefixIcon: const Icon(Icons.mail_outline_rounded,
                            size: 18, color: AppColors.textHint),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        enabledBorder: _outlineBorder(emailBorderColor),
                        focusedBorder: _outlineBorder(
                          (_emailTouched && !_isEmailValid)
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                        errorBorder: _outlineBorder(AppColors.error),
                        focusedErrorBorder: _outlineBorder(AppColors.error),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(v.trim())) {
                          return 'Enter a valid email (e.g. name@gmail.com)';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Mobile — manual TextFormField with fixed box border ──
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: '10-digit number',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textHint,
                        ),
                        prefixIcon: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '+91',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                  width: 1,
                                  height: 18,
                                  color: AppColors.border),
                            ],
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        enabledBorder: _outlineBorder(phoneBorderColor),
                        focusedBorder: _outlineBorder(
                          (_phoneTouched && !_isPhoneValid)
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                        errorBorder: _outlineBorder(AppColors.error),
                        focusedErrorBorder: _outlineBorder(AppColors.error),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Mobile number is required';
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(v.trim())) {
                          return 'Enter a valid 10-digit mobile number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 28),
                const SectionDivider(label: 'EMPLOYMENT DETAILS'),
                const SizedBox(height: 20),

                // ── Employee ID ──────────────────────────────
                AppTextField(
                  label: 'Employee ID',
                  hint: 'ID issued by employer',
                  controller: _employeeIdController,
                  prefixIcon: const Icon(Icons.badge_outlined,
                      size: 18, color: AppColors.textHint),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Employee ID is required'
                      : null,
                ),
                const SizedBox(height: 20),

                // ── Office Dropdown ──────────────────────────
                AppDropdownField<String>(
                  label: 'Primary Office Location',
                  hint: 'Select location',
                  value: _selectedOffice,
                  items: _officeLocations,
                  itemLabel: (loc) => loc,
                  onChanged: (v) => setState(() => _selectedOffice = v),
                ),
                const SizedBox(height: 20),

                // ── Project ──────────────────────────────────
                AppTextField(
                  label: 'Project',
                  hint: 'Project assigned',
                  controller: _projectController,
                  prefixIcon: const Icon(Icons.code_outlined,
                      size: 18, color: AppColors.textHint),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Project is required'
                      : null,
                ),
                const SizedBox(height: 20),

                // ── Shift (readonly) ─────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shift',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppColors.border, width: 1.5),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.schedule_rounded,
                              size: 18, color: AppColors.primary),
                          SizedBox(width: 10),
                          Text(
                            'General Shift',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Employment Till Date ─────────────────────
                AppTextField(
                  label: 'Employment Till Date',
                  hint: 'DD / MM / YYYY',
                  controller: _employmentTillController,
                  keyboardType: TextInputType.datetime,
                  prefixIcon: const Icon(Icons.calendar_today_outlined,
                      size: 18, color: AppColors.textHint),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.now().add(const Duration(days: 365)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2040),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.primary,
                            onPrimary: Colors.white,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      _employmentTillController.text =
                          '${picked.day.toString().padLeft(2, '0')} / '
                          '${picked.month.toString().padLeft(2, '0')} / '
                          '${picked.year}';
                    }
                  },
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Employment till date is required'
                      : null,
                ),

                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addEmployee,
                    child: const Text('Add Employee'),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
