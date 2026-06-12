import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Navigation Controller ─────────────────────────────────────────────────────

class NavController extends GetxController {
  final selectedTab = 0.obs;

  void changeTab(int index) => selectedTab.value = index;
}

// ── Calendar Controller ───────────────────────────────────────────────────────

class CalendarController extends GetxController {
  final year = DateTime.now().year.obs;
  final selectedMonth = Rx<int?>(null); // null = show all months

  void incrementYear() => year.value++;
  void decrementYear() => year.value--;

  void selectMonth(int? month) => selectedMonth.value = month;
}

// ── Snackbar Service ──────────────────────────────────────────────────────────

class SnackbarService {
  static void showComingSoon(String feature) {
    Get.snackbar(
      '',
      '',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E3A6E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 8,
      duration: const Duration(seconds: 2),
      titleText: const SizedBox.shrink(),
      messageText: Text(
        '$feature — Coming Soon',
        style: const TextStyle(fontSize: 13.5, color: Colors.white),
      ),
    );
  }
}