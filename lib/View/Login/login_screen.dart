import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/HomeChat/home.dart';
import 'package:project_ai_chat/View/Register/register_screen.dart';
import 'package:project_ai_chat/constants/colors.dart';
import 'package:project_ai_chat/constants/image_strings.dart';
import 'package:project_ai_chat/constants/sizes.dart';
import 'package:project_ai_chat/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                tLoginTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                tLoginSubTitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // -- .end - 1 --

              // -- Section - 2 --
              Form(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: tFormHeight - 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            label: Text(tEmail)
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.fingerprint),
                          label: Text(tPassword),
                          suffixIcon: IconButton(
                              onPressed: null,
                              icon: Icon(Icons.remove_red_eye_sharp)),
                        ),
                      ),
                      const SizedBox(height: tFormHeight - 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: const Text(tForgetPassword, style: TextStyle(color: Colors.blue))),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeChat()));
                            },
                            child: Text(tLogin.toUpperCase())),
                      )
                    ],
                  ),
                ),
              ),
              // -- .end - 2--

              // -- Section - 3 --
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("OR"),
                  const SizedBox(height: tFormHeight - 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Image(
                        image: AssetImage(tGoogleLogoImage),
                        width: 20.0,
                      ),
                      onPressed: () {},
                      label: Text(tSignInWithGoogle),
                    ),
                  ),
                  const SizedBox(height: tFormHeight - 20),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()));
                      },
                      child: Text.rich(
                        TextSpan(
                          text: tDontHaveAnAccount,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: const[
                            TextSpan(
                              text: " " + tRegister,
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
        ),
      )),
    );
  }
}
