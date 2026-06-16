import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'location_model.dart';
import 'location_directory_view.dart';

class LocationController extends GetxController {
  final sites             = <OfficeSite>[].obs;
  final selectedOfficeName = Rxn<String>();
  final selectedPreset     = Rxn<CoordinatePreset>();
  final selectedRadius     = GeofenceRadius.hundred.obs;
  final isLoading          = false.obs;
  final editingSite        = Rxn<OfficeSite>();

  List<CoordinatePreset> get availablePresets {
    final name = selectedOfficeName.value;
    if (name == null) return [];
    return LocationConstants.officePresets[name] ?? [];
  }

  @override
  void onInit() {
    super.onInit();
    _loadMockSites();
  }

  void beginEdit(OfficeSite site) {
    editingSite.value        = site;
    selectedOfficeName.value = site.name;
    selectedRadius.value     = site.radius;
    final presets = LocationConstants.officePresets[site.name] ?? [];
    final matches = presets.where((p) => p.lat == site.lat && p.lng == site.lng);
    selectedPreset.value = matches.isEmpty ? null : matches.first;
  }

  void resetForm() {
    editingSite.value        = null;
    selectedOfficeName.value = null;
    selectedPreset.value     = null;
    selectedRadius.value     = GeofenceRadius.hundred;
  }

  void onOfficeChanged(String? name) {
    selectedOfficeName.value = name;
    selectedPreset.value     = null;
  }

  Future<void> saveSite() async {
    if (selectedOfficeName.value == null || selectedPreset.value == null) {
      Get.snackbar('Missing fields', 'Select an office and a coordinate point.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));

    final preset  = selectedPreset.value!;
    final now     = DateTime.now();
    final editing = editingSite.value;

    if (editing != null) {
      final idx = sites.indexWhere((s) => s.id == editing.id);
      if (idx != -1) {
        sites[idx] = editing.copyWith(
          name: selectedOfficeName.value, lat: preset.lat,
          lng: preset.lng, radius: selectedRadius.value, updatedAt: now,
        );
      }

      Get.snackbar(
        'Saved',
        '${selectedOfficeName.value} updated successfully.',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      final exists = sites.any((s) => s.name == selectedOfficeName.value && s.isActive);
      if (exists) {
        isLoading.value = false;
        Get.snackbar('Already exists',
            '${selectedOfficeName.value} already has an active site.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange.shade800,
            colorText: Colors.white);
        return;
      }

      sites.add(OfficeSite(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: selectedOfficeName.value!,
        lat: preset.lat, lng: preset.lng,
        radius: selectedRadius.value, updatedAt: now,
      ));

      // 🟢 The Green Success Message
      Get.snackbar(
        'Success',
        'Office added successfully!',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }

    isLoading.value = false;

    // Force the redirect FIRST so the screen doesn't sit there
    Get.offAll(() => const LocationDirectoryView());

    // Reset the form silently in the background AFTER navigating
    Future.delayed(const Duration(milliseconds: 300), () {
      resetForm();
    });
  }

  void toggleActive(String id) {
    final idx = sites.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    sites[idx] = sites[idx].copyWith(
        isActive: !sites[idx].isActive, updatedAt: DateTime.now());
  }

  void deleteSite(String id) {
    sites.removeWhere((s) => s.id == id);
    Get.snackbar('Removed', 'Site removed.', snackPosition: SnackPosition.BOTTOM);
  }

  void _loadMockSites() {
    sites.addAll([
      OfficeSite(id: '001', name: 'Chanakyapuri', lat: 28.5921, lng: 77.1897,
          radius: GeofenceRadius.hundred, isActive: true,
          updatedAt: DateTime.now().subtract(const Duration(days: 2))),
      OfficeSite(id: '002', name: 'ITO', lat: 28.6289, lng: 77.2414,
          radius: GeofenceRadius.fifty, isActive: true,
          updatedAt: DateTime.now().subtract(const Duration(days: 5))),
    ]);
  }
}