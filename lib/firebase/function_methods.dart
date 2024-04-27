import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../secret.dart';

class FunctionMethods {
  Future<String> createPostReminderTask(
      String postId, String title, String text, DateTime remindDateTime) async {
    String res = "";
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
      debugPrint('Task created successfully');
      res = "success";
    } else {
      debugPrint('Failed to create task');
      res = "failed statusCode:${response.statusCode}";
    }
    return res;
  }

  Future<String> deletePostReminderTask(String? taskId,String postId) async {
    String res = "";
    String url =
        'https://asia-east1-$firebaseProjectId.cloudfunctions.net/deletePostReminderTask';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'taskId': taskId,
        "postId": postId
      }),
    );

    if (response.statusCode == 200) {
      debugPrint('Task delete successfully');
      res = "success";
    } else {
      debugPrint('Failed to delete task:${response.body}');
      debugPrint('Failed to delete task:${response.statusCode}');
      res = "failed statusCode:${response.statusCode}";
    }
    return res;
  }
}
