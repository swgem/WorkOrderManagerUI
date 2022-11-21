abstract class ApiServices {
  static const String ip = 'localhost';
  static const String port = '7189';
  static const int requestTimeoutSeconds = 10;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
