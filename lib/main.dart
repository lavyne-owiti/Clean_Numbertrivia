import 'package:cleanarchi/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.green.shade800,
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}