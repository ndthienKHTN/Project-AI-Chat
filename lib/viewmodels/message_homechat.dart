import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/assistant_response.dart';
import 'package:project_ai_chat/models/chat_exception.dart';
import 'package:project_ai_chat/models/conversation_model.dart';
import 'package:project_ai_chat/models/message_response.dart';
import 'package:project_ai_chat/services/chat_service.dart';

class MessageModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];
  final List<Conversation> _conversations = [];
  final ChatService _chatService;
  String? _currentConversationId;
  bool _isLoading = false;
  String? _errorMessage;

  MessageModel(this._chatService);

  List<Map<String, dynamic>> get messages => _messages;
  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initializeChat(String assistantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _chatService.fetchAIChat(
        content: "Hi",
        assistantId: assistantId,
      );

      print('✅ Initial chat response:');
      print('Message: ${response.message}');
      print('Remaining Usage: ${response.remainingUsage}');

      _messages.add({
        'sender': 'model',
        'text': response.message,
        'isError': false,
        'remainingUsage': response.remainingUsage,
      });

      _currentConversationId = response.conversationId;
    } catch (e) {
      print('❌ Error in initializing chat:');
      if (e is ChatException) {
        print('Status: ${e.statusCode}');
        print('Message: ${e.message}');
      } else {
        print('Unexpected error: $e');
      }

      _messages.add({
        'sender': 'model',
        'text': e is ChatException
            ? e.message
            : 'Lỗi không xác định khi khởi tạo chat: ${e.toString()}',
        'isError': true,
      });
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String content, String assistantId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _messages.add({
        'sender': 'user',
        'text': content,
        'isError': false,
      });
      notifyListeners();

      print('💬 Sending message:');
      print('Content: $content');
      print('Assistant ID: $assistantId');
      print('Conversation ID: $_currentConversationId');

      final response = await _chatService.sendMessage(
        content: content,
        assistantId: assistantId,
        conversationId: _currentConversationId,
        previousMessages: _messages
            .map((msg) => Message(
                  role: msg['sender'] == 'user' ? 'user' : 'model',
                  content: msg['text'],
                  assistant: Assistant(
                    id: assistantId,
                    model: "dify",
                    name: "Claude 3 Haiku",
                  ),
                  isErrored: msg['isError'] as bool? ?? false,
                ))
            .toList(),
      );

      print('✅ Response received:');
      print('Conversation ID: ${response.conversationId}');
      print('Message: ${response.message}');
      print('Remaining Usage: ${response.remainingUsage}');

      _currentConversationId = response.conversationId;

      _messages.add({
        'sender': 'model',
        'text': response.message,
        'isError': false,
        'remainingUsage': response.remainingUsage,
      });
    } catch (e) {
      print('❌ Error in MessageModel:');
      if (e is ChatException) {
        print('Status: ${e.statusCode}');
        print('Message: ${e.message}');

        if (e.statusCode == 500) {
          _messages.add({
            'sender': 'model',
            'text':
                'Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau hoặc liên hệ hỗ trợ.',
            'isError': true,
          });
        } else {
          _messages.add({
            'sender': 'model',
            'text': e.message,
            'isError': true,
          });
        }
      } else {
        print('Unexpected error: $e');
        _messages.add({
          'sender': 'model',
          'text': 'Lỗi không xác định khi gửi tin nhắn: ${e.toString()}',
          'isError': true,
        });
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int? get lastRemainingUsage {
    if (_messages.isNotEmpty && !_messages.last['isError']) {
      return _messages.last['remainingUsage'] as int?;
    }
    return null;
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
}
