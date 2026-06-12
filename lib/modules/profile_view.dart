// lib/profile_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  static const bg = Color(0xffEEF2FA);
  static const card = Colors.white;
  static const primary = Color(0xff4D6BFF);
  static const text = Color(0xff222222);
  static const sub = Color(0xff777C85);

  final List<Color> calendarColors = const [
    // GREEN = marked/on time
    Colors.green,
    Colors.green,
    // RED = holidays/weekend
    Colors.red,
    // YELLOW = others
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.yellow,
    Colors.green,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.yellow,
    Colors.green,
    Colors.green,
    Colors.green,
    Colors.red,
    Colors.yellow,
    Colors.yellow,
  ];

  @override
  Widget build(BuildContext context) {
    // Gracefully lookup instance lifecycle from global binding domain context
    final ProfileController controller = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: text, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Profile Dashboard",
          style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LIVE GETX REPOSITORY PROFILE CARD BLOCK
              Obx(() {
                if (controller.profile.value == null) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: CircularProgressIndicator(color: primary),
                    ),
                  );
                }
                final user = controller.profile.value!;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: card,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.03),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 68,
                        width: 68,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary.withOpacity(.1),
                        ),
                        child: const Icon(Icons.person_rounded, color: primary, size: 34),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.designation,
                              style: const TextStyle(color: sub, fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.office,
                              style: const TextStyle(color: sub, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // ATTENDANCE CALENDAR MATRIX CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.03),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Attendance History",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: text),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: calendarColors.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: calendarColors[index].withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: calendarColors[index].withOpacity(0.3), width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                color: calendarColors[index].withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // INTERACTIVE BUTTON ITEMS LIST
              const Text(
                "General",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: sub, letterSpacing: 0.5),
              ),
              const SizedBox(height: 12),
              // Fixed the typo here from Icons.耍 to Icons.calendar_today_rounded
              const ProfileActionTile(icon: Icons.calendar_today_rounded, text: "My Leaves"),
              const SizedBox(height: 12),
              const ProfileActionTile(icon: Icons.receipt_long_rounded, text: "Pay Slips"),
              const SizedBox(height: 12),
              const ProfileActionTile(icon: Icons.settings_rounded, text: "Preferences"),
              const SizedBox(height: 32),

              // TERMINAL NAVIGATION RETURN ACTION LINK
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => Get.offAllNamed('/'),
                  icon: const Icon(Icons.punch_clock_rounded, color: Colors.white, size: 20),
                  label: const Text(
                    "Return to Attendance Terminal",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

// HOVER-READY TERMINAL COMPONENT
class ProfileActionTile extends StatefulWidget {
  final IconData icon;
  final String text;

  const ProfileActionTile({super.key, required this.icon, required this.text});

  @override
  State<ProfileActionTile> createState() => _ProfileActionTileState();
}

class _ProfileActionTileState extends State<ProfileActionTile> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, hover ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: hover ? ProfileView.primary : ProfileView.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.03),
              blurRadius: 14,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: hover ? Colors.white : ProfileView.primary,
              size: 22,
            ),
            const SizedBox(width: 14),
            Text(
              widget.text,
              style: TextStyle(
                color: hover ? Colors.white : ProfileView.text,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: hover ? Colors.white.withOpacity(0.6) : ProfileView.sub.withOpacity(0.4),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}