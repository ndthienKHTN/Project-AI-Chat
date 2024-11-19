import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/prompt_service.dart';


class PromptListViewModel {
  final PromptService _service;

  PromptListViewModel(this._service);

  PromptRequest pr = PromptRequest(
    category: Category.business,
    limit: 20,
    isFavorite: false,
    isPublic: true
  );

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');  // Lấy accessToken đã lưu
  }

  Future<PromptList> fetchPrompts() async {
    String? accessToken = await getAccessToken();

    if (accessToken == null) {
      // Nếu không có accessToken, có thể ném lỗi hoặc trả về kết quả phù hợp
      throw Exception('Không tìm thấy accessToken');
    }
    return _service.fetchPrompts(pr, accessToken);
  }
}