import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ai_chat/View/EmailTab/email.dart';
import 'package:project_ai_chat/View/SplashScreen/splash_screen.dart';
import 'package:project_ai_chat/utils/theme/theme.dart';

import 'Model/message-model.dart';
import 'View/HomeChat/home.dart';
import 'package:provider/provider.dart';
void main()  {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MessageModel(),
      child: MyApp(),
     ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bin AI',
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}


