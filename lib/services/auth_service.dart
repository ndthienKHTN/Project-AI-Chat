import 'package:project_ai_chat/services/dio_client.dart';
import '../models/user_model.dart';
import '../models/api_response.dart';
import 'package:dio/dio.dart';

class AuthService {
  final dio = DioClient().dio;

  Future<ApiResponse> register(User user) async {
    try {
      final response = await dio.post(
        '/auth/sign-up',
        data: user.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse(
          success: true,
          message: 'Đăng ký thành công',
          data: response.data,
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng ký thất bại: ${response.data}',
          statusCode: response.statusCode ?? 400,
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'Lỗi kết nối: $e',
        statusCode: 500,
      );
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/sign-in',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse(
          success: true,
          data: response.data,
          message: 'Đăng nhập thành công',
          statusCode: response.statusCode ?? 200,
        );
      } else {
        return ApiResponse(
          success: false,
          message: 'Đăng nhập thất bại',
          statusCode: response.statusCode ?? 400,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Đăng nhập thất bại';
      if (e.response != null) {
        try {
          errorMessage = e.response?.data['message'] ?? 'Đăng nhập thất bại';
        } catch (_) {
          errorMessage = 'Lỗi không xác định';
        }
      } else {
        errorMessage = 'Lỗi kết nối: ${e.message}';
      }

      return ApiResponse(
        success: false,
        message: errorMessage,
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
