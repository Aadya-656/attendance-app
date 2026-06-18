// lib/attendance/clock_screen.dart

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'attendance_model.dart';
import 'clock_controller.dart';
import 'location_card.dart';
import '../modules/profile_controller.dart'; // adjust path if needed
import '../login_1/auth_controller.dart';
import '../exit_diag/confirm_dialogs.dart';

// ─── Main Screen ──────────────────────────────────────────────────────────────

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ClockController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final confirmed = await showExitAppDialog(context);
        if (confirmed) {
          closeApp();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 28),
                _buildStatusCard(ctrl),
                const SizedBox(height: 20),
                LocationRadiusCard(ctrl: ctrl),
                const SizedBox(height: 20),
                _buildPermissionsCard(ctrl),
                const SizedBox(height: 20),
                _buildSelfieCard(context, ctrl),
                const SizedBox(height: 20),
                _buildRemoteCard(ctrl),
                const SizedBox(height: 32),
                _buildClockButton(ctrl),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Shows the shared logout confirmation and, if accepted, clears the
  // session and returns to the welcome screen.
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showLogoutDialog(context);
    if (confirmed) {
      Get.find<AuthController>().logout();
    }
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final dayLabel =
        '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';

    // Ensure ProfileController is registered; register lazily if not yet done.
    if (!Get.isRegistered<ProfileController>()) {
      Get.put(ProfileController());
    }
    final profileCtrl = Get.find<ProfileController>();

    // Obx now correctly reads profileCtrl.profile (an Rx variable) directly,
    // so GetX can track it and rebuild only this widget on change.
    return Obx(() {
      final name = profileCtrl.profile.value?.name;
      final initial = (name != null && name.isNotEmpty)
          ? name[0].toUpperCase()
          : null;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Attendance',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111111),
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 2),
              Text(dayLabel,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w400)),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _confirmLogout(context),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 40,
                    height: 40,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFCEBEB),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Center(
                      child: Icon(Icons.logout_rounded,
                          color: Color(0xFFA32D2D), size: 20),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.toNamed('/profile'),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Center(
                      child: initial != null
                          ? Text(initial,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700))
                          : const Icon(Icons.person_outline_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatusCard(ClockController ctrl) {
    return Obx(() {
      final isClockedIn = ctrl.status.value == ClockStatus.clockedIn;
      final bgColor =
      isClockedIn ? const Color(0xFF2563EB) : const Color(0xFFFFFFFF);
      final textColor = isClockedIn ? Colors.white : const Color(0xFF111111);
      final subColor = isClockedIn
          ? Colors.white.withValues(alpha: 0.55)
          : const Color(0xFF888888);
      final badgeBg = isClockedIn
          ? Colors.white.withValues(alpha: 0.12)
          : const Color(0xFFF0F0F0);
      final badgeText = isClockedIn ? Colors.white : const Color(0xFF555555);
      final dotColor =
      isClockedIn ? const Color(0xFF60A5FA) : const Color(0xFFD1D5DB);

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: isClockedIn
                    ? const Color(0xFF2563EB).withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 6))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: dotColor, shape: BoxShape.circle)),
                      const SizedBox(width: 7),
                      Text(isClockedIn ? 'Clocked In' : 'Clocked Out',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: subColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isClockedIn && ctrl.clockInTime.value != null
                        ? 'Since ${ctrl.formatTime(ctrl.clockInTime.value!)}'
                        : 'Not working',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        letterSpacing: -0.3),
                  ),
                  if (isClockedIn && ctrl.clockInTime.value != null) ...[
                    const SizedBox(height: 4),
                    ElapsedTimer(
                        clockInTime: ctrl.clockInTime.value!,
                        textColor: subColor),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: badgeBg, borderRadius: BorderRadius.circular(20)),
              child: Text(ctrl.isRemote.value ? 'Remote' : 'On-site',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: badgeText)),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPermissionsCard(ClockController ctrl) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Permissions',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF888888))),
          const SizedBox(height: 14),
          PermissionRow(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              description: 'Required for selfie verification',
              granted: ctrl.cameraPermission.value,
              onTap: () => ctrl.cameraPermission.value =
              !ctrl.cameraPermission.value),
          const Divider(height: 20, color: Color(0xFFF0F0F0)),
          PermissionRow(
              icon: Icons.my_location_outlined,
              label: 'Location',
              description: 'Required for radius check',
              granted: ctrl.locationPermission.value,
              onTap: () => ctrl.updateLiveLocation()),
        ],
      ),
    ));
  }

  Widget _buildSelfieCard(BuildContext context, ClockController ctrl) {
    return Obx(() {
      final isClockedIn = ctrl.status.value == ClockStatus.clockedIn;
      final isWithinRange =
          ctrl.locationStatus.value == LocationStatus.withinRadius;

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.camera_alt_outlined,
                    size: 17, color: Color(0xFF888888)),
                const SizedBox(width: 6),
                const Text('Selfie Verification',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888888))),
                const Spacer(),
                if (ctrl.hasTakenPhoto.value)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text('Captured',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB))),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            if (ctrl.hasTakenPhoto.value &&
                ctrl.capturedImagePath.value != null) ...[
              GestureDetector(
                onTap: () => _showSelfieOverlay(
                  context: context,
                  imagePath: ctrl.capturedImagePath.value!,
                  latitude: ctrl.photoLatitude.value,
                  longitude: ctrl.photoLongitude.value,
                  timestamp: ctrl.photoTimestamp.value,
                  address: ctrl.photoAddress.value,
                  subLocality: ctrl.photoSubLocality.value,
                  locality: ctrl.photoLocality.value,
                  accuracy: ctrl.photoAccuracy.value,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(File(ctrl.capturedImagePath.value!),
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.open_in_full_rounded,
                                size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text('Tap to expand',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (!isClockedIn)
              GestureDetector(
                onTap: (isWithinRange || ctrl.isRemote.value)
                    ? ctrl.takePhoto
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (isWithinRange || ctrl.isRemote.value)
                        ? (ctrl.hasTakenPhoto.value
                        ? const Color(0xFFF5F5F7)
                        : const Color(0xFF2563EB))
                        : const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(10),
                    border: ctrl.hasTakenPhoto.value
                        ? Border.all(color: const Color(0xFFE5E5E5))
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        ctrl.hasTakenPhoto.value
                            ? Icons.cameraswitch_outlined
                            : Icons.camera_alt_outlined,
                        size: 18,
                        color: (isWithinRange || ctrl.isRemote.value)
                            ? (ctrl.hasTakenPhoto.value
                            ? const Color(0xFF555555)
                            : Colors.white)
                            : const Color(0xFFAAAAAA),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ctrl.hasTakenPhoto.value ? 'Retake Photo' : 'Take Selfie',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: (isWithinRange || ctrl.isRemote.value)
                              ? (ctrl.hasTakenPhoto.value
                              ? const Color(0xFF555555)
                              : Colors.white)
                              : const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 44,
                decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E5E5))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline_rounded,
                        size: 18, color: Color(0xFF2563EB)),
                    SizedBox(width: 8),
                    Text('Photo on file',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF555555))),
                  ],
                ),
              ),
            if (!ctrl.cameraPermission.value) ...[
              const SizedBox(height: 8),
              const Text('Grant camera permission above to take your selfie.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
            ] else if (!isWithinRange && !ctrl.isRemote.value) ...[
              const SizedBox(height: 8),
              const Text(
                  'You must be within the 100m location radius to unlock selfie verification.',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFDC2626),
                      fontWeight: FontWeight.w500)),
            ] else if (!ctrl.hasTakenPhoto.value) ...[
              const SizedBox(height: 8),
              const Text('A selfie is required before you can clock in.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF888888))),
            ],
          ],
        ),
      );
    });
  }

  void _showSelfieOverlay({
    required BuildContext context,
    required String imagePath,
    required double? latitude,
    required double? longitude,
    required DateTime? timestamp,
    String? address,
    String? subLocality,
    String? locality,
    double? accuracy,
  }) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      pageBuilder: (_, __, ___) => SelfieFullscreenOverlay(
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        address: address,
        subLocality: subLocality,
        locality: locality,
        accuracy: accuracy,
      ),
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
    ));
  }

  Widget _buildRemoteCard(ClockController ctrl) {
    return Obx(() => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Icon(Icons.home_work_outlined,
                    size: 17, color: Color(0xFF888888)),
                const SizedBox(width: 6),
                const Text('Working Remotely',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF888888))),
                const Spacer(),
                GestureDetector(
                  onTap: ctrl.toggleRemote,
                  child: Toggle(value: ctrl.isRemote.value),
                ),
              ],
            ),
          ),
          if (ctrl.isRemote.value) ...[
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555))),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: ctrl.selectedRemoteLocationId.value,
                        hint: const Text('Select location',
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFFBBBBBB))),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF888888), size: 20),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF111111)),
                        items: kRemoteLocations.map((loc) {
                          return DropdownMenuItem<String>(
                              value: loc['id'], child: Text(loc['name']!));
                        }).toList(),
                        onChanged: (val) =>
                        ctrl.selectedRemoteLocationId.value = val,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Reason',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF555555))),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F7),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      maxLines: 3,
                      maxLength: 50,
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF111111)),
                      decoration: const InputDecoration(
                        hintText:
                        'Briefly explain why you\'re working remotely…',
                        hintStyle: TextStyle(
                            fontSize: 13, color: Color(0xFFBBBBBB)),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                      ),
                      onChanged: (val) => ctrl.remoteReason.value = val,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ));
  }

  Widget _buildClockButton(ClockController ctrl) {
    return Obx(() {
      final isClockedIn = ctrl.status.value == ClockStatus.clockedIn;
      final enabled = isClockedIn || ctrl.canClockIn;

      return ScaleTransition(
        scale: ctrl.buttonScaleAnim,
        child: GestureDetector(
          onTap: enabled ? ctrl.toggleClock : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: enabled
                  ? (isClockedIn
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF2563EB))
                  : const Color(0xFFE5E5E5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                isClockedIn ? 'Clock Out' : 'Clock In',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: enabled ? Colors.white : const Color(0xFFAAAAAA),
                    letterSpacing: 0.2),
              ),
            ),
          ),
        ),
      );
    });
  }
}

// ─── Shared Components ────────────────────────────────────────────────────────

class PermissionRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool granted;
  final VoidCallback onTap;

  const PermissionRow(
      {super.key,
        required this.icon,
        required this.label,
        required this.description,
        required this.granted,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 22, color: const Color(0xFF444444)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111111))),
              Text(description,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF888888))),
            ],
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: granted
                    ? const Color(0xFFEFF6FF)
                    : const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(6)),
            child: Text(
              granted ? 'Granted' : 'Allow',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB)),
            ),
          ),
        ),
      ],
    );
  }
}

class Toggle extends StatelessWidget {
  final bool value;
  const Toggle({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44,
      height: 24,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: value ? const Color(0xFF2563EB) : const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(12)),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle)),
      ),
    );
  }
}

class ElapsedTimer extends StatefulWidget {
  final DateTime clockInTime;
  final Color textColor;
  const ElapsedTimer(
      {super.key, required this.clockInTime, required this.textColor});

  @override
  State<ElapsedTimer> createState() => _ElapsedTimerState();
}

class _ElapsedTimerState extends State<ElapsedTimer> {
  late String _elapsed;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(_update);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _update() {
    final diff = DateTime.now().difference(widget.clockInTime);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    _elapsed = '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _elapsed,
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: widget.textColor,
          fontFeatures: const [FontFeature.tabularFigures()]),
    );
  }
}

// ─── Camera Verification ──────────────────────────────────────────────────────

class CameraController2 extends GetxController {
  final CameraDescription camera;
  final double latitude;
  final double longitude;

  CameraController2({
    required this.camera,
    required this.latitude,
    required this.longitude,
  });

  late CameraController ctrl;
  late Future<void> initFuture;
  final capturing = false.obs;
  final captured = Rxn<XFile>();
  final now = DateTime.now().obs;
  Timer? _clockTimer;

  @override
  void onInit() {
    super.onInit();
    ctrl = CameraController(camera, ResolutionPreset.high, enableAudio: false);
    initFuture = ctrl.initialize();
    _clockTimer = Timer.periodic(
        const Duration(seconds: 1), (_) => now.value = DateTime.now());
  }

  @override
  void onClose() {
    ctrl.dispose();
    _clockTimer?.cancel();
    super.onClose();
  }

  Future<void> capture() async {
    if (capturing.value) return;
    capturing.value = true;
    try {
      final file = await ctrl.takePicture();
      captured.value = file;
    } catch (_) {
      // ignore
    } finally {
      capturing.value = false;
    }
  }

  void retake() => captured.value = null;
  void confirm() => Get.back(result: captured.value);
}

class CameraScreen extends StatelessWidget {
  final CameraDescription camera;
  final double latitude;
  final double longitude;

  const CameraScreen({
    super.key,
    required this.camera,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CameraController2(
        camera: camera, latitude: latitude, longitude: longitude));

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<void>(
          future: ctrl.initFuture,
          builder: (ctx, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }
            return Obx(() => ctrl.captured.value != null
                ? _previewView(ctrl)
                : _cameraView(ctrl, context));
          },
        ),
      ),
    );
  }

  Widget _cameraView(CameraController2 ctrl, BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: Transform.scale(
            scale: 1 /
                (ctrl.ctrl.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio),
            child: Center(
              child: Transform.scale(
                scaleX: 1,
                child: CameraPreview(ctrl.ctrl),
              ),
            ),
          ),
        ),
        CustomPaint(painter: _GridPainter()),
        Center(
          child: Container(
            width: 260,
            height: 340,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5), width: 1.5),
              borderRadius: BorderRadius.circular(120),
            ),
          ),
        ),
        Positioned(top: 0, left: 0, right: 0, child: _topBar(ctrl)),
        Positioned(bottom: 0, left: 0, right: 0, child: _bottomBar(ctrl)),
      ],
    );
  }

  Widget _topBar(CameraController2 ctrl) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm:ss').format(ctrl.now.value),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Courier'),
              ),
              Text(
                DateFormat('d MMM yyyy').format(ctrl.now.value),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _bottomBar(CameraController2 ctrl) {
    return Obx(() => Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.85), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on,
                    color: Colors.white54, size: 14),
                const SizedBox(width: 4),
                Text(
                  '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Courier',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Text('Selfie\nVerification',
                    style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
              GestureDetector(
                onTap: ctrl.capture,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  width: ctrl.capturing.value ? 62 : 70,
                  height: ctrl.capturing.value ? 62 : 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color: ctrl.capturing.value
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                  child: Center(
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _previewView(CameraController2 ctrl) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.file(File(ctrl.captured.value!.path), fit: BoxFit.cover),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
            color: Colors.black.withValues(alpha: 0.7),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retake'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: ctrl.retake,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Use Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: ctrl.confirm,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 20,
          child: GestureDetector(
            onTap: ctrl.retake,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.close,
                  color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Selfie Fullscreen Overlay ────────────────────────────────────────────────

class SelfieFullscreenOverlay extends StatelessWidget {
  final String imagePath;
  final double? latitude;
  final double? longitude;
  final DateTime? timestamp;
  final String? address;
  final String? subLocality;
  final String? locality;
  final double? accuracy;

  const SelfieFullscreenOverlay({
    super.key,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.address,
    this.subLocality,
    this.locality,
    this.accuracy,
  });

  String _formatDate(DateTime dt) => DateFormat('d-MMM-yyyy').format(dt);
  String _formatTime(DateTime dt) => DateFormat('HH:mm:ss').format(dt);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Close button ──────────────────────────────────────────────
              Positioned(
                top: 12,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),

              // ── Photo + metadata ──────────────────────────────────────────
              Center(
                child: GestureDetector(
                  onTap: () {}, // prevent tap-through closing
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 32,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        children: [
                          // Mirrored selfie image
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),

                          // Metadata stamp at bottom (mirrors classic
                          // geo-tag camera overlays: timestamp, address,
                          // nearby tag, coordinates, accuracy)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.85),
                                    Colors.black.withValues(alpha: 0.55),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.6, 1.0],
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Date + time
                                  if (timestamp != null)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        '${_formatDate(timestamp!)} ${_formatTime(timestamp!)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Courier',
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),

                                  // Full street address
                                  if (address != null && address!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        address!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Courier',
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),

                                  // "Nearby: <area>" tag, styled like the
                                  // amber highlight in geo-tag overlays
                                  if ((subLocality != null && subLocality!.isNotEmpty) ||
                                      (locality != null && locality!.isNotEmpty))
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: Text(
                                        'Nearby: ${subLocality ?? locality}',
                                        style: const TextStyle(
                                          color: Color(0xFFFBBF24),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Courier',
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),

                                  // Lat / Lng + accuracy
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded,
                                          size: 13, color: Colors.white70),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Wrap(
                                          spacing: 10,
                                          runSpacing: 2,
                                          crossAxisAlignment: WrapCrossAlignment.center,
                                          children: [
                                            if (latitude != null && longitude != null)
                                              Text(
                                                'Lat: ${latitude!.toStringAsFixed(6)}, Lng: ${longitude!.toStringAsFixed(6)}',
                                                style: const TextStyle(
                                                  color: Color(0xFF86EFAC),
                                                  fontSize: 11.5,
                                                  fontFamily: 'Courier',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            if (accuracy != null)
                                              Text(
                                                'Accuracy: ${accuracy!.toStringAsFixed(1)}m',
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.85),
                                                  fontSize: 11.5,
                                                  fontFamily: 'Courier',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Badge at top-left
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2563EB).withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_user_outlined,
                                      size: 12, color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                    'Selfie Verification',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Dismiss hint
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tap anywhere to close',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12,
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

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(size.width / 3, 0),
        Offset(size.width / 3, size.height), paint);
    canvas.drawLine(Offset(size.width * 2 / 3, 0),
        Offset(size.width * 2 / 3, size.height), paint);
    canvas.drawLine(Offset(0, size.height / 3),
        Offset(size.width, size.height / 3), paint);
    canvas.drawLine(Offset(0, size.height * 2 / 3),
        Offset(size.width, size.height * 2 / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}