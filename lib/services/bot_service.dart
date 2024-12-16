import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/bot_request.dart';
import 'package:project_ai_chat/models/prompt_model.dart';
import 'package:project_ai_chat/utils/dio/dio_client.dart';
import 'package:project_ai_chat/models/prompt_list.dart';
import 'package:project_ai_chat/utils/dio/dio_knowledge_base.dart';

import '../models/bot_list.dart';

class BotService {

  final dioKB = DioKnowledgeBase().dio;

  Future<BotList> fetchBots({String? query, required int limit, required int offset}) async {
    try {

      print('🚀 REQUEST PARAM: q=${query}&offset=${offset}&limit=${limit}');

      final response;
      response = await dioKB.get(
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
      final response = await dioKB.delete('/ai-assistant/${id}');

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

      final response = await dioKB.post(
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

      final response = await dioKB.patch(
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
