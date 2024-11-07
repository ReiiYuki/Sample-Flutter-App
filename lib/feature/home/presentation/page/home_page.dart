import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sample_todo/feature/home/domain/navigation_config.dart';
import 'package:sample_todo/feature/home/presentation/widget/navigate_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env['APP_NAME']!),
      ),
      body: const Center(
        child: Column(
          children: <Widget>[
            NavigateButton(navigationConfig: NavigationConfig(title: 'Counter', path: '/counter')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Random Pokemon', path: '/pokemon')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Todo List', path: '/todo')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Design', path: '/design')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Overlay', path: '/overlay')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Webview', path: '/browse'))
          ],
        )
      ),
    );
  }
}
