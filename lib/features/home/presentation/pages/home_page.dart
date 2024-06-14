import 'package:flutter/material.dart';
import 'package:sample_todo/features/home/domain/navigation_config.dart';
import 'package:sample_todo/features/home/presentation/widgets/navigate_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Column(
          children: <Widget>[
            NavigateButton(navigationConfig: NavigationConfig(title: 'Counter', path: '/counter')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Random Pokemon', path: '/pokemon')),
            NavigateButton(navigationConfig: NavigationConfig(title: 'Todo', path: '/todo'))
          ],
        )
      ),
    );
  }
}
