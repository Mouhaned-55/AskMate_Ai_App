import 'dart:convert';

import 'package:http/http.dart' as http;

String apiKey = "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";

class ApiService {
  static String baseUrl = "https://api.openai.com/v1/chat/completions";

  static Map<String, String> headers = {
    "Content-type": "application/json",
    "Authorization": "Bearer $apiKey"
  };

  static Future<String?> sendMessage(String? message) async {
    var response = await http.post(Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": "$message",
          "temperature": 0,
          "max_tokens": 100,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "stop": ["Human:", "AI:"]
        }));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print("Failed to fetch data. Error code: ${response.statusCode}");
      print("Error message: ${response.body}");
      return null;
    }
  }
}
