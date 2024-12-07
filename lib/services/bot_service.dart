import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/bot_request.dart';
import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/utils/dio/dio_client.dart';
import 'package:project_ai_chat/models/prompt_list.dart';

import '../models/bot_list.dart';

const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjU5YWY1NWRjLTNlOWMtNDNhYi1hMWIyLTA5NTY4ZjQ0OTBjMyIsImVtYWlsIjoiYWxleGllOTkxMUBnbWFpbC5jb20iLCJpYXQiOjE3MzM1NDEwMTYsImV4cCI6MTczMzYyNzQxNn0.RZJ8Co8BQHwksZLCGb_8YPWi57S3hzcmzgbtdFXR7gs";

class BotService {


  final dio = Dio(BaseOptions(
    baseUrl: "https://knowledge-api.jarvis.cx/kb-core/v1",
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  ));

  Future<BotList> fetchBots({String? query, required int limit, required int offset}) async {
    try {

      print('🚀 REQUEST PARAM: q=${query}&offset=${offset}&limit=${limit}');

      final response;
      response = await dio.get(
            '/ai-assistant?q=${query}&order=DESC&offset=${offset}&limit=${limit}&is_favorite&is_published');

      print('✅ RESPONSE BOTS DATA: ${response.data}');

      // Parse dữ liệu từ JSON thành PromptList
      return BotList.fromJson(response.data);
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

  Future<bool> deleteBot(String id) async {
    try {
      final response = await dio.delete('/ai-assistant/${id}');

      print('✅ DELETE PROMPT RESPONSE CODE: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      }
      return false;
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

  Future<bool> createBot(BotRequest newBot) async {
    try {
      final requestData = newBot.toJson();

      print('🚀 REQUEST DATA: $requestData');

      final response = await dio.post(
        '/ai-assistant',
        data: requestData,
      );

      print('✅ CREATE NEW BOT RESPONSE: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
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

  Future<bool> updateBot(BotRequest newBot, String id) async {
    try {
      final requestData = newBot.toJson();

      print('🚀 REQUEST DATA: $requestData');

      final response = await dio.patch(
        '/ai-assistant/${id}',
        data: requestData,
      );

      print('✅ UPDATE BOT RESPONSE: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
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
}
