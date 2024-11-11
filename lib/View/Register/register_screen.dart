import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/HomeChat/home.dart';
import 'package:project_ai_chat/View/Login/login_screen.dart';
import 'package:project_ai_chat/constants/colors.dart';
import 'package:project_ai_chat/constants/image_strings.dart';
import 'package:project_ai_chat/constants/sizes.dart';
import 'package:project_ai_chat/constants/text_strings.dart';
import 'package:project_ai_chat/core/Widget/elevated_button.dart';
import 'package:project_ai_chat/core/Widget/outlined_button.dart';
import 'package:project_ai_chat/viewmodels/auth_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email không hợp lệ';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    return null;
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<AuthViewModel>().register(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          );

      if (success && mounted) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công! Vui lòng đăng nhập'),
            backgroundColor: Colors.green,
          ),
        );

        // Chuyển sang màn hình đăng nhập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (mounted) {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(context.read<AuthViewModel>().error ?? 'Đăng ký thất bại'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- Section - 1 --
              Image(
                image: AssetImage(tWelcomeScreenImage),
                height: size.height * 0.2,
              ),
              Text(
                tRegisterTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .headlineLarge,
              ),
              Text(
                tRegisterSubTitle,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
              ),
              // -- .end - 1 --
              SizedBox(height: tFormHeight),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                        label: Text('Username'),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        label: Text('Email'),
                      ),
                      validator: _validateEmail,
                    ),
                    const SizedBox(height: tFormHeight - 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fingerprint),
                        label: Text('Password'),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: tFormHeight - 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(),
                          foregroundColor: tWhiteColor,
                          backgroundColor: tSecondaryColor,
                          side: BorderSide(color: tSecondaryColor),
                          padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                        ),
                        onPressed:
                        context.watch<AuthViewModel>().isLoading ? null : _register,
                        child: context.watch<AuthViewModel>().isLoading
                            ? CircularProgressIndicator()
                            : Text('Đăng ký'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: tFormHeight - 20),
              // -- Section - 3 --
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("OR"),
                  const SizedBox(height: tFormHeight - 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButtonCustom(
                      icon: Image(
                        image: AssetImage(tGoogleLogoImage),
                        width: 20.0,
                      ),
                      onPressed: () {},
                      label: tSignInWithGoogle,
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text.rich(
                          TextSpan(
                              text: tAlreadyHaveAnAccount,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyLarge,
                              children: const[
                                TextSpan(
                                  text: " " + tLogin,
                                  style: TextStyle(color: Colors.blue),
                                )
                              ]
                          )
                      ))
                ],
              )
              // -- .end - 3--
            ],
          ),
        )
      ),
    );
  }
}
