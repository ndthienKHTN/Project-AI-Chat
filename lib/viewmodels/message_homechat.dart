import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/HomeChat/model/ai_logo.dart';
import 'package:project_ai_chat/models/assistant_response.dart';
import 'package:project_ai_chat/models/chat_exception.dart';
import 'package:project_ai_chat/models/conversation_model.dart';
import 'package:project_ai_chat/models/message_response.dart';
import 'package:project_ai_chat/services/chat_service.dart';

class MessageModel extends ChangeNotifier {
  final List<Message> _messages = [];
  final List<Conversation> _conversations = [];
  final ChatService _chatService;
  String? _currentConversationId;
  int? _remainingUsage;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isSending = false;
  MessageModel(this._chatService);

  int? get remainingUsage => _remainingUsage;
  List<Message> get messages => _messages;
  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSending => _isSending;

  Future<void> initializeChat(String assistantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _messages.clear();
      _currentConversationId = null;

      final response = await _chatService.fetchAIChat(
        content: "Hi",
        assistantId: assistantId,
      );

      print('✅ Initial chat response:');
      print('Message: ${response.message}');
      print('Remaining Usage: ${response.remainingUsage}');

      _messages.add(Message(
        role: 'model',
        content: response.message,
        assistant: Assistant(
          id: assistantId,
          model: "dify",
          name: "AI Assistant",
        ),
        isErrored: false,
      ));

      _currentConversationId = response.conversationId;
      _remainingUsage = response.remainingUsage;
      notifyListeners();
    } catch (e) {
      print('❌ Error in initializing chat:');
      if (e is ChatException) {
        print('Status: ${e.statusCode}');
        print('Message: ${e.message}');
      } else {
        print('Unexpected error: $e');
      }

      _messages.add(Message(
        role: 'model',
        content: e is ChatException
            ? e.message
            : 'Lỗi không xác định khi khởi tạo chat: ${e.toString()}',
        assistant: Assistant(
          id: assistantId,
          model: "dify",
          name: "AI Assistant",
        ),
        isErrored: true,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content, AIItem assistant) async {
    try {
      _isSending = true;
      notifyListeners();

      _messages.add(Message(
        role: 'user',
        content: content,
        assistant: Assistant(
          id: assistant.id,
          model: "dify",
          name: assistant.name,
        ),
        isErrored: false,
      ));
      notifyListeners();

      print('💬 Sending message:');
      print('Content: $content');
      print('Assistant ID: ${assistant.id}');
      print('Conversation ID: $_currentConversationId');

      final response = await _chatService.sendMessage(
        content: content,
        assistantId: assistant.id,
        conversationId: _currentConversationId,
        previousMessages: _messages,
      );

      print('✅ Response received:');
      print('Conversation ID: ${response.conversationId}');
      print('Message: ${response.message}');
      print('Remaining Usage: ${response.remainingUsage}');

      _currentConversationId = response.conversationId;
      _remainingUsage = response.remainingUsage;
      notifyListeners();

      _messages.add(Message(
        role: 'model',
        content: response.message,
        assistant: Assistant(
          id: assistant.id,
          model: "dify",
          name: assistant.name,
        ),
        isErrored: false,
      ));
    } catch (e) {
      print('❌ Error in MessageModel:');
      if (e is ChatException) {
        print('Status: ${e.statusCode}');
        print('Message: ${e.message}');

        if (e.statusCode == 500) {
          _messages.add(Message(
            role: 'model',
            content:
                'Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.',
            assistant: Assistant(
              id: assistant.id,
              model: "dify",
              name: "AI Assistant",
            ),
            isErrored: true,
          ));
        } else {
          _messages.add(Message(
            role: 'model',
            content: e.message,
            assistant: Assistant(
              id: assistant.id,
              model: "dify",
              name: "AI Assistant",
            ),
            isErrored: true,
          ));
        }
      } else {
        print('Unexpected error: $e');
        _messages.add(Message(
          role: 'model',
          content: 'Lỗi không xác định khi gửi tin nhắn: ${e.toString()}',
          assistant: Assistant(
            id: assistant.id,
            model: "dify",
            name: "AI Assistant",
          ),
          isErrored: true,
        ));
      }
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllConversations(
      String assistantId, String assistantModel) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response =
        await _chatService.getAllConversations(assistantId, assistantModel);

    if (response.success && response.data != null) {
      _conversations.clear();
      _conversations.addAll(
        (response.data['items'] as List<dynamic>)
            .map((item) => Conversation.fromJson(item)),
      );
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      _errorMessage = response.message;
      notifyListeners();
      // logout();
      throw response;
    }
  }

  Future<void> loadConversationHistory(
      String assistantId, String conversationId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _chatService.fetchConversationHistory(
        conversationId: conversationId,
        assistantId: assistantId,
      );

      _messages.clear(); // Xóa tin nhắn cũ trước khi thêm lịch sử mới
      _currentConversationId =
          conversationId; // Cập nhật ID cuộc hội thoại hiện tại

      // Xử lý messages nhận được
      for (var message in response.items) {
        _messages.add(Message(
          role: 'user',
          content: message.query,
          assistant: Assistant(
            id: assistantId,
            model: "dify",
            name: "AI Assistant",
          ),
          isErrored: false,
        ));
        _messages.add(Message(
          role: 'model',
          content: message.answer,
          assistant: Assistant(
            id: assistantId,
            model: "dify",
            name: "AI Assistant",
          ),
          isErrored: false,
        ));
      }
    } catch (e) {
      print('❌ Error loading conversation history: $e');
      // Xử lý lỗi tương tự như các method khác
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
