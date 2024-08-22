import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:upoint_web/models/organizer_model.dart';
import 'package:upoint_web/models/post_model.dart';
import 'dart:convert';
import '../secret.dart';

class FunctionMethods {
  Future<String> sendPostMessaging(
    OrganizerModel organizer,
    PostModel post,
  ) async {
    String res = "";
    String openLink = "https://$host/activity?id=${post.postId}";
    final response = await http.post(
      Uri.parse(
          'https://asia-east1-$firebaseProjectId.cloudfunctions.net/sendPostMessaging'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'organizerUid': organizer.uid,
        'open_link': openLink,
        'title': post.title,
        'organizerName': organizer.username,
      }),
    );
    if (response.statusCode == 200) {
      debugPrint('Task send successfully');
      res = "success";
    } else {
      debugPrint('Failed to send task');
      res = "failed statusCode:${response.statusCode}";
    }
    return res;
  }

  Future<String> createPostReminderTask(
    String postId,
    String title,
    String text,
    DateTime remindDateTime,
  ) async {
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

  Future<String> deletePostReminderTask(String? taskId, String postId) async {
    String res = "";
    String url =
        'https://asia-east1-$firebaseProjectId.cloudfunctions.net/deletePostReminderTask';

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'taskId': taskId, "postId": postId}),
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
