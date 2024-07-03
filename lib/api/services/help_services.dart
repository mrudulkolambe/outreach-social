import 'package:outreach/api/constants/constants.dart';
import 'package:outreach/api/services/api_services.dart';

class HelpService {

  Future<int> createSupportRequest(Map<String, dynamic> body) async {
    final response = await ApiService().post(createSupportAPI, body);
    if (response != null && response.statusCode == 200 || response != null && response.statusCode == 201) {
      return 200;
    } else {
      return 500;
    }
  }
}
