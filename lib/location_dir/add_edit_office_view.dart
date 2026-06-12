// ============================================================
// FILE 4 of 4: lib/screens/admin/add_edit_office_view.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'location_controller.dart';
import 'location_model.dart';

class _C {
  static const bg      = Color(0xFFF0F4FF);
  static const card    = Colors.white;
  static const blue    = Color(0xFF2563EB);
  static const blueBg  = Color(0xFFEFF4FF);
  static const t1      = Color(0xFF111827);
  static const t2      = Color(0xFF6B7280);
  static const t3      = Color(0xFF9CA3AF);
  static const border  = Color(0xFFE5E7EB);
  static const inputBg = Color(0xFFF9FAFB);
}

class AddEditOfficeView extends StatelessWidget {
  const AddEditOfficeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<LocationController>();

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Back + Title ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
              child: Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 18, color: _C.t1),
                  onPressed: () { ctrl.resetForm(); Get.back(); },
                ),
                const SizedBox(width: 4),
                Obx(() => Text(
                  ctrl.editingSite.value != null
                      ? 'Edit office site'
                      : 'Add office site',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _C.t1),
                )),
              ]),
            ),

            // ── Subtitle ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 0),
              child: Obx(() => Text(
                ctrl.editingSite.value != null
                    ? 'Update location and geo-fence settings.'
                    : 'Configure geo-fencing for a CRIS office.',
                style: const TextStyle(fontSize: 13, color: _C.t2),
              )),
            ),

            const SizedBox(height: 24),

            // ── Scrollable form ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    // ── Step 1: Office ───────────────────
                    _StepCard(
                      number: '1',
                      title: 'Select office',
                      child: Obx(() => _DropdownField<String>(
                        value: ctrl.selectedOfficeName.value,
                        hint: 'Choose an office',
                        icon: Icons.business_outlined,
                        enabled: ctrl.editingSite.value == null,
                        items: LocationConstants.officeNames
                            .map((n) => DropdownMenuItem(
                          value: n,
                          child: Text(n,
                              style: const TextStyle(
                                  fontSize: 14, color: _C.t1)),
                        ))
                            .toList(),
                        onChanged: ctrl.onOfficeChanged,
                      )),
                    ),

                    const SizedBox(height: 14),

                    // ── Step 2: Coordinate ───────────────
                    Obx(() {
                      final ready = ctrl.selectedOfficeName.value != null;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: ready ? 1.0 : 0.35,
                        child: IgnorePointer(
                          ignoring: !ready,
                          child: _StepCard(
                            number: '2',
                            title: 'Select coordinates',
                            subtitle: ready
                                ? ctrl.selectedOfficeName.value!
                                : 'Select an office first',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() => _DropdownField<CoordinatePreset>(
                                  value: ctrl.selectedPreset.value,
                                  hint: 'Choose anchor point',
                                  icon: Icons.my_location_outlined,
                                  enabled: true,
                                  items: ctrl.availablePresets
                                      .map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(p.label,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: _C.t1)),

                                      ],
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (p) =>
                                  ctrl.selectedPreset.value = p,
                                )),
                                // Live coord display
                                Obx(() {
                                  final p = ctrl.selectedPreset.value;
                                  if (p == null) return const SizedBox.shrink();
                                  return Container(
                                    margin: const EdgeInsets.only(top: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _C.blueBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(children: [
                                      const Icon(Icons.pin_drop_outlined,
                                          size: 15, color: _C.blue),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Lat: ${p.lat.toStringAsFixed(6)}   '
                                            'Lng: ${p.lng.toStringAsFixed(6)}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: _C.blue,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ]),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // ── Step 3: Radius ───────────────────
                    Obx(() {
                      final ready = ctrl.selectedPreset.value != null;
                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: ready ? 1.0 : 0.35,
                        child: IgnorePointer(
                          ignoring: !ready,
                          child: _StepCard(
                            number: '3',
                            title: 'Geo-fence radius',
                            subtitle: 'Set the check-in boundary distance',
                            child: Obx(() => Row(
                              children: GeofenceRadius.values.map((r) {
                                final sel = ctrl.selectedRadius.value == r;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => ctrl.selectedRadius.value = r,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      decoration: BoxDecoration(
                                        color: sel ? _C.blue : _C.inputBg,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: sel ? _C.blue : _C.border,
                                        ),
                                      ),
                                      child: Column(children: [
                                        Icon(Icons.radar_outlined,
                                            size: 22,
                                            color: sel
                                                ? Colors.white
                                                : _C.t2),
                                        const SizedBox(height: 6),
                                        Text(r.label,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: sel
                                                    ? Colors.white
                                                    : _C.t1)),
                                        const SizedBox(height: 2),
                                        Text('radius',
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: sel
                                                    ? Colors.white70
                                                    : _C.t3)),
                                      ]),
                                    ),
                                  ),
                                );
                              }).toList(),
                            )),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 14),

                    // ── Summary preview ──────────────────
                    Obx(() {
                      final ok = ctrl.selectedOfficeName.value != null &&
                          ctrl.selectedPreset.value != null;
                      if (!ok) return const SizedBox.shrink();
                      final p = ctrl.selectedPreset.value!;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _C.blueBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 15, color: _C.blue),
                              const SizedBox(width: 6),
                              const Text('Ready to save',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: _C.blue)),
                            ]),
                            const SizedBox(height: 10),
                            _PreviewRow('Office',
                                ctrl.selectedOfficeName.value!),
                            _PreviewRow('Point', p.label),
                            _PreviewRow('Coordinates',
                                '${p.lat.toStringAsFixed(4)}°N, '
                                    '${p.lng.toStringAsFixed(4)}°E'),
                            _PreviewRow('Radius',
                                '${ctrl.selectedRadius.value.meters} m',
                                isLast: true),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 28),

                    // ── Save button ──────────────────────
                    Obx(() {
                      final ready = ctrl.selectedOfficeName.value != null &&
                          ctrl.selectedPreset.value != null;
                      return GestureDetector(
                        onTap: (ctrl.isLoading.value || !ready)
                            ? null
                            : ctrl.saveSite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 54,
                          decoration: BoxDecoration(
                            color: ready ? _C.blue : _C.border,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: ctrl.isLoading.value
                                ? const SizedBox(
                                width: 22, height: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                                : Text(
                                ctrl.editingSite.value != null
                                    ? 'Save changes'
                                    : 'Add office site',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: ready
                                        ? Colors.white
                                        : _C.t3)),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step card ─────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final String number, title;
  final String? subtitle;
  final Widget child;
  const _StepCard({
    required this.number,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _C.card,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
                color: _C.blue, borderRadius: BorderRadius.circular(13)),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _C.t1)),
            if (subtitle != null)
              Text(subtitle!,
                  style: const TextStyle(fontSize: 11, color: _C.t2)),
          ]),
        ]),
        const SizedBox(height: 16),
        child,
      ]),
    );
  }
}

// ── Generic dropdown ──────────────────────────────────────────
class _DropdownField<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final bool enabled;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  const _DropdownField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.enabled,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      onChanged: enabled ? onChanged : null,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: _C.t2, size: 22),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _C.t3, fontSize: 14),
        filled: true,
        fillColor: enabled ? _C.inputBg : const Color(0xFFF3F4F6),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        prefixIcon: Icon(icon, size: 18, color: _C.t2),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _C.blue, width: 1.5)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
            BorderSide(color: _C.border.withOpacity(0.4))),
      ),
      items: items,
    );
  }
}

// ── Preview row ───────────────────────────────────────────────
class _PreviewRow extends StatelessWidget {
  final String label, value;
  final bool isLast;
  const _PreviewRow(this.label, this.value, {this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 7),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          width: 90,
          child: Text(label,
              style: const TextStyle(fontSize: 12, color: _C.t2)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _C.t1)),
        ),
      ]),
    );
  }
}