import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  final _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY']!,
  );

  Future<String> getTypeCodeFromAI(String prompt) async {
    final result = await _model.generateContent([Content.text(prompt)]);
    return result.text?.trim() ?? '';
  }

  Future<String> generate(String prompt) async {
    final result = await _model.generateContent([Content.text(prompt)]);
    return result.text?.trim() ?? '';
  }
}
