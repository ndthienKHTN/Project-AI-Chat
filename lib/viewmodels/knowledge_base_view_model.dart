import 'package:flutter/cupertino.dart';
import 'package:project_ai_chat/models/knowledge.dart';
import 'package:project_ai_chat/services/knowledgebase_service.dart';

class KnowledgeBaseProvider with ChangeNotifier {
  final KnowledgebaseService _kbService = KnowledgebaseService();
  final List<Knowledge> _knowledgeBases = [];
  bool isLoading = false;
  String? error;

  // loadmore kb
  int? _offset = 0;
  int? _limit = 8;
  bool _hasNext = true;
  String _query = '';
  // load more kb
  bool get hasNext => _hasNext;

  Future<void> query(String value) async {
    if (_query != value) {
      _query = value;
      fetchAllKnowledgeBases(isLoadMore: false);
      notifyListeners();
    }
  }

  List<Knowledge> get knowledgeBases => _knowledgeBases;

  Future<void> fetchAllKnowledgeBases({bool isLoadMore = false}) async {
    if (isLoadMore && _hasNext == false) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    if (isLoadMore == false) {
      _offset = 0;
      _hasNext = true;
    }

    final response = await _kbService.getAllKnowledgeBases(_query, _offset, _limit);

    if (response.success && response.data != null) {
      if (isLoadMore == false) {
        _knowledgeBases.clear();
      }
      _knowledgeBases.addAll(
        (response.data['data'] as List<dynamic>)
            .map((item) => Knowledge.fromJson(item)),
      );
      _offset = response.data['meta']["offset"] + _limit;
      _hasNext = response.data['meta']["hasNext"];
      isLoading = false;
      notifyListeners();
    } else {
      isLoading = false;
      error = response.message;
      notifyListeners();
      // logout();
      // throw response;
    }
  }

  Future<bool> addKnowledgeBase(
      String knowledgeName, String description) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response =
          await _kbService.createKnowledge(knowledgeName, description);

      if (response.success) {
        Knowledge newKnowledge = Knowledge(
          id: response.data['id'],
          name: response.data['knowledgeName'],
          description: response.data['description'],
          imageUrl:
              "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
        );
        _knowledgeBases.add(newKnowledge);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message ?? 'Đăng ký thất bại';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editKnowledgeBase(
      String id, int index, String knowledgeName, String description) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response =
          await _kbService.editKnowledge(id, knowledgeName, description);

      if (response.success) {
        // update knowledge base in the list
        _knowledgeBases[index] = Knowledge(
          id: id,
          name: knowledgeName,
          description: description,
          imageUrl:
              "https://img.freepik.com/premium-photo/green-white-graphic-stack-barrels-with-green-top_1103290-132885.jpg",
        );

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message ?? 'Đăng ký thất bại';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteKnowledgeBase(String id, int index) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _kbService.deleteKnowledge(id);

      if (response.success) {
        // delete knowledge base in the list
        _knowledgeBases.removeAt(index);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message ?? 'Đăng ký thất bại';
        return false;
      }
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
