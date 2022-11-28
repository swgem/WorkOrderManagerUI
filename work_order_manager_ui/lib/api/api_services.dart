abstract class ApiServices {
  static const String hostname = 'workordermanagerserver.azurewebsites.net';
  static const int requestTimeoutSeconds = 10;
  static const Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
