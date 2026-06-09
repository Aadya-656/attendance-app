import 'package:get/get.dart';

import '../model/profile_model.dart';
import '../repository/profile_repository.dart';

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