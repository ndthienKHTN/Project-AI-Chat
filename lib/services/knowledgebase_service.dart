import 'package:dio/dio.dart';
import 'package:project_ai_chat/models/response/api_response.dart';
import 'package:project_ai_chat/utils/dio/dio_knowledge_base.dart';

class KnowledgebaseService {
  final dioKB = DioKnowledgeBase().dio;

  Future<ApiResponse> getAllKnowledgeBases(
      String query, int? offset, int? limit) async {
    try {
      final response = await dioKB.get(
        '/knowledge',
        queryParameters: {
          'q': query,
          'limit': limit,
          'offset': offset,
        },
      );
      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Lấy thông tin KB thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Lấy thông tin KB thất bại',
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

  Future<ApiResponse> createKnowledge(
      String knowledgeName, String description) async {
    try {
      final response = await dioKB.post(
        '/knowledge',
        data: {"knowledgeName": knowledgeName, "description": description},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: 'Create new knowledge base successfully',
          data: response.data,
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Fail to create new knowledge base: ${response.data}',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Fail to create new knowledge base';
      if (e.response != null) {
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
        statusCode: e.response!.statusCode ?? 400,
      );
    }
  }

  Future<ApiResponse> editKnowledge(
      String id, String knowledgeName, String description) async {
    try {
      final response = await dioKB.patch(
        '/knowledge/$id',
        data: {"knowledgeName": knowledgeName, "description": description},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: 'Edit knowledge base successfully',
          data: response.data,
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Fail to edit new knowledge base: ${response.data}',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Fail to edit knowledge base';
      if (e.response != null) {
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
        statusCode: e.response!.statusCode ?? 400,
      );
    }
  }

  Future<ApiResponse> deleteKnowledge(String id) async {
    try {
      final response = await dioKB.delete('/knowledge/$id');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: 'Delete knowledge base successfully',
          data: response.data,
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Fail to Delete new knowledge base: ${response.data}',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Fail to Delete knowledge base';
      if (e.response != null) {
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
        statusCode: e.response!.statusCode ?? 400,
      );
    }
  }
}
