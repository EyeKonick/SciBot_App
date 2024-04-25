import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter_chat/flutter_chat.dart';
import 'package:scibot_sample/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLocalStorage();
  initApi('api.key');

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/":
            return MaterialPageRoute(
              builder: (context) => const HomePage(),
              settings: const RouteSettings(name: "/"),
            );
          default:
            throw Exception("Non-existent route: ${settings.name}");
        }
      },
    );
  }
}
