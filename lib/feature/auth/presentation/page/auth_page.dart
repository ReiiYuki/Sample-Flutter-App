import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sample_todo/feature/counter/presentation/widget/counter_label.dart';
import 'package:sample_todo/feature/counter/presentation/widget/increment_button.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.title});
  final String title;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _onUpdateCounter(int counter) {
    setState(() {
      _counter = counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Test"),
      ),
      body: Column(
          children: [
                  CounterLabel(
                    counter: _counter,
                  )
                ],
      ),
      floatingActionButton: IncrementButton(
        counter: _counter,
        onIncrement: _onUpdateCounter,
      ),
    );
  }
}