import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/services/api_services.dart';
import 'package:outreach/utils/toast_manager.dart';

class ReportServices {

  Future<int> createReport(Map<String, dynamic> body) async {
    final response = await ApiService().post(createReportAPI, body);
    if (response != null && response.statusCode == 200 ||
        response != null && response.statusCode == 201) {
          ToastManager.showToastApp('Post reported successfully!');
      return 200;
    } else {
        ToastManager.showToastApp('Something went wrong!');
      return 500;
    }
  }
}
