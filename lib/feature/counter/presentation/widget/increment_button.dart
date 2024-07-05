import 'package:flutter/material.dart';
import 'package:sample_todo/feature/counter/utils/increment.dart';

class IncrementButton extends StatelessWidget {
  const IncrementButton({super.key, required this.onIncrement, required this.counter });

  final Function onIncrement;
  final int counter;

  void _incrementCounter() {
    onIncrement(increment(counter));
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
