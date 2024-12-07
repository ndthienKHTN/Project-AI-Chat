import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/bot_request.dart';
import 'package:project_ai_chat/services/bot_service.dart';
import '../models/bot_list.dart';

class BotViewModel extends ChangeNotifier {
  final BotService _service = BotService();
  BotList _botList = BotList.empty();



  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? error;

  // Thông tin phân trang
  int _limit = 10;
  int _offset = 0;
  bool _hasNext = true;

  String _query = '';
  bool _isCreated = false;


  BotList get botList => _botList;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => error != null;
  bool get hasNext => _hasNext;
  String get query => _query;
  bool get isCreated => _isCreated;


  set query(String value) {
    if (_query != value) {
      _query = value;
      fetchBots();
      notifyListeners();
    }
  }


  BotRequest botRequest = BotRequest(
    assistantName: 'My AI Assistant',
    instructions: 'Help users solve problems.',
    description: 'A test bot for demonstration.',
  );

  // BotViewModel() {
  //   init();
  // }
  //
  // Future<void> init() async {
  //   await fetchBots(); // Gọi phương thức fetch dữ liệu khi khởi tạo
  //   notifyListeners();
  // }


  Future<bool> fetchBots() async {
    if (_isLoading) return false;

    _isLoading = true;

    _offset = 0; // Reset lại offset
    _botList = BotList.empty(); // Xóa dữ liệu cũ
    _hasNext = true;

    print('✅ Dô view model rồi nề');

    notifyListeners();

    print('✅ Qua notify rồi');

    try {
      final result = await _service.fetchBots(
          query: _query,
          limit: _limit,
          offset: _offset);

      print('✅ Lấy result rồi: $result');
      // Cập nhật danh sách và trạng thái phân trang
      _botList = result;
      print('✅ RESPONSE BOTS DATA IN BOT VIEW MODEL: $_botList');
      _hasNext = result.hasNext;
      _offset += _limit;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return true;
  }



  Future<void> loadMoreBots() async {
    if (_isLoadingMore || !_hasNext) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final result = await _service.fetchBots(
          query: _query,
          limit: _limit,
          offset: _offset);

      // Cập nhật danh sách và trạng thái phân trang
      _botList.data.addAll(result.data);
      _hasNext = result.hasNext;
      _offset += _limit;
    } catch (e) {
      error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<bool> createBot(BotRequest newBot) {
    return _service.createBot(newBot);
  }

  Future<bool> deleteBot(String id) {
    return _service.deleteBot(id);
  }

  Future<bool> updateBot(BotRequest newBot, String id) {
    return _service.updateBot(newBot, id);
  }
}
