import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

import 'config/theme.dart';
import 'screens/screens.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SendbirdSdk.setup("BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App UI',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/chat', page: () => const ChatScreen()),
      ],
    );
  }
}
