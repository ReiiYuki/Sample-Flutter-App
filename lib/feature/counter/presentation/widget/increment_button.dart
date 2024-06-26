import 'package:flutter/material.dart';

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key, required this.onIncrement, required this.counter });

  final Function onIncrement;
  final int counter;

  void _incrementCounter() {
    onIncrement(counter + 1);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}
