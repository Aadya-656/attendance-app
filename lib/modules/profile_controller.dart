import 'package:get/get.dart';

import 'profile_model.dart';
import 'profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository repository =
  ProfileRepository();

  Rxn<ProfileModel> profile =
  Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    profile.value =
    await repository.getProfile();
  }
}