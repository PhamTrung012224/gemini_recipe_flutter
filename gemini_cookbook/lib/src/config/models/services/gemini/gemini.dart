import 'package:gemini_cookbook/src/config/models/objects/prompt_object.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static Future<GenerateContentResponse> generateContent(
      GenerativeModel model,
      PromptObject prompt,
      String additionalInformation,
      List<DataPart>? images) async {
    if (images?.isNotEmpty ?? false) {
      return await GeminiService.generateContentFromMultiModal(
          model, prompt, additionalInformation, images);
    } else {
      return await GeminiService.generateContentFromText(
          model, prompt, additionalInformation);
    }
  }

  static Future<GenerateContentResponse> generateContentFromMultiModal(
    GenerativeModel model,
    PromptObject prompt,
    String additionalInformation,
    List<DataPart>? images,
  ) async {
    final input = [
      Content.multi([
        ...images!,
        TextPart(prompt.prompt),
        TextPart(additionalInformation)
      ])
    ];

    return await model.generateContent(
      input,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        responseMimeType: 'application/json',
      ),
    );
  }

  static Future<GenerateContentResponse> generateContentFromText(
      GenerativeModel model,
      PromptObject prompt,
      String additionalInformation) async {
    final input = [
      Content.multi([TextPart(prompt.prompt), TextPart(additionalInformation)])
    ];
    return await model.generateContent(
      input,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        topK: 32,
        topP: 1,
        responseMimeType: 'application/json',
      ),
    );
  }
}
