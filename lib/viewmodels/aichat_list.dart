import 'package:flutter/cupertino.dart';

import '../View/HomeChat/model/ai_logo.dart';

class AIChatList extends ChangeNotifier {
  List<AIItem> aiItems = [
    AIItem(
      name: 'Claude 3 Haiku',
      logoPath: 'assets/logo/copilot.jpg',
      tokenCount: 50,
      id: 'claude-3-haiku-20240307',
    ),
    AIItem(
      name: 'GPT-4o mini',
      logoPath: 'assets/logo/monica.png',
      tokenCount: 60,
      id: 'gpt-4o-mini',
    ),
    AIItem(
      name: 'Chat GPT',
      logoPath: 'assets/logo/chat-gpt.jpg',
      tokenCount: 70,
      id: 'gpt-3.5-turbo',
    ),
    AIItem(
      name: 'Google PaLM',
      logoPath: 'assets/logo/google-logo.png',
      tokenCount: 80,
      id: 'palm-2',
    ),
  ];

  void addAIItem(AIItem newAIItem) {
    aiItems.add(newAIItem);
    notifyListeners();
  }

  AIItem? getAIItemById(String id) {
    try {
      return aiItems.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  AIItem? getAIItemByName(String name) {
    try {
      return aiItems.firstWhere((item) => item.name == name);
    } catch (e) {
      return null;
    }
  }
}
