import 'package:flutter/material.dart';
import 'package:project_ai_chat/View/SplashScreen/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ai_chat/View/SplashScreen/splash_screen.dart';
import 'package:project_ai_chat/utils/theme/theme.dart';
import 'package:project_ai_chat/Provider/KnowledgeBaseProvider.dart';
import 'View/UpgradeVersion/upgrade-version.dart';
import 'ViewModel/message-home-chat.dart';
import 'View/HomeChat/home.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MessageModel()),
        ChangeNotifierProvider(create: (context) => KnowledgeBaseProvider()),
      ],
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
