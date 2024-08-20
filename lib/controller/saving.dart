import 'package:get/get.dart';

enum SavingState { no, uploading, uploaded }

class SavingController extends GetxController {
  SavingState savingState = SavingState.no;

  void setSavingState(SavingState state) {
    savingState = state;
    update();
  }
}
