import 'package:flutter/material.dart';
import 'package:flutter_learn/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_learn/chat_page.dart';
import 'package:flutter_learn/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) => AuthService(), child: const ChatApp()));
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
          canvasColor: Colors.transparent,
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.black,
          )),
      home: FutureBuilder<bool>(
          future: context.read<AuthService>().isLoggedIn(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data) {
                return const ChatPage();
              } else {
                return LoginPage();
              }
            }
            return const CircularProgressIndicator();
          }),
      // home: const ChatPage(),
      routes: {'/chat': (context) => const ChatPage()},
    );
  }
}
