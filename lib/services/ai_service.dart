import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_config.dart';
import './config_service.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  /// Sends a prompt to the configured OpenClaw / AI backend
  Future<String> getResponse({
    required String prompt,
    required String systemContext,
    String? agentType, // 'concierge' or 'reviewer'
  }) async {
    final config = await AIConfig.fetch();

    // Check if the specific system is enabled
    if (agentType == 'concierge' && !config.isConciergeEnabled) {
      return "The AI Concierge is currently offline to manage system resources.";
    }
    if (agentType == 'reviewer' && !config.isReviewerEnabled) {
      return "The AI Reviewer is currently offline.";
    }

    // Fetched securely from Firestore. Key name: 'anthropic_api_key'
    final String? apiKey = await ConfigService().getSecretKey('anthropic_api_key');
    const String anthropicUrl = "https://api.anthropic.com/v1/messages";

    if (apiKey == null || apiKey.isEmpty) {
      return "System error: Missing AI Configuration. Please contact support.";
    }

    try {
      final response = await http.post(
        Uri.parse(anthropicUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: json.encode({
          'model': 'claude-3-5-sonnet-20240620',
          'max_tokens': 1024,
          'system': systemContext,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'][0]['text'] ?? "I couldn't process that.";
      } else {
        return "System error (Code: ${response.statusCode}) - ${response.body}";
      }
    } catch (e) {
      return "Connection error: $e";
    }
  }

  /// Specialized method for formatting business data for the reviewer
  Future<String> reviewBusinessSubmission(Map<String, dynamic> data) async {
    final context = "You are an expert business verification agent for 'Back 2 Black'. "
        "Review the following submission for accuracy, professionalism, and potential issues. "
        "Identify if it looks like a real business or spam.";
    
    final prompt = "Business Name: ${data['businessName']}\n"
        "Description: ${data['businessDescription']}\n"
        "Category: ${data['businessCategory']}\n"
        "Address: ${data['businessAddress']}\n"
        "Website: ${data['website']}";

    return await getResponse(
      prompt: prompt,
      systemContext: context,
      agentType: 'reviewer',
    );
  }
}
