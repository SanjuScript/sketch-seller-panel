import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class SendNotification {
  static Future<void> toOne(
      String token, String title, String body) async {
    final response = await http.post(
      Uri.parse(
          'https://5809-2401-4900-4e69-7a6-8cdd-b307-2c2-f8f3.ngrok-free.app/send-notification'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': token,
        'title': title,
        'body': body,
        "extraData": {
          "orderId": "12345",
        }
      }),
    );
    log(response.body);
    if (response.statusCode == 200) {
      log('Notification sent successfully!');
    } else {
      log('Failed to send notification.');
    }
  }
}
