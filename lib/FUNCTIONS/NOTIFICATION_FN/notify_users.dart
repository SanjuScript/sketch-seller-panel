import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class SendNotification {
  static Future<void> toSpecificUser(
    String token,
    String title,
    String body, {
    Map<String, dynamic>? extras,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://us-central1-drawing-seller.cloudfunctions.net/api/send-notification',
        ),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'title': title,
          'body': body,
          'extraData': extras
        }),
      );

      log('Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        log('Notification sent successfully!');
      } else {
        log('Failed to send notification: ${response.statusCode}');
      }
    } catch (error) {
      log('Error occurred while sending notification: $error');
    }
  }
}
