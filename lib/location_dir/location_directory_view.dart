// ============================================================
// FILE 3 of 4: lib/screens/admin/location_directory_view.dart
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'location_controller.dart';
import 'location_model.dart';
import 'add_edit_office_view.dart';

// ── Single colour palette ─────────────────────────────────────
// Blue: #2563EB  |  Background: #F0F4FF  |  Text: #111827 / #6B7280
// Cards: white   |  No reds, no ambers, no greens in main UI
class _C {
  static const bg      = Color(0xFFF0F4FF);
  static const card    = Colors.white;
  static const blue    = Color(0xFF2563EB);
  static const blueBg  = Color(0xFFEFF4FF);
  static const t1      = Color(0xFF111827); // primary text
  static const t2      = Color(0xFF6B7280); // secondary text
  static const t3      = Color(0xFF9CA3AF); // muted text
  static const border  = Color(0xFFF3F4F6); // very subtle border
}

class LocationDirectoryView extends StatelessWidget {
  const LocationDirectoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(LocationController());

    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Back button ──────────────────────────────
            // Pops this screen off the Navigator stack, returning to the
            // Reports tab on the Executive Dashboard (which is what
            // pushed this view in the first place).
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _C.blueBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      color: _C.blue, size: 20),
                ),
              ),
            ),

            // ── Header ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Location\nDirectory',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: _C.t1,
                                height: 1.15)),
                        const SizedBox(height: 6),
                        Text('Manage office geo-fence settings',
                            style: TextStyle(
                                fontSize: 14, color: _C.t2)),
                      ],
                    ),
                  ),
                  // Add button — top right icon
                  GestureDetector(
                    onTap: () => _goToAdd(ctrl),
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: _C.blue,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 26),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Stats row ─────────────────────────────────
            Obx(() {
              final active   = ctrl.sites.where((s) => s.isActive).length;
              final inactive = ctrl.sites.length - active;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(children: [
                  _StatCard(value: '${ctrl.sites.length}', label: 'Total offices'),
                  const SizedBox(width: 12),
                  _StatCard(value: '$active',   label: 'Active'),
                  const SizedBox(width: 12),
                  _StatCard(value: '$inactive', label: 'Inactive'),
                ]),
              );
            }),

            const SizedBox(height: 24),

            // ── List ──────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (ctrl.sites.isEmpty) {
                  return _EmptyState(onAdd: () => _goToAdd(ctrl));
                }
                final active   = ctrl.sites.where((s) => s.isActive).toList();
                final inactive = ctrl.sites.where((s) => !s.isActive).toList();
                return ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  children: [
                    if (active.isNotEmpty) ...[
                      _ListLabel('Active sites'),
                      const SizedBox(height: 10),
                      ...active.map((s) => _SiteCard(
                        site: s,
                        onEdit:   () => _goToEdit(ctrl, s),
                        onToggle: () => _confirmToggle(context, ctrl, s),
                        onDelete: () => _confirmDelete(context, ctrl, s),
                      )),
                    ],
                    if (inactive.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _ListLabel('Inactive sites'),
                      const SizedBox(height: 10),
                      ...inactive.map((s) => _SiteCard(
                        site: s,
                        onEdit:   () => _goToEdit(ctrl, s),
                        onToggle: () => _confirmToggle(context, ctrl, s),
                        onDelete: () => _confirmDelete(context, ctrl, s),
                        dimmed: true,
                      )),
                    ],
                  ],
                );
              }),
            ),
          ],
        ),
      ),


    );
  }

  void _goToAdd(LocationController ctrl) {
    ctrl.resetForm();
    Get.to(() => const AddEditOfficeView(), transition: Transition.rightToLeft);
  }

  void _goToEdit(LocationController ctrl, OfficeSite site) {
    ctrl.beginEdit(site);
    Get.to(() => const AddEditOfficeView(), transition: Transition.rightToLeft);
  }

  void _confirmToggle(BuildContext ctx, LocationController ctrl, OfficeSite site) {
    showDialog(context: ctx, builder: (_) => _Dialog(
      title: site.isActive ? 'Deactivate site?' : 'Activate site?',
      body:  site.isActive
          ? 'Geo-fencing will be paused for ${site.name}.'
          : 'Geo-fencing will resume for ${site.name}.',
      actionLabel: site.isActive ? 'Deactivate' : 'Activate',
      onConfirm: () => ctrl.toggleActive(site.id),
    ));
  }

  void _confirmDelete(BuildContext ctx, LocationController ctrl, OfficeSite site) {
    showDialog(context: ctx, builder: (_) => _Dialog(
      title: 'Remove ${site.name}?',
      body:  'This will permanently delete this office site.',
      actionLabel: 'Remove',
      onConfirm: () => ctrl.deleteSite(site.id),
    ));
  }
}

// ── Stat card ─────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w800, color: _C.t1)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(fontSize: 11, color: _C.t2)),
        ]),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────
class _ListLabel extends StatelessWidget {
  final String text;
  const _ListLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _C.t3,
            letterSpacing: 0.6));
  }
}

// ── Site card ─────────────────────────────────────────────────
class _SiteCard extends StatelessWidget {
  final OfficeSite site;
  final VoidCallback onEdit, onToggle, onDelete;
  final bool dimmed;
  const _SiteCard({
    required this.site,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
    this.dimmed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: dimmed ? 0.45 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _C.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Top row ────────────────────────────────
            Row(children: [
              // Icon
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: _C.blueBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_outlined,
                    size: 20, color: _C.blue),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(site.name,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _C.t1)),
                    const SizedBox(height: 2),
                    Text(
                      '${site.lat.toStringAsFixed(4)}°N  '
                          '${site.lng.toStringAsFixed(4)}°E',
                      style: const TextStyle(fontSize: 12, color: _C.t2),
                    ),
                  ],
                ),
              ),
              // Active dot
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _C.blueBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: site.isActive ? _C.blue : _C.t3,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    site.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: site.isActive ? _C.blue : _C.t3),
                  ),
                ]),
              ),
            ]),

            const SizedBox(height: 14),
            Container(height: 1, color: _C.border),
            const SizedBox(height: 12),

            // ── Bottom row ─────────────────────────────
            Row(children: [
              // Radius pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _C.blueBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.radar_outlined, size: 13, color: _C.blue),
                  const SizedBox(width: 4),
                  Text(site.radius.label,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _C.blue)),
                ]),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Updated ${DateFormat('d MMM').format(site.updatedAt)}',
                  style: const TextStyle(fontSize: 11, color: _C.t3),
                ),
              ),
              // Actions
              _Btn(icon: Icons.edit_outlined,           onTap: onEdit),
              _Btn(icon: site.isActive
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,           onTap: onToggle),
              _Btn(icon: Icons.delete_outline_rounded,   onTap: onDelete),
            ]),
          ],
        ),
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 19, color: _C.t2),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
              color: _C.blueBg, borderRadius: BorderRadius.circular(20)),
          child: const Icon(Icons.add_location_alt_outlined,
              size: 32, color: _C.blue),
        ),
        const SizedBox(height: 18),
        const Text('No offices added',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: _C.t1)),
        const SizedBox(height: 6),
        Text('Tap below to configure your first site.',
            style: TextStyle(fontSize: 13, color: _C.t2)),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: _C.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Add office site',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14)),
          ),
        ),
      ]),
    );
  }
}

// ── Confirm dialog ────────────────────────────────────────────
class _Dialog extends StatelessWidget {
  final String title, body, actionLabel;
  final VoidCallback onConfirm;
  const _Dialog({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _C.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w700, color: _C.t1)),
      content: Text(body,
          style: const TextStyle(fontSize: 14, color: _C.t2, height: 1.5)),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel',
              style: TextStyle(color: _C.t2, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () { Get.back(); onConfirm(); },
          child: Text(actionLabel,
              style: const TextStyle(
                  color: _C.blue, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}