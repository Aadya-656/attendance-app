import 'package:get/get.dart';
import 'verification_model.dart';
import 'verification_repository.dart';

class VerificationController extends GetxController {

  final VerificationRepository repository =
  VerificationRepository();

  var attendanceList =
      <VerificationModel>[].obs;

  @override
  void onInit() {
    attendanceList.value =
        repository.getAttendanceList();

    super.onInit();
  }
}