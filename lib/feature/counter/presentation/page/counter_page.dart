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
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('test change dependencies');
  }

  @override
  void didUpdateWidget(covariant CounterPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('test update widget');
  }

  @override
  Widget build(BuildContext context) {
    print('test build');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Test"),
      ),
      body: Column(
          children: _counter < 5
              ? [
                  SubscribedCounter(counter: _counter),
                  CounterLabel(
                    counter: _counter,
                  )
                ]
              : [
                  CounterLabel(
                    counter: _counter,
                  )
                ]),
      floatingActionButton: IncrementButton(
        counter: _counter,
        onIncrement: _onUpdateCounter,
      ),
    );
  }
}

class SubscribedCounter extends StatefulWidget {
  final int counter;
  const SubscribedCounter({super.key, required this.counter});

  @override
  State<StatefulWidget> createState() => _SubscribedCounterState();
}

class _SubscribedCounterState extends State<SubscribedCounter>
    with WidgetsBindingObserver {
  Timer timer = Timer.periodic(new Duration(seconds: 1), (timer) {
    print(DateTime.now().millisecondsSinceEpoch);
  });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('test change dependencies : inner');
  }

  @override
  void didUpdateWidget(covariant SubscribedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('test update widget : inner');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    print('test dispose widget : inner');

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      print('paused');
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground
      if (!timer.isActive) {
        // timer = Timer.periodic(new Duration(seconds: 1), (timer) {
        //   print(DateTime.now().millisecondsSinceEpoch);
        // });
      }
      print('resumed');
    } else if (state == AppLifecycleState.inactive) {
      print('inactive');
    } else if (state == AppLifecycleState.detached) {
      print('detached');
    } else if (state == AppLifecycleState.hidden) {
      print('hidden');
      // timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    print('test build : inner');
    return const Text("");
  }
}
