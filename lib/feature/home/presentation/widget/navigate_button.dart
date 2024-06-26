import 'package:flutter/material.dart';
import 'package:sample_todo/feature/home/domain/navigation_config.dart';

class NavigateButton extends StatelessWidget {
  const NavigateButton({super.key, required this.navigationConfig});

  final NavigationConfig navigationConfig;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, navigationConfig.path);
      },
      child: Text(navigationConfig.title),
    );
  }
}
