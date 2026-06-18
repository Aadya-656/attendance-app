import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // Login fields
  final loginNameController = TextEditingController();
  final loginPhoneController = TextEditingController();

  // Signup fields
  final signupNameController = TextEditingController();
  final signupEmployerController = TextEditingController();
  final signupEmployeeIdController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPhoneController = TextEditingController();
  final signupEmploymentTillController = TextEditingController();

  // Admin fields
  final adminEmailController = TextEditingController();
  final adminPasswordController = TextEditingController();
  final adminPhoneController = TextEditingController();

  // OTP
  final otpController = TextEditingController();

  // Observables
  final selectedLocation = ''.obs;
  final selectedProject = ''.obs;
  final isLoading = false.obs;
  final otpSent = false.obs;
  final isSignupFlow = false.obs;
  final isAdminFlow = false.obs;

  final List<String> officeLocations = [
    'Chanakyapuri',
    'Connaught Place',
    'Aerocity',
    'Gurgaon Cyber City',
    'Noida Sector 62',
  ];

  final List<String> projects = [
    'Project Alpha',
    'Project Beta',
    'Project Gamma',
    'Project Delta',
    'Infrastructure',
    'Operations',
  ];

  // Mock: send OTP (employee or admin)
  void sendOtp({required bool isSignup}) {
    isSignupFlow.value = isSignup;
    isAdminFlow.value = false;
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      isLoading.value = false;
      otpSent.value = true;
      Get.toNamed('/otp');
    });
  }

  // Admin: verify credentials then send OTP to phone
  void sendAdminOtp() {
    isAdminFlow.value = true;
    isSignupFlow.value = false;
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1200), () {
      isLoading.value = false;
      otpSent.value = true;
      Get.toNamed('/otp');
    });
  }

  // Mock: verify OTP and proceed
  void verifyOtp() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      isLoading.value = false;
      Get.offAllNamed(isAdminFlow.value ? '/dashboard' : '/clock');
      Get.snackbar(
        '',
        '',
        titleText: Text(
          isAdminFlow.value ? 'Welcome, Admin!' : 'Welcome aboard!',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF0F172A),
          ),
        ),
        messageText: const Text(
          'You have successfully signed in.',
          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        backgroundColor: Colors.white,
        colorText: const Color(0xFF0F172A),
        icon: const Icon(Icons.check_circle_rounded,
            color: Color(0xFF10B981), size: 24),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      );
    });
  }

  // Clears session state and returns to the welcome screen. Call this only
  // after the user has confirmed via the logout confirmation dialog
  // (see lib/shared/confirm_dialogs.dart).
  void logout() {
    clearAll();
    Get.offAllNamed('/welcome');
  }

  void clearAll() {
    loginNameController.clear();
    loginPhoneController.clear();
    signupNameController.clear();
    signupEmployerController.clear();
    signupEmployeeIdController.clear();
    signupEmailController.clear();
    signupPhoneController.clear();
    signupEmploymentTillController.clear();
    adminEmailController.clear();
    adminPasswordController.clear();
    adminPhoneController.clear();
    otpController.clear();
    selectedLocation.value = '';
    selectedProject.value = '';
    otpSent.value = false;
    isAdminFlow.value = false;
  }

  @override
  void onClose() {
    loginNameController.dispose();
    loginPhoneController.dispose();
    signupNameController.dispose();
    signupEmployerController.dispose();
    signupEmployeeIdController.dispose();
    signupEmailController.dispose();
    signupPhoneController.dispose();
    signupEmploymentTillController.dispose();
    adminEmailController.dispose();
    adminPasswordController.dispose();
    adminPhoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}