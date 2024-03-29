import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  final String? apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<String> sttResponse(String prompt) async {
    try {
      final res = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {
                'role': 'user',
                'content':
                    'Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.',
              }
            ],
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content.trim();
        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
            final res = await dallEAPI(prompt);
            return res;
          case 'No':
          case 'no':
          case 'No.':
          case 'no.':
            final res = await chatGPTAPI(prompt);
            return res;
        }
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    try {
      messages.add({'role': 'user', 'content': prompt});
      final res = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": messages,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content.trim();
        messages.add({'role': 'assistant', 'content': content});
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    try {
      messages.add({'role': 'user', 'content': prompt});
      final res = await http.post(
          Uri.parse("https://api.openai.com/v1/images/generations"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          body: jsonEncode({
            "prompt" : prompt,
            "n" : 1,
          }));
      print(res.body);
      if (res.statusCode == 200) {
        String imageUrl =
        jsonDecode(res.body)['data'][0]['url'];
        imageUrl.trim();
        messages.add({'role': 'assistant', 'content': imageUrl});
        return imageUrl;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
