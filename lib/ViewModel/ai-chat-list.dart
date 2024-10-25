import 'package:flutter/cupertino.dart';

import '../View/HomeChat/model/ai-logo-list.dart';


class AIChatList extends ChangeNotifier {
  List<AIItem> aiItems = [
    AIItem(
      name: 'Copilot',
      logoPath: 'assets/logo/copilot.jpg',
      path: 'path/to/bin-ai',
      tokenCount: 50,
    ),
    AIItem(
      name: 'Monica',
      logoPath: 'assets/logo/monica.png',
      path: 'path/to/monica',
      tokenCount: 60,
    ),
    AIItem(
      name: 'Chat GPT',
      logoPath: 'assets/logo/chat-gpt.jpg',
      path: 'path/to/chat-gpt',
      tokenCount: 70,
    ),
    AIItem(
      name: 'Google',
      logoPath: 'assets/logo/google-logo.png',
      path: 'path/to/jarvis',
      tokenCount: 80,
    ),
  ];

  void addAIItem(AIItem newAIItem) {
    aiItems.add(newAIItem);
    notifyListeners();
  }
}