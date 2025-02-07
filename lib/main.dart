import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_chat_app/Controller/themeNotifier.dart';
import 'package:gemini_chat_app/Screens/Themes/themes.dart';
import 'package:gemini_chat_app/Screens/onboarding.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: "Chat App with Gemini",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: Onboarding(),
    );
  }
}
