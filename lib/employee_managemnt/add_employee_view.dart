import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'employee_controller.dart';
import 'employee_model.dart';

// ─────────────────────────────────────────────
// Pending employee data model
// ─────────────────────────────────────────────
class PendingEmployee {
  final String name;
  final String homeOrg;
  final String idNumber;
  final String primaryOffice;
  final String email;
  final String mobile;
  final String project;
  final String shift;
  final String employmentTill;
  final String designation;

  const PendingEmployee({
    required this.name,
    required this.homeOrg,
    required this.idNumber,
    required this.primaryOffice,
    required this.email,
    required this.mobile,
    required this.project,
    required this.shift,
    required this.employmentTill,
    required this.designation,
  });
}

// ─────────────────────────────────────────────
// Mock pending verifications
// ─────────────────────────────────────────────
const List<PendingEmployee> _mockPending = [
  PendingEmployee(
    name: "Neha Joshi",
    homeOrg: "BITS",
    idNumber: "BITS-2024-0471",
    primaryOffice: "Chanakyapuri",
    email: "neha.joshi@bits.ac.in",
    mobile: "+91 98110 34201",
    project: "Flutter",
    shift: "General",
    employmentTill: "18 July 2025",
    designation: "Developer",
  ),
  PendingEmployee(
    name: "Karan Mehta",
    homeOrg: "CIPL",
    idNumber: "CIPL-2024-0188",
    primaryOffice: "ITO",
    email: "karan.mehta@cipl.co.in",
    mobile: "+91 97300 55812",
    project: "Java",
    shift: "Night",
    employmentTill: "18 July 2025",
    designation: "Analyst",
  ),
  PendingEmployee(
    name: "Divya Nair",
    homeOrg: "BITS",
    idNumber: "BITS-2024-0539",
    primaryOffice: "DMRC",
    email: "divya.nair@bits.ac.in",
    mobile: "+91 99990 12345",
    project: "Flutter",
    shift: "General",
    employmentTill: "18 July 2025",
    designation: "Engineer",
  ),
];

// ─────────────────────────────────────────────
// Verification queue screen
// ─────────────────────────────────────────────
class AddEmployeeView extends StatefulWidget {
  const AddEmployeeView({super.key});

  @override
  State<AddEmployeeView> createState() => _AddEmployeeViewState();
}

class _AddEmployeeViewState extends State<AddEmployeeView> {
  static const _primary = Color(0xff4D6BFF);
  static const _bg = Color(0xffEEF2FA);

  final _controller = Get.find<EmployeeController>();
  late final List<PendingEmployee> _pending;

  @override
  void initState() {
    super.initState();
    _pending = List.from(_mockPending);
  }

  void _approve(PendingEmployee emp) {
    _controller.employees.add(EmployeeModel(
      name: emp.name,
      designation: emp.designation,
      office: emp.primaryOffice,
      present: 0,
      absent: 0,
      late: 0,
      leave: 0,
      tour: 0,
      wfh: 0,
      faceIssue: 0,
    ));
    setState(() => _pending.remove(emp));
    Get.snackbar(
      "Approved",
      "${emp.name} added to roster.",
      backgroundColor: const Color(0xff4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _reject(PendingEmployee emp) {
    setState(() => _pending.remove(emp));
    Get.snackbar(
      "Rejected",
      "${emp.name}'s request was rejected.",
      backgroundColor: const Color(0xffEF5350),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          "Verify Employees",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xffE0E0E0), height: 1),
        ),
      ),
      body: _pending.isEmpty
          ? _EmptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _pending.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) => _VerificationCard(
          // KEY is critical — each card gets its own isolated state
          key: ValueKey(_pending[i].idNumber),
          employee: _pending[i],
          onApprove: () => _approve(_pending[i]),
          onReject: () => _reject(_pending[i]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Individual verification card
// Each card is a fully independent StatefulWidget
// so photo state is NEVER shared between cards.
// ─────────────────────────────────────────────
class _VerificationCard extends StatefulWidget {
  final PendingEmployee employee;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const _VerificationCard({
    super.key,
    required this.employee,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_VerificationCard> createState() => _VerificationCardState();
}

class _VerificationCardState extends State<_VerificationCard> {
  static const _primary = Color(0xff4D6BFF);
  static const _green = Color(0xff4CAF50);
  static const _red = Color(0xffEF5350);

  // This File? lives entirely inside this card's state.
  // It is never shared or inherited from any parent or sibling.
  File? _photo;
  bool _expanded = false;

  Future<void> _capturePhoto() async {
    final XFile? picked = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() => _photo = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header row ───────────────────────────────
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar with camera tap
                  GestureDetector(
                    onTap: _capturePhoto,
                    child: Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _primary.withOpacity(0.08),
                            image: _photo != null
                                ? DecorationImage(
                              image: FileImage(_photo!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: _photo == null
                              ? Center(
                            child: Text(
                              emp.name[0],
                              style: const TextStyle(
                                color: _primary,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: _primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_rear,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          emp.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "${emp.designation}  ·  ${emp.homeOrg}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFF8E1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xffFFCC02), width: 0.8),
                          ),
                          child: const Text(
                            "Pending Verification",
                            style: TextStyle(
                              color: Color(0xffE65100),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),

          // ── Expandable details ────────────────────────
          if (_expanded) ...[
            Container(
              height: 1,
              color: const Color(0xffF0F0F0),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                children: [
                  _row(Icons.badge_outlined, "ID Number", emp.idNumber),
                  _row(Icons.location_on_outlined, "Primary Office", emp.primaryOffice),
                  _row(Icons.email_outlined, "Email", emp.email),
                  _row(Icons.phone_outlined, "Mobile", emp.mobile),
                  _row(Icons.code_outlined, "Project", emp.project),
                  _row(Icons.wb_sunny_outlined, "Shift", emp.shift),
                  _row(Icons.event_outlined, "Employment Till", emp.employmentTill,
                      isLast: true),
                  const SizedBox(height: 14),

                  // Photo status / capture button
                  if (_photo == null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _capturePhoto,
                        icon: const Icon(Icons.camera_rear_outlined, size: 17),
                        label: const Text("Capture Employee Photo"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primary,
                          side: const BorderSide(color: _primary, width: 1.2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded,
                            color: _green, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          "Photo captured",
                          style: TextStyle(
                            color: _green,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _capturePhoto,
                          child: Text(
                            "Retake",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],

          // ── Action buttons ────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffFAFAFA),
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: const Border(
                  top: BorderSide(color: Color(0xffF0F0F0), width: 1)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _confirmDialog(
                      context,
                      title: "Reject Request",
                      message:
                      "Reject ${emp.name}'s verification? This cannot be undone.",
                      confirmLabel: "Reject",
                      confirmColor: _red,
                      onConfirm: widget.onReject,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _red,
                      side: const BorderSide(color: _red, width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _confirmDialog(
                      context,
                      title: "Approve & Add",
                      message:
                      "Add ${emp.name} to the employee roster?",
                      confirmLabel: "Approve",
                      confirmColor: _primary,
                      onConfirm: widget.onApprove,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Approve",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value,
      {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[400]),
              const SizedBox(width: 10),
              SizedBox(
                width: 112,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12.5,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Container(height: 0.5, color: const Color(0xffF0F0F0)),
      ],
    );
  }

  void _confirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmLabel,
        required Color confirmColor,
        required VoidCallback onConfirm,
      }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content:
        Text(message, style: const TextStyle(color: Colors.black54, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
            Text("Cancel", style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(confirmLabel,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.how_to_reg_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "All caught up",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "No pending verifications.",
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}