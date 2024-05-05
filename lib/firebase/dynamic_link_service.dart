import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../secret.dart';

class DynamicLinkService {
  Future<String> createDynamicLink(PostModel post) async {
    final String apiKey = firebaseApiKey;
    const String googlePlayLink =
        'https://play.google.com/store/apps/details?id=com.upoint.android';
    const String appleStoreLink = 'https://apps.apple.com/app/id6477217914';
    const String domainUriPrefix = 'https://links.upoint.tw/post';

    final Uri longUrl = Uri.parse('$domainUriPrefix?postId=${post.postId}');

    final Map<String, dynamic> requestPayload = {
      'dynamicLinkInfo': {
        'domainUriPrefix': domainUriPrefix,
        'link': longUrl.toString(),
        'androidInfo': {
          'androidPackageName': 'com.upoint.android',
          'androidFallbackLink': googlePlayLink,
        },
        'iosInfo': {
          'iosBundleId': 'com.upoint.ios',
          'iosFallbackLink': appleStoreLink,
        },
        'socialMetaTagInfo': {
          'socialTitle': post.title,
          'socialDescription': post.introduction,
          'socialImageLink': post.photo,
        }
      },
      'suffix': {'option': 'SHORT'}
    };

    final Uri url = Uri.parse(
        'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=$apiKey');

    final http.Response response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['shortLink'] as String;
    } else {
      throw Exception('Error creating short link: ${response.body}');
    }
  }
}
