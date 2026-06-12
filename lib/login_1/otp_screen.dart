import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_controller.dart';
import 'app_theme.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final List<TextEditingController> digitControllers =
    List.generate(6, (_) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    // Pick the right phone depending on flow
    String phone;
    if (auth.isAdminFlow.value) {
      phone = auth.adminPhoneController.text;
    } else if (auth.isSignupFlow.value) {
      phone = auth.signupPhoneController.text;
    } else {
      phone = auth.loginPhoneController.text;
    }

    String maskedPhone = phone.length >= 10
        ? '+91 XXXXXX${phone.substring(phone.length - 4)}'
        : '+91 XXXXXXXXXX';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.lock_outline_rounded,
                    color: AppColors.primary, size: 26),
              ),
              const SizedBox(height: 24),
              Text(
                'Verify phone',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5),
                  children: [
                    const TextSpan(text: 'A 6-digit OTP was sent to '),
                    TextSpan(
                      text: maskedPhone,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Mock OTP notice
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFDE68A), width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: Color(0xFFD97706), size: 16),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mock mode — enter any 6 digits to continue.',
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: const Color(0xFFD97706),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 46,
                    height: 54,
                    child: TextFormField(
                      controller: digitControllers[i],
                      focusNode: focusNodes[i],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.border, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.border, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 2),
                        ),
                      ),
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          focusNodes[i + 1].requestFocus();
                        } else if (v.isEmpty && i > 0) {
                          focusNodes[i - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              const SizedBox(height: 36),

              Obx(() => ElevatedButton(
                onPressed: auth.isLoading.value
                    ? null
                    : () {
                  final otp =
                  digitControllers.map((c) => c.text).join();
                  if (otp.length < 6) {
                    Get.snackbar(
                      'Incomplete OTP',
                      'Please enter all 6 digits.',
                      backgroundColor: Colors.white,
                      colorText: AppColors.textPrimary,
                      icon: const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFD97706)),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                    return;
                  }
                  auth.verifyOtp();
                },
                child: auth.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
                    : const Text('Verify & continue'),
              )),

              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'OTP Resent',
                      'A new OTP has been sent to $maskedPhone.',
                      backgroundColor: Colors.white,
                      colorText: AppColors.textPrimary,
                      icon: const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary),
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                          fontSize: 13.5, color: AppColors.textSecondary),
                      children: [
                        const TextSpan(text: "Didn't receive it? "),
                        TextSpan(
                          text: 'Resend OTP',
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
            ],
          ),
        ),
      ),
    );
  }
}