import 'package:http/http.dart' as http;

class ApiServices {
  static const String ip = 'localhost';
  static const String port = '5189';
  static const String workOrderUrl = 'http://${ip}:${port}/api/WorkOrder';

  static Future fetchWorkOrder() async {
    return await http.get(Uri.parse(workOrderUrl));
  }
}
