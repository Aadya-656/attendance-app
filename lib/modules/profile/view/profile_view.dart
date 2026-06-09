import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final ProfileController controller =
  Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEEF2FA),

      appBar: AppBar(
        title: const Text("Profile"),
      ),

      body: Center(
        child: Obx(
              () {
            if (controller.profile.value == null) {
              return const CircularProgressIndicator();
            }

            final user =
            controller.profile.value!;

            return Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  user.designation,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  user.office,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}