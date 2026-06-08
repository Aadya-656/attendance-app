// lib/attendance/clock_controller.dart

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'attendance_model.dart';
import 'clock_screen.dart'; // for CameraScreen

class ClockController extends GetxController with GetTickerProviderStateMixin {
  final status = ClockStatus.clockedOut.obs;
  final locationStatus = LocationStatus.loading.obs;
  final cameraPermission = false.obs;
  final locationPermission = false.obs;
  final isRemote = false.obs;
  final selectedRemoteLocationId = Rxn<String>();
  final remoteReason = Rxn<String>();
  final clockInTime = Rxn<DateTime>();
  final hasTakenPhoto = false.obs;
  final capturedImagePath = Rxn<String>();

  final double officeLat = 28.62924;
  final double officeLng = 77.24608;

  final currentLatitude = 28.6139.obs;
  final currentLongitude = 77.2090.obs;
  final distanceFraction = 0.0.obs;

  late AnimationController pulseController;
  late AnimationController buttonController;
  late Animation<double> pulseAnim;
  late Animation<double> buttonScaleAnim;

  @override
  void onInit() {
    super.onInit();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);
    pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeOut),
    );

    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: buttonController, curve: Curves.easeInOut),
    );

    updateLiveLocation();
  }

  @override
  void onClose() {
    pulseController.dispose();
    buttonController.dispose();
    super.onClose();
  }

  bool get canClockIn {
    if (!locationPermission.value || !cameraPermission.value) return false;
    if (locationStatus.value == LocationStatus.loading) return false;
    if (!hasTakenPhoto.value) return false;
    if (isRemote.value) {
      return selectedRemoteLocationId.value != null &&
          (remoteReason.value?.trim().isNotEmpty ?? false);
    }
    return locationStatus.value == LocationStatus.withinRadius;
  }

  Future<void> updateLiveLocation() async {
    locationStatus.value = LocationStatus.loading;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      locationPermission.value = false;
      locationStatus.value = LocationStatus.outsideRadius;
      Get.snackbar("Location Disabled",
          "Please turn on your device's GPS/Location services.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        locationPermission.value = false;
        locationStatus.value = LocationStatus.outsideRadius;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      locationPermission.value = false;
      locationStatus.value = LocationStatus.outsideRadius;
      Get.snackbar("Permissions Blocked",
          "Location permission is permanently denied. Please enable it in system settings.");
      return;
    }

    locationPermission.value = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double distanceInMeters = Geolocator.distanceBetween(
          position.latitude, position.longitude, officeLat, officeLng);

      currentLatitude.value = position.latitude;
      currentLongitude.value = position.longitude;
      distanceFraction.value = distanceInMeters / 100.0;

      locationStatus.value = distanceInMeters <= 100.0
          ? LocationStatus.withinRadius
          : LocationStatus.outsideRadius;
    } catch (e) {
      debugPrint("Error fetching coordinates: $e");
      locationStatus.value = LocationStatus.outsideRadius;
    }
  }

  Future<void> takePhoto() async {
    try {
      final availableSystemCameras = await availableCameras();
      if (availableSystemCameras.isEmpty) {
        throw Exception("No hardware imaging devices detected.");
      }

      final targetLens = availableSystemCameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => availableSystemCameras.first,
      );

      final XFile? photoResult = await Get.to<XFile?>(() => CameraScreen(
        camera: targetLens,
        latitude: currentLatitude.value,
        longitude: currentLongitude.value,
      ));

      if (photoResult != null) {
        capturedImagePath.value = photoResult.path;
        hasTakenPhoto.value = true;
        cameraPermission.value = true;
      }
    } catch (e) {
      debugPrint("Internal Camera Exception: $e");
      cameraPermission.value = false;
    }
  }

  Future<void> toggleClock() async {
    if (status.value == ClockStatus.clockedOut && !canClockIn) return;

    await buttonController.forward();
    await buttonController.reverse();

    if (status.value == ClockStatus.clockedOut) {
      status.value = ClockStatus.clockedIn;
      clockInTime.value = DateTime.now();
    } else {
      status.value = ClockStatus.clockedOut;
      clockInTime.value = null;
      hasTakenPhoto.value = false;
      capturedImagePath.value = null;
    }
  }

  String formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  void toggleRemote() {
    isRemote.value = !isRemote.value;
    if (!isRemote.value) {
      selectedRemoteLocationId.value = null;
      remoteReason.value = null;
    }
  }
}