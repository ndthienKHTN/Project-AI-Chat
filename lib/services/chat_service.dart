import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/chat_exception.dart';
import 'package:project_ai_chat/models/chat_response.dart';
import 'package:project_ai_chat/models/message_response.dart';
import 'package:project_ai_chat/services/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final SharedPreferences prefs;
  late final Dio dio;

  ChatService({required this.prefs}) {
    dio = DioClient().dio;
  }

  Future<ChatResponse> sendMessage({
    required String content,
    required String assistantId,
    String? conversationId,
    List<Message>? previousMessages,
  }) async {
    try {
      // Log request data
      final requestData = {
        "content": content,
        "metadata": {
          "conversation": {
            "id": conversationId ?? const Uuid().v4(),
            "messages":
                previousMessages?.map((msg) => msg.toJson()).toList() ?? [],
          }
        },
        "assistant": {
          "id": assistantId,
          "model": "dify",
          "name": "Claude 3 Haiku"
        }
      };

      print('🚀 REQUEST DATA:');
      print('URL: ${dio.options.baseUrl}/api/v1/ai-chat/messages');
      print('Headers: ${dio.options.headers}');
      print('Body: $requestData');

      final response = await dio.post(
        '/ai-chat/messages',
        data: requestData,
      );

      print('✅ RESPONSE DATA: ${response.data}');

      return ChatResponse.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ DioException:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      throw ChatException(
        message: e.response?.data?['message'] ??
            e.message ??
            'Lỗi kết nối tới server',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }

  Future<ChatResponse> fetchAIChat({
    required String content,
    required String assistantId,
  }) async {
    try {
      final requestData = {
        "assistant": {"id": assistantId, "model": "dify"},
        "content": content
      };

      print('🚀 REQUEST DATA:');
      print('URL: ${dio.options.baseUrl}/api/v1/ai-chat');
      print('Headers: ${dio.options.headers}');
      print('Body: $requestData');

      final response = await dio.post(
        '/ai-chat',
        data: requestData,
      );

      print('✅ RESPONSE DATA: ${response.data}');

      if (response.statusCode == 200) {
        return ChatResponse(
          conversationId: response.data['conversationId'],
          message: response.data['message'],
          remainingUsage: response.data['remainingUsage'],
        );
      } else {
        throw ChatException(
          message: 'Lỗi không xác định từ server',
          statusCode: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      print('❌ DioException:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      throw ChatException(
        message: e.response?.data?['message'] ??
            e.message ??
            'Lỗi kết nối tới server',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
