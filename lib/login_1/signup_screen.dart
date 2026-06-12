import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_controller.dart';
import 'app_theme.dart';
import 'app_widgets.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();

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
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Create account',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Register as a new employee. Your phone\nnumber will be verified via OTP.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),
                const SectionDivider(label: 'PERSONAL DETAILS'),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Full Name',
                  hint: 'As per government ID',
                  controller: auth.signupNameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      size: 18, color: AppColors.textHint),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email Address',
                  hint: 'official@example.gov.in',
                  controller: auth.signupEmailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      size: 18, color: AppColors.textHint),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!GetUtils.isEmail(v)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Mobile Number',
                  hint: '10-digit number',
                  controller: auth.signupPhoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  prefixIcon: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '+91',
                          style: GoogleFonts.inter(
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
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Phone is required';
                    if (v.length < 10) return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),

                const SizedBox(height: 28),
                const SectionDivider(label: 'EMPLOYMENT DETAILS'),
                const SizedBox(height: 20),

                AppTextField(
                  label: 'Employer Name',
                  hint: 'Organisation / Ministry',
                  controller: auth.signupEmployerController,
                  prefixIcon: const Icon(Icons.business_outlined,
                      size: 18, color: AppColors.textHint),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Employer name is required'
                      : null,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Employee ID',
                  hint: 'ID issued by employer',
                  controller: auth.signupEmployeeIdController,
                  prefixIcon: const Icon(Icons.badge_outlined,
                      size: 18, color: AppColors.textHint),
                  validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Employee ID is required'
                      : null,
                ),
                const SizedBox(height: 20),
                Obx(() => AppDropdownField<String>(
                  label: 'Primary Office Location',
                  hint: 'Select location',
                  value: auth.selectedLocation.value.isEmpty
                      ? null
                      : auth.selectedLocation.value,
                  items: auth.officeLocations,
                  itemLabel: (loc) => loc,
                  onChanged: (v) => auth.selectedLocation.value = v ?? '',
                )),
                const SizedBox(height: 20),
                Obx(() => AppDropdownField<String>(
                  label: 'Project Assigned',
                  hint: 'Select project',
                  value: auth.selectedProject.value.isEmpty
                      ? null
                      : auth.selectedProject.value,
                  items: auth.projects,
                  itemLabel: (p) => p,
                  onChanged: (v) => auth.selectedProject.value = v ?? '',
                )),
                const SizedBox(height: 20),

                // Shift (readonly — General)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shift',
                      style: GoogleFonts.inter(
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
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.border, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.schedule_rounded,
                              size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            'General Shift',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Default',
                            style: GoogleFonts.inter(
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
                AppTextField(
                  label: 'Employment Till Date',
                  hint: 'DD / MM / YYYY',
                  controller: auth.signupEmploymentTillController,
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
                      auth.signupEmploymentTillController.text =
                      '${picked.day.toString().padLeft(2, '0')} / '
                          '${picked.month.toString().padLeft(2, '0')} / '
                          '${picked.year}';
                    }
                  },
                  validator: (v) =>
                  (v == null || v.trim().isEmpty)
                      ? 'Employment till date is required'
                      : null,
                ),

                const SizedBox(height: 36),
                Obx(() => ElevatedButton(
                  onPressed: auth.isLoading.value
                      ? null
                      : () {
                    if (formKey.currentState!.validate()) {
                      if (auth.selectedLocation.value.isEmpty) {
                        Get.snackbar(
                          'Required',
                          'Please select an office location.',
                          backgroundColor: Colors.white,
                          colorText: AppColors.textPrimary,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          icon: const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primary),
                        );
                        return;
                      }
                      auth.sendOtp(isSignup: true);
                    }
                  },
                  child: auth.isLoading.value
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Continue & verify phone'),
                )),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.toNamed('/login');
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 13.5,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: "Already registered? "),
                          TextSpan(
                            text: 'Sign in',
                            style: GoogleFonts.inter(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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