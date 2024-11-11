import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? error;

  Future<bool> register({
    required String username,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = User(
        username: username,
        email: email,
        password: password,
      );

      final response = await _authService.register(user);

      if (response.success && response.data['user'] != null) {
        // Chỉ lưu thông tin user
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(response.data['user']));

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message ?? 'Đăng ký thất bại';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Register error: $e');
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      if (response.success && response.data != null) {
        final prefs = await SharedPreferences.getInstance();
        // Lưu access token
        if (response.data['token']?['accessToken'] != null) {
          await prefs.setString('token', response.data['token']['accessToken']);
        }
        // Lưu refresh token
        if (response.data['token']?['refreshToken'] != null) {
          await prefs.setString(
              'refreshToken', response.data['token']['refreshToken']);
        }

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        error = response.message ?? 'Đăng nhập thất bại';
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
