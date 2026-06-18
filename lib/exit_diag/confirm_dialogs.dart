// lib/shared/confirm_dialogs.dart
//
// Reusable confirmation dialogs used app-wide for the two "are you sure"
// moments every screen with a logged-in home (ClockScreen, DashboardScreen)
// needs to handle:
//   1. The user explicitly taps "Log out".
//   2. The user presses the system back button / gesture on a root screen,
//      which would otherwise close the app.
//
// Keeping a single shared widget means both flows look and behave
// consistently, and any future tweak (copy, colors, animation) only needs
// to happen in one place.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Generic "are you sure?" dialog with a circular icon badge, title,
/// message, and a Cancel / Confirm button pair. Returns `true` only if the
/// user tapped the confirm button; `false` for cancel, dismiss, or any
/// other outcome.
Future<bool> showConfirmDialog(
    BuildContext context, {
      required IconData icon,
      required Color iconColor,
      required Color iconBackground,
      required String title,
      required String message,
      required String confirmLabel,
      required Color confirmColor,
      String cancelLabel = 'Cancel',
    }) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF777C85),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(cancelLabel),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}

/// "Log out?" confirmation. Shown when the user explicitly taps a logout
/// button/icon. Does not perform the logout itself — the caller should act
/// on the returned bool.
Future<bool> showLogoutDialog(BuildContext context) {
  return showConfirmDialog(
    context,
    icon: Icons.logout_rounded,
    iconColor: const Color(0xFFA32D2D),
    iconBackground: const Color(0xFFFCEBEB),
    title: 'Log out?',
    message:
    "You'll need to sign in again to access your attendance records.",
    confirmLabel: 'Log out',
    confirmColor: const Color(0xFFE24B4A),
  );
}

/// "Exit app?" confirmation. Wire this into a root screen's [PopScope] (set
/// `canPop: false`) so the system back gesture/button asks for confirmation
/// instead of silently closing the app or popping to nowhere.
Future<bool> showExitAppDialog(BuildContext context) {
  return showConfirmDialog(
    context,
    icon: Icons.exit_to_app_rounded,
    iconColor: const Color(0xFFA32D2D),
    iconBackground: const Color(0xFFFCEBEB),
    title: 'Exit app?',
    message: 'Are you sure you want to close the app?',
    confirmLabel: 'Exit',
    confirmColor: const Color(0xFFE24B4A),
  );
}

/// Actually closes the app. Call only after [showExitAppDialog] returns
/// `true`. On Android this exits to the home screen; on iOS, Apple's
/// guidelines discourage programmatic quitting, so this is a no-op there —
/// in practice this dialog is most useful for Android back-button handling.
void closeApp() {
  SystemNavigator.pop();
}