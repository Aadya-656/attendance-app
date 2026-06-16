import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'employee_model.dart';
import 'employee_repository.dart';

class EmployeeController extends GetxController {
  final repo = EmployeeRepository();

  var role = "teamLead".obs;
  var search = "".obs;

  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;

  List<EmployeeModel> get filteredEmployees {
    if (search.value.isEmpty) return employees;
    return employees.where((e) {
      return e.name.toLowerCase().contains(search.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    employees.assignAll(repo.getEmployees());
    super.onInit();
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Permission handling
  //
  // To save a file that is actually visible in the phone's Downloads folder,
  // we write to /storage/emulated/0/Download/ — the real public Downloads dir.
  // This path requires MANAGE_EXTERNAL_STORAGE on Android 11+ (SDK 30+), which
  // is the permission that produces the system-level popup the user sees.
  //
  // On Android 10 and below (SDK ≤ 29), the legacy WRITE_EXTERNAL_STORAGE
  // permission is sufficient.
  //
  // On iOS, no permission is needed — the share sheet handles delivery.
  // ──────────────────────────────────────────────────────────────────────────

  Future<int> _sdkVersion() async {
    try {
      final String ver = Platform.operatingSystemVersion;
      // Matches "API level 33" in the version string
      final match = RegExp(r'API level (\d+)').firstMatch(ver);
      if (match != null) return int.tryParse(match.group(1) ?? '0') ?? 0;
      // Fallback: map major Android version → SDK
      final vMatch = RegExp(r'Android (\d+)').firstMatch(ver);
      if (vMatch != null) {
        const m = {15: 35, 14: 34, 13: 33, 12: 32, 11: 30, 10: 29, 9: 28};
        return m[int.tryParse(vMatch.group(1) ?? '0') ?? 0] ?? 0;
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  /// Returns true if we have the permission needed to write to Downloads.
  /// Shows the system popup automatically if not yet granted.
  Future<bool> _requestStoragePermission() async {
    if (Platform.isIOS) return true;

    if (!Platform.isAndroid) return true;

    final sdk = await _sdkVersion();

    if (sdk >= 30) {
      // Android 11+ — need MANAGE_EXTERNAL_STORAGE
      // This is what triggers the real system-level permission screen
      final status = await Permission.manageExternalStorage.status;

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(
          "Storage Permission Required",
          "Please grant 'All files access' in App Settings so the CSV can be saved to your Downloads folder.",
        );
        return false;
      }

      // .request() on manageExternalStorage opens the system permission page
      final result = await Permission.manageExternalStorage.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        _showSettingsDialog(
          "Permission Denied",
          "Storage access was denied. Please enable 'All files access' in App Settings.",
        );
        return false;
      }

      // User dismissed or denied
      Get.snackbar(
        "Permission Needed",
        "Allow storage access to save the CSV to Downloads.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      return false;
    } else {
      // Android 10 and below — legacy WRITE_EXTERNAL_STORAGE
      final status = await Permission.storage.status;

      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        _showSettingsDialog(
          "Storage Permission Required",
          "Please enable storage access in App Settings to save the CSV file.",
        );
        return false;
      }

      final result = await Permission.storage.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        _showSettingsDialog(
          "Permission Denied",
          "Storage access was denied. Please enable it in App Settings.",
        );
        return false;
      }

      Get.snackbar(
        "Permission Needed",
        "Allow storage access to save the CSV to Downloads.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  void _showSettingsDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, color: Color(0xff555555)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4D6BFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text(
              "Open Settings",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // CSV export — saves directly to the public Downloads folder
  // ──────────────────────────────────────────────────────────────────────────
  Future<void> exportCSV() async {
    // 1. Request permission — this triggers the system popup on Android
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    // 2. Build CSV rows
    final List<List<dynamic>> rows = [
      ["Name", "Designation", "Office", "Present", "Absent"],
      for (final e in employees)
        [e.name, e.designation, e.office, e.present, e.absent],
    ];
    final String csvContent = const ListToCsvConverter().convert(rows);

    // 3. Resolve the save path
    File file;
    if (Platform.isAndroid) {
      // Write directly to the public Downloads folder — visible in Files app
      const downloadsPath = '/storage/emulated/0/Download';
      final dir = Directory(downloadsPath);
      if (!await dir.exists()) await dir.create(recursive: true);
      file = File('$downloadsPath/employees.csv');
    } else {
      // iOS: temp dir + share sheet
      final dir = await getTemporaryDirectory();
      file = File('${dir.path}/employees.csv');
    }

    // 4. Write file
    await file.writeAsString(csvContent);

    // 5. Notify user + offer share sheet
    Get.snackbar(
      "CSV Saved",
      "employees.csv saved to Downloads.",
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      backgroundColor: const Color(0xff4CAF50),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Also open share sheet so the user can send it elsewhere if needed
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Employee Data',
    );
  }
}