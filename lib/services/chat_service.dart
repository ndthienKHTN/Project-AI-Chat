import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/api_response.dart';
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

  Future<ApiResponse> getAllConversations(
      String assistantId, String assistantModel) async {
    try {
      final response = await dio.get(
        '/ai-chat/conversations',
        queryParameters: {
          'assistantId': assistantId,
          'assistantModel': assistantModel,
        },
      );
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Lấy thông tin user thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Lấy thông tin user thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = '';
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized, Please Login again';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Internal Server Error';
        }

        final errorData = e.response!.data;
        // Check for custom error messages in the response data
        if (errorData['details'] != null && errorData['details'].isNotEmpty) {
          // Collect all issues in `details` into a single message
          List<String> issues = (errorData['details'] as List<dynamic>)
              .map<String>((detail) => detail['issue'] ?? 'Unknown issue')
              .toList();
          errorMessage = issues.join(', ');
        }
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
