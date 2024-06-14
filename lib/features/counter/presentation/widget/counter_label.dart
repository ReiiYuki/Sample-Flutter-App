import 'package:flutter/material.dart';

class CounterLabel extends StatelessWidget {
  const CounterLabel({super.key, required this.counter});

  final int counter;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      );
  }
}
