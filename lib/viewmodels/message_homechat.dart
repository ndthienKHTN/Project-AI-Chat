import 'package:flutter/material.dart';
import 'package:project_ai_chat/models/assistant_response.dart';
import 'package:project_ai_chat/models/chat_exception.dart';
import 'package:project_ai_chat/models/message_response.dart';
import 'package:project_ai_chat/services/chat_service.dart';

class MessageModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _messages = [];
  final ChatService _chatService;
  String? _currentConversationId;
  bool _isLoading = false;

  MessageModel(this._chatService);

  List<Map<String, dynamic>> get messages => _messages;
  bool get isLoading => _isLoading;

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
      } else {
        print('Unexpected error: $e');
      }

      _messages.add({
        'sender': 'model',
        'text': e is ChatException
            ? e.message
            : 'Lỗi không xác định: ${e.toString()}',
        'isError': true,
      });
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
}