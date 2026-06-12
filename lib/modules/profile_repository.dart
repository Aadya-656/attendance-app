import 'profile_model.dart';

class ProfileRepository {
  Future<ProfileModel> getProfile() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    return ProfileModel(
      name: "Reva Singh",
      designation: "Module Lead",
      office: "Bangalore Office",
    );
  }
}