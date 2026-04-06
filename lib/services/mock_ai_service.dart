import 'dart:async';

class MockAIService {
  /// Simulates generating an AI response with a specific model.
  static Future<String> generateMockResponse(String input, String modelName) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Throw a random mock error rarely to test error handling (5% chance)
    if (DateTime.now().millisecond % 20 == 0) {
      throw Exception("Simulated network failure");
    }

    final sanitizedInput = input.trim().toLowerCase();

    if (sanitizedInput.contains("hello") || sanitizedInput.contains("hi")) {
      return "Hello! I am $modelName. How can I help you brainstorm today?";
    } else if (sanitizedInput.contains("image") || sanitizedInput.contains("photo") || sanitizedInput.contains("capture")) {
      return "I analyzed your image using $modelName. It looks like a great starting point for a wireframe. I recommend adjusting the contrast and preparing a component hierarchy.";
    } else if (sanitizedInput.contains("voice") || sanitizedInput.contains("audio")) {
      return "I processed your voice note using $modelName. Based on your audio, I suggest prioritizing user authentication in your app's MVP.";
    }

    return "This is a synthetic response from $modelName. You suggested: '$input'. Here is how you can develop it:\n\n1. Validate your core assumption.\n2. Draft a simple prototype.\n3. Gather user feedback rapidly.\n4. Iterate and scale.";
  }
}
