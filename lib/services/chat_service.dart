import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/chat_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final Dio dio;
  final SharedPreferences prefs;

  ChatService({required this.dio, required this.prefs}) {
    // Thiết lập base URL và interceptors
    dio.options.baseUrl = 'https://api.dev.jarvis.cx';
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Thêm headers
        final token = prefs.getString('token');
        options.headers['Authorization'] = 'Bearer $token';
        options.headers['x-jarvis-guid'] =
            const Uuid().v4(); // Cần thêm package uuid
        return handler.next(options);
      },
    ));
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
      print('URL: ${dio.options.baseUrl}/api/chat');
      print('Headers: ${dio.options.headers}');
      print('Body: $requestData');

      final response = await dio.post(
        '/api/chat',
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
}
