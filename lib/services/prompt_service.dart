// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// class PromptService {
//   final Dio dio;
//   final SharedPreferences prefs;
//
//   PromptService({required this.dio, required this.prefs}) {
//     // Thiết lập base URL và interceptors
//     dio.options.baseUrl = 'https://api.dev.jarvis.cx';
//     dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         // Thêm headers
//         final token = prefs.getString('token');
//         options.headers['Authorization'] = 'Bearer $token';
//         options.headers['x-jarvis-guid'] = const Uuid().v4();
//         return handler.next(options);
//       },
//     ));
//   }
//
//   Future<List<dynamic>> fetchPrompts({
//     String? query,
//     String? category,
//     bool? isFavorite,
//     bool? isPublic,
//     int? limit,
//     int? offset,
//   }) async {
//     try {
//       final requestData = {
//         if (query != null) 'query': query,
//         if (category != null) 'category': category,
//         if (isFavorite != null) 'isFavorite': isFavorite,
//         if (isPublic != null) 'isPublic': isPublic,
//         if (limit != null) 'limit': limit,
//         if (offset != null) 'offset': offset,
//       };
//
//       print('🚀 REQUEST DATA: $requestData');
//
//       final response = await dio.post(
//         '/api/v1/prompts',
//         data: requestData,
//       );
//
//       print('✅ RESPONSE DATA: ${response.data}');
//       return response.data['results']; // Điều chỉnh theo response thực tế
//     } on DioException catch (e) {
//       print('❌ DioException:');
//       print('Status: ${e.response?.statusCode}');
//       print('Data: ${e.response?.data}');
//       print('Message: ${e.message}');
//
//       throw Exception(
//         e.response?.data?['message'] ?? e.message ?? 'Lỗi kết nối tới server',
//       );
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/services/dio_client.dart';
import 'package:project_ai_chat/viewmodels/prompt-list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PromptService {
  // final Dio dio;
  // final SharedPreferences prefs;
  //
  // PromptService({required this.dio, required this.prefs}) {
  //   // Thiết lập base URL và interceptors
  //   dio.options.baseUrl = 'https://api.dev.jarvis.cx';
  //   dio.interceptors.add(InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       // Thêm headers
  //       final token = prefs.getString('token');
  //       options.headers['Authorization'] = 'Bearer $token';
  //       options.headers['x-jarvis-guid'] = const Uuid().v4();
  //       return handler.next(options);
  //     },
  //   ));
  // }

  final dio = DioClient().dio;

  Future<PromptList> fetchPrompts(PromptRequest request, String accessToken) async {
    try {
      final requestData = request.toJson();

      print('🚀 REQUEST DATA: $requestData');

      final response = await dio.get(
        '/prompts',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: requestData,
      );

      print('✅ RESPONSE DATA: ${response.data}');

      // Parse dữ liệu từ JSON thành PromptList
      return PromptList.fromJson(response.data);
    } on DioException catch (e) {
      print('❌ DioException:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Lỗi kết nối tới server',
      );
    }
  }

  Future<void> toggleFavorite(String promptId, bool isFavorite) async {
    try {
      final response = await dio.patch(
        '/api/v1/prompts/$promptId/favorite',
        data: {'isFavorite': isFavorite},
      );

      print('✅ TOGGLE FAVORITE RESPONSE: ${response.data}');
    } on DioException catch (e) {
      print('❌ DioException khi toggle favorite:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Không thể thay đổi trạng thái yêu thích',
      );
    }
  }

  Future<void> deletePrompt(String promptId) async {
    try {
      final response = await dio.delete('/api/v1/prompts/$promptId');

      print('✅ DELETE PROMPT RESPONSE: ${response.data}');
    } on DioException catch (e) {
      print('❌ DioException khi xóa prompt:');
      print('Status: ${e.response?.statusCode}');
      print('Data: ${e.response?.data}');
      print('Message: ${e.message}');

      throw Exception(
        e.response?.data?['message'] ?? e.message ?? 'Không thể xóa prompt',
      );
    }
  }
}

