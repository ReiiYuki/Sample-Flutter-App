import 'dart:math';

import 'package:flutter/material.dart';

class RandomPokemonButton extends StatelessWidget {
  const RandomPokemonButton({super.key, required this.onRandom });

  final void Function(int number) onRandom;

  _random() {
    onRandom(Random().nextInt(100));
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _random,
      tooltip: 'Random',
      child: const Icon(Icons.refresh),
    );
  }
}
