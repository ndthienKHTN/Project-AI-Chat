import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';

import '../services/prompt_service.dart';

class PromptListViewModel {
  final PromptService _service;

  PromptListViewModel(this._service);

  PromptRequest pr = PromptRequest(
      query: "",
      offset: 0,
      limit: 100,
      category: "",
      isFavorite: false,
      isPublic: true);

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
        isPublic: isPublic);
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
}

