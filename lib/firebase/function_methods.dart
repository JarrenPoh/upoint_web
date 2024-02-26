import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secret.dart';

class FunctionMethods {
  Future<void> createPostReminderTask(
      String postId, String title, String text, DateTime remindDateTime) async {
    String url =
        'https://asia-east1-$firebaseProjectId.cloudfunctions.net/createPostReminderTask';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'postId': postId,
        'title': title,
        'text': text,
        'remindDateTime': remindDateTime.toIso8601String(), // 转换为ISO 8601字符串
      }),
    );

    if (response.statusCode == 200) {
      print('Task created successfully');
    } else {
      print('Failed to create task');
    }
  }
}
