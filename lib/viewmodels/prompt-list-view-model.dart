import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';
import 'package:provider/provider.dart';

import '../services/prompt_service.dart';


class PromptListViewModel{
  final PromptService _service = PromptService();
  late final PromptList allprompts;

  PromptRequest pr = PromptRequest(
    query: "",
    offset: 0,
    limit: 100,
    category: "",
    isFavorite: false,
    isPublic: true
  );

  Future<PromptList> fetchAllPrompts() async {
    allprompts = await _service.fetchAllPrompts();
    return allprompts;
  }

  Future<PromptList> fetchPrompts({
    required String category,
    String query = '',
    bool isFavorite = false,
    required bool isPublic,
  }) async {
    pr = pr.copyWith(
      category: category,
      query: query,
      isFavorite: isFavorite,
      isPublic: isPublic
    );
    print("-------------------->>>>>>> ${pr.category}");
    return _service.fetchPrompts(pr);
  }

  Future<bool> toggleFavorite(String promptId, bool isFavorite) {
    return _service.toggleFavorite(promptId, isFavorite);
  }

  Future<bool> createPrompt(PromptRequest newPrompt) {
    return _service.createPrompt(newPrompt);
  }

  Future<bool> deletePrompt(String id) {
    return _service.deletePrompt(id);
  }

  Future<bool> updatePrompt(PromptRequest newPrompt, String promptId) {
    return _service.updatePrompt(newPrompt, promptId);
  }


}